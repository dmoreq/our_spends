import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

import '../models/tag.dart';
import '../models/expense_tag.dart';
import '../models/currency.dart';

class DatabaseService {
  static const String _expensesKey = 'expenses_data';
  static const String _tagsKey = 'tags_data';
  static const String _expenseTagsKey = 'expense_tags_data';
  static const String _currenciesKey = 'currencies_data';
  static const String _userPreferredCurrencyKey = 'user_preferred_currency';

  // In-memory cache for better performance
  List<Expense>? _expensesCache;
  List<Tag>? _tagsCache;
  Map<String, List<String>>? _expenseTagsCache;
  List<Currency>? _currenciesCache;
  Currency? _userPreferredCurrencyCache;

  DatabaseService() {
    init();
  }

  // Initialize database (create default currencies)
  Future<void> init() async {
    await _loadExpenses();
    await _loadTags();
    await _loadExpenseTags();
    await _loadCurrencies();
    await _ensureDefaultCurrencies();
    await _ensureDefaultPreferredCurrency();
  }

  // Load data from SharedPreferences
  Future<List<Expense>> _loadExpenses() async {
    if (_expensesCache != null) return _expensesCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getString(_expensesKey);
    
    if (expensesJson == null) {
      _expensesCache = [];
      return _expensesCache!;
    }
    
    final List<dynamic> expensesList = json.decode(expensesJson);
    _expensesCache = expensesList.map((json) => Expense.fromJson(json)).toList();
    return _expensesCache!;
  }

  Future<void> _saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = json.encode(expenses.map((e) => e.toJson()).toList());
    await prefs.setString(_expensesKey, expensesJson);
    _expensesCache = expenses;
  }



  Future<List<Tag>> _loadTags() async {
    if (_tagsCache != null) return _tagsCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = prefs.getString(_tagsKey);
    
    if (tagsJson == null) {
      _tagsCache = [];
      return _tagsCache!;
    }
    
    final List<dynamic> tagsList = json.decode(tagsJson);
    _tagsCache = tagsList.map((json) => Tag.fromJson(json)).toList();
    return _tagsCache!;
  }

  Future<void> _saveTags(List<Tag> tags) async {
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = json.encode(tags.map((t) => t.toJson()).toList());
    await prefs.setString(_tagsKey, tagsJson);
    _tagsCache = tags;
  }

  Future<Map<String, List<String>>> _loadExpenseTags() async {
    if (_expenseTagsCache != null) return _expenseTagsCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final expenseTagsJson = prefs.getString(_expenseTagsKey);
    
    if (expenseTagsJson == null) {
      _expenseTagsCache = {};
      return _expenseTagsCache!;
    }
    
    final Map<String, dynamic> expenseTagsMap = json.decode(expenseTagsJson);
    _expenseTagsCache = expenseTagsMap.map((key, value) => 
        MapEntry(key, List<String>.from(value)));
    return _expenseTagsCache!;
  }

  Future<void> _saveExpenseTags(Map<String, List<String>> expenseTags) async {
    final prefs = await SharedPreferences.getInstance();
    final expenseTagsJson = json.encode(expenseTags);
    await prefs.setString(_expenseTagsKey, expenseTagsJson);
    _expenseTagsCache = expenseTags;
  }

  Future<List<Currency>> _loadCurrencies() async {
    if (_currenciesCache != null) return _currenciesCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final currenciesJson = prefs.getString(_currenciesKey);
    
    if (currenciesJson == null) {
      _currenciesCache = [];
      return _currenciesCache!;
    }
    
    final List<dynamic> currenciesList = json.decode(currenciesJson);
    _currenciesCache = currenciesList.map((json) => Currency.fromJson(json)).toList();
    return _currenciesCache!;
  }

  Future<void> _saveCurrencies(List<Currency> currencies) async {
    final prefs = await SharedPreferences.getInstance();
    final currenciesJson = json.encode(currencies.map((c) => c.toJson()).toList());
    await prefs.setString(_currenciesKey, currenciesJson);
    _currenciesCache = currencies;
  }

  Future<Currency> getUserPreferredCurrency() async {
    if (_userPreferredCurrencyCache != null) return _userPreferredCurrencyCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final currencyJson = prefs.getString(_userPreferredCurrencyKey);
    
    if (currencyJson == null) {
      _userPreferredCurrencyCache = Currency.vnd;
      return _userPreferredCurrencyCache!;
    }
    
    _userPreferredCurrencyCache = Currency.fromJson(json.decode(currencyJson));
    return _userPreferredCurrencyCache!;
  }

  Future<void> setUserPreferredCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPreferredCurrencyKey, json.encode(currency.toJson()));
    _userPreferredCurrencyCache = currency;
  }

  Future<void> _ensureDefaultCurrencies() async {
    final currencies = await _loadCurrencies();
    
    if (currencies.isEmpty) {
      await _saveCurrencies([Currency.vnd, Currency.usd]);
    }
  }

  Future<void> _ensureDefaultPreferredCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_userPreferredCurrencyKey)) {
      await setUserPreferredCurrency(Currency.vnd);
    }
  }

  // Migration method (no longer needed but kept for reference)
  Future<void> _migrateCategoriesToTags() async {
    final tags = await _loadTags();
    final expenses = await _loadExpenses();
    final expenseTags = await _loadExpenseTags();
    
    // Migration code removed as categories have been fully migrated to tags
    
    await _saveTags(tags);
    await _saveExpenseTags(expenseTags);
  }





  Future<void> addExpense(Expense expense) async {
    final expenses = await _loadExpenses();
    expenses.add(expense);
    await _saveExpenses(expenses);
  }










  // CRUD Operations for Expenses
  Future<List<Expense>> getExpenses({
    String? categoryId,
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

  Future<Expense?> getExpenseById(String id) async {
    final expenses = await _loadExpenses();
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

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

  Future<void> updateExpense(Expense expense) async {
    final expenses = await _loadExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense.copyWith(updatedAt: DateTime.now());
      await _saveExpenses(expenses);
    }
  }

  Future<void> deleteExpense(String id) async {
    final expenses = await _loadExpenses();
    expenses.removeWhere((expense) => expense.id == id);
    await _saveExpenses(expenses);
    
    // Also remove from expense tags
    final expenseTags = await _loadExpenseTags();
    expenseTags.remove(id);
    await _saveExpenseTags(expenseTags);
  }

  // Analytics methods
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final expenses = await _loadExpenses();
    final tags = await _loadTags();
    
    final totalExpenses = expenses.length;
    final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final avgAmount = totalExpenses > 0 ? totalAmount / totalExpenses : 0.0;
    
    final now = DateTime.now();
    final thisMonth = expenses.where((e) => 
        e.date.year == now.year && e.date.month == now.month).toList();
    final thisMonthTotal = thisMonth.fold<double>(0, (sum, expense) => sum + expense.amount);
    
    return {
      'totalExpenses': totalExpenses,
      'totalAmount': totalAmount,
      'averageAmount': avgAmount,
      'thisMonthTotal': thisMonthTotal,
      'thisMonthCount': thisMonth.length,
      'tagsCount': tags.length,
    };
  }



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

  Future<double> getMonthlySpending(int year, int month) async {
    final expenses = await _loadExpenses();
    return expenses
        .where((expense) => expense.date.year == year && expense.date.month == month)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  Future<List<Expense>> searchExpenses(String query) async {
    return await getExpenses(searchQuery: query);
  }

  // Tag and Category operations
  Future<List<Tag>> getTags() async {
    return await _loadTags();
  }

  Future<Tag?> getTagById(String id) async {
    final tags = await _loadTags();
    try {
      return tags.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getExpenseTags(String expenseId) async {
    final expenseTags = await _loadExpenseTags();
    return expenseTags[expenseId] ?? [];
  }

  Future<void> setExpenseTags(String expenseId, List<String> tagIds) async {
    final expenseTags = await _loadExpenseTags();
    expenseTags[expenseId] = tagIds;
    await _saveExpenseTags(expenseTags);
  }

  Future<void> addTag(Tag tag) async {
    final tags = await _loadTags();
    tags.add(tag);
    await _saveTags(tags);
  }

  Future<void> updateTag(Tag tag) async {
    final tags = await _loadTags();
    final index = tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      tags[index] = tag;
      await _saveTags(tags);
    }
  }

  Future<void> deleteTag(String tagId) async {
    final tags = await _loadTags();
    final expenseTags = await _loadExpenseTags();
    
    tags.removeWhere((tag) => tag.id == tagId);
    
    // Remove tag from all expenses
    for (var expenseId in expenseTags.keys) {
      expenseTags[expenseId]?.remove(tagId);
    }
    
    await _saveTags(tags);
    await _saveExpenseTags(expenseTags);
  }





  // Export to CSV
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

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expensesKey);
    await prefs.remove(_tagsKey);
    await prefs.remove(_expenseTagsKey);
    await prefs.remove(_currenciesKey);
    await prefs.remove(_userPreferredCurrencyKey);
    
    _expensesCache = null;
    _tagsCache = null;
    _expenseTagsCache = null;
    _currenciesCache = null;
    _userPreferredCurrencyCache = null;
    
    // Reinitialize default data
    await init();
  }

  // Close/cleanup (for compatibility)
  Future<void> close() async {
    // Nothing to close for SharedPreferences
  }
}