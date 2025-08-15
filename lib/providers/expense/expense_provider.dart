import 'dart:async';

import 'package:flutter/material.dart';
import '../../models/expense.dart';
import '../../services/expense_service.dart';
import '../../services/service_provider.dart';

/// A provider that manages expense data and operations.
/// 
/// This class follows the separation of concerns principle by delegating
/// business logic to the ExpenseService and focusing on UI state management.
class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _expenseService;
  
  List<Expense> _expenses = [];
  List<Map<String, dynamic>> _expensesWithTags = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  final _expenseStreamController = StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<Map<String, dynamic>> get expensesWithTags => List.unmodifiable(_expensesWithTags);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  Future<void> get initializationDone => _initFuture;
  late Future<void> _initFuture;

  Stream<List<Map<String, dynamic>>> get expensesStream => _expenseStreamController.stream;

  ExpenseProvider({
    ExpenseService? expenseService,
  }) : _expenseService = expenseService ?? ServiceProvider.instance.expenseService {
    _initFuture = _initializeData();
  }

  Future<void> _addTestData() async {
    final now = DateTime.now();
    final testExpenses = [
      Expense(
        id: '${now.millisecondsSinceEpoch}_1',
        userId: 'test_user',
        item: 'Cơm tấm sườn',
        amount: 45000.0,
        currency: 'VND',
        date: now.subtract(const Duration(days: 1)),
        description: 'Bữa trưa văn phòng',
        location: 'Quán cơm tấm',
        createdAt: now,
        updatedAt: now,
      ),
      Expense(
        id: '${now.millisecondsSinceEpoch}_2',
        userId: 'test_user',
        item: 'Grab',
        amount: 32000.0,
        currency: 'VND',
        date: now.subtract(const Duration(days: 2)),
        description: 'Di chuyển đến văn phòng',
        location: 'Grab',
        createdAt: now,
        updatedAt: now,
      ),
      Expense(
        id: '${now.millisecondsSinceEpoch}_3',
        userId: 'test_user',
        item: 'Siêu thị',
        amount: 235000.0,
        currency: 'VND',
        date: now.subtract(const Duration(days: 3)),
        description: 'Mua đồ ăn trong tuần',
        location: 'VinMart',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final expense in testExpenses) {
      await _expenseService.createExpense(expense, []);
    }
  }

  // Tag and currency operations have been moved to dedicated providers:
  // - TagProvider for tag operations
  // - CurrencyProvider for currency operations

  @override
  void dispose() {
    _expenseStreamController.close();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      var expensesWithTags = await _expenseService.getAllExpensesWithTags();
      if (expensesWithTags.isEmpty) {
        await _addTestData();
        expensesWithTags = await _expenseService.getAllExpensesWithTags();
      }
      
      _expensesWithTags = expensesWithTags;
      _expenses = expensesWithTags.map((e) => e['expense'] as Expense).toList();
      _expenseStreamController.add(_expensesWithTags);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize data: ${e.toString()}');
    }
  }

  Future<void> loadExpenses() async {
    try {
      _setLoading(true);
      final expensesWithTags = await _expenseService.getAllExpensesWithTags();
      
      _expensesWithTags = expensesWithTags;
      _expenses = expensesWithTags.map((e) => e['expense'] as Expense).toList();
      _expenseStreamController.add(_expensesWithTags);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load expenses: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Private methods for internal use
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  // Public methods for testing
  void setLoading(bool loading) {
    _setLoading(loading);
  }

  void setError(String error) {
    _setError(error);
  }

  void clearError() {
    _clearError();
  }
  
  // Expose _loadExpenses for testing
  Future<void> loadExpensesForTesting() async {
    await loadExpenses();
  }

  // Add a new expense to the database and refresh the expenses list
  Future<String?> addExpense(Expense expense, List<String> tagIds) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Create the expense using the service
      final expenseId = await _expenseService.createExpense(expense, tagIds);
      
      // Reload expenses to update the UI
      await loadExpenses();
      
      _setLoading(false);
      return expenseId;
    } catch (e) {
      _setError('Failed to add expense: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }
  
  // Update an existing expense in the database and refresh the expenses list
  Future<bool> updateExpense(Expense expense, List<String> tagIds) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Update the expense using the service
      await _expenseService.updateExpense(expense, tagIds);
      
      // Reload expenses to update the UI
      await loadExpenses();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update expense: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Delete an expense from the database and refresh the expenses list
  Future<bool> deleteExpense(String expenseId) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Delete the expense using the service
      await _expenseService.deleteExpense(expenseId);
      
      // Reload expenses to update the UI
      await loadExpenses();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete expense: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Get expenses grouped by tag
  Future<Map<String, List<Expense>>> getExpensesGroupedByTag({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      final result = await _expenseService.getExpensesGroupedByTag(
        startDate: startDate,
        endDate: endDate,
      );
      
      _setLoading(false);
      return result;
    } catch (e) {
      _setError('Failed to get expenses grouped by tag: ${e.toString()}');
      _setLoading(false);
      return {};
    }
  }

  // Get an expense with its tags
  Future<Map<String, dynamic>?> getExpenseWithTags(String expenseId) async {
    try {
      _setLoading(true);
      _clearError();
      
      final result = await _expenseService.getExpenseWithTags(expenseId);
      
      _setLoading(false);
      return result;
    } catch (e) {
      _setError('Failed to get expense with tags: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }
}