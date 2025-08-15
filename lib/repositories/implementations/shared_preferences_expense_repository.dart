import 'dart:convert';

import '../../models/expense.dart';
import '../../repositories/expense_repository.dart';
import '../../services/storage/storage_service.dart';

/// Implementation of [ExpenseRepository] using SharedPreferences for storage.
/// 
/// This class follows the Single Responsibility Principle by focusing only on
/// expense-related data operations.
class SharedPreferencesExpenseRepository implements ExpenseRepository {
  static const String _expensesKey = 'expenses_data';
  
  final StorageService _storageService;
  List<Expense>? _expensesCache;
  
  SharedPreferencesExpenseRepository(this._storageService);
  
  /// Loads expenses from storage.
  Future<List<Expense>> _loadExpenses() async {
    if (_expensesCache != null) return _expensesCache!;
    
    final expensesJson = await _storageService.getString(_expensesKey);
    
    if (expensesJson == null) {
      _expensesCache = [];
      return _expensesCache!;
    }
    
    final List<dynamic> expensesList = json.decode(expensesJson);
    _expensesCache = expensesList.map((json) => Expense.fromJson(json)).toList();
    return _expensesCache!;
  }
  
  /// Saves expenses to storage.
  Future<void> _saveExpenses(List<Expense> expenses) async {
    final expensesJson = json.encode(expenses.map((e) => e.toJson()).toList());
    await _storageService.setString(_expensesKey, expensesJson);
    _expensesCache = expenses;
  }
  
  @override
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final expenses = await _loadExpenses();
    
    var filteredExpenses = expenses.where((expense) {
      if (startDate != null && expense.date.isBefore(startDate)) return false;
      if (endDate != null && expense.date.isAfter(endDate)) return false;
      if (minAmount != null && expense.amount < minAmount) return false;
      if (maxAmount != null && expense.amount > maxAmount) return false;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!(expense.description?.toLowerCase().contains(query) ?? false) &&
            !(expense.notes?.toLowerCase().contains(query) ?? false) &&
            !(expense.location?.toLowerCase().contains(query) ?? false) &&
            !expense.item.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sort by date (newest first)
    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    if (offset != null) {
      filteredExpenses = filteredExpenses.skip(offset).toList();
    }
    if (limit != null) {
      filteredExpenses = filteredExpenses.take(limit).toList();
    }

    return filteredExpenses;
  }
  
  @override
  Future<Expense?> getExpenseById(String id) async {
    final expenses = await _loadExpenses();
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<String> insertExpense(Expense expense) async {
    final expenses = await _loadExpenses();
    final newExpense = expense.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expenses.add(newExpense);
    await _saveExpenses(expenses);
    return newExpense.id;
  }
  
  @override
  Future<void> updateExpense(Expense expense) async {
    final expenses = await _loadExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense.copyWith(updatedAt: DateTime.now());
      await _saveExpenses(expenses);
    }
  }
  
  @override
  Future<void> deleteExpense(String id) async {
    final expenses = await _loadExpenses();
    expenses.removeWhere((expense) => expense.id == id);
    await _saveExpenses(expenses);
  }
  
  @override
  Future<List<Expense>> searchExpenses(String query) async {
    return await getExpenses(searchQuery: query);
  }
  
  @override
  Future<double> getMonthlySpending(int year, int month) async {
    final expenses = await _loadExpenses();
    return expenses
        .where((expense) => expense.date.year == year && expense.date.month == month)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
  }
  
  @override
  Future<List<Map<String, dynamic>>> getSpendingTrends({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await _loadExpenses();
    
    var filteredExpenses = expenses.where((expense) {
      if (startDate != null && expense.date.isBefore(startDate)) return false;
      if (endDate != null && expense.date.isAfter(endDate)) return false;
      return true;
    }).toList();

    final monthlySpending = <String, double>{};
    
    for (final expense in filteredExpenses) {
      final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlySpending[monthKey] = (monthlySpending[monthKey] ?? 0.0) + expense.amount;
    }

    return monthlySpending.entries
        .map((entry) => {
          'month': entry.key,
          'totalAmount': entry.value,
        })
        .toList()
      ..sort((a, b) => (a['month'] as String).compareTo(b['month'] as String));
  }
  
  @override
  Future<String> exportToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await getExpenses(startDate: startDate, endDate: endDate);

    final csvData = StringBuffer();
    csvData.writeln('Date,Amount,Description,Location,Payment Method,Notes');

    for (final expense in expenses) {
      csvData.writeln([
        expense.date.toIso8601String().split('T')[0],
        expense.amount.toString(),
        _escapeCsvField(expense.description ?? ''),
        _escapeCsvField(expense.location ?? ''),
        _escapeCsvField(expense.paymentMethod ?? ''),
        _escapeCsvField(expense.notes ?? ''),
      ].join(','));
    }

    return csvData.toString();
  }
  
  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }
}