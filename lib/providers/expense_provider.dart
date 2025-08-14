import 'dart:async';

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../services/expense_query_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  late final ExpenseQueryService _queryService;
  
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  Currency? _userPreferredCurrency;

  final _expenseStreamController = StreamController<List<Expense>>.broadcast();

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  Stream<List<Expense>> get expensesStream => _expenseStreamController.stream;

  ExpenseProvider() {
    _queryService = ExpenseQueryService();
    _initializeDatabase();
  }

  Future<void> _addTestData() async {
    if (_expenses.isEmpty) {
      final now = DateTime.now();
      final testExpenses = [
        Expense(
          id: '${now.millisecondsSinceEpoch}_1',
          userId: 'test_user',
          item: 'Cơm tấm sườn',
          amount: 45000.0,
          currency: 'VND',
          category: '1', // Food & Dining
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
          category: '2', // Transportation
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
          category: '1', // Food & Dining
          date: now.subtract(const Duration(days: 3)),
          description: 'Mua đồ ăn trong tuần',
          location: 'VinMart',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      for (final expense in testExpenses) {
        await addExpense(expense);
      }
    }
  }

  Future<Category?> getCategoryById(String categoryId) async {
    return await _databaseService.getCategoryById(categoryId);
  }

  Future<String> formatCurrency(double amount, String currencyCode) async {
    final currency = await _databaseService.getUserPreferredCurrency();
    return currency.formatAmount(amount);
  }

  Future<double> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    final sourceCurrency = Currency.vnd; // For now, we'll use VND as the source currency
    final targetCurrency = await _databaseService.getUserPreferredCurrency();
    return sourceCurrency.convertTo(amount, targetCurrency);
  }

  Future<void> setUserPreferredCurrency(Currency currency) async {
    await _databaseService.setUserPreferredCurrency(currency);
    _userPreferredCurrency = currency;
    notifyListeners();
  }

  Future<Currency> getUserPreferredCurrency() async {
    if (_userPreferredCurrency == null) {
      _userPreferredCurrency = await _databaseService.getUserPreferredCurrency();
    }
    return _userPreferredCurrency!;
  }

  @override
  void dispose() {
    _expenseStreamController.close();
    super.dispose();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _databaseService.init();
      _userPreferredCurrency = await _databaseService.getUserPreferredCurrency();
      await _loadExpenses();
      if (_expenses.isEmpty) {
        await _addTestData();
        await _loadExpenses(); // Reload expenses after adding test data
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize database: ${e.toString()}');
    }
  }

  Future<void> _loadExpenses() async {
    try {
      _setLoading(true);
      final expenses = await _databaseService.getExpenses();
      _expenses.clear();
      _expenses.addAll(expenses);
      _expenseStreamController.add(_expenses);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load expenses: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message, String userId, {List<Map<String, String>>? conversationHistory, String? languageCode}) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.processMessage(message, userId, _expenses, conversationHistory: conversationHistory, languageCode: languageCode);
      
      if (response['status'] == 'success') {
        _setLoading(false);
        return response;
      } else {
        _setError(response['data'] ?? 'Unknown error occurred');
        _setLoading(false);
        return response;
      }
    } catch (e) {
      _setError('Failed to process message: ${e.toString()}');
      _setLoading(false);
      return {
        'status': 'error',
        'data': 'Failed to process message: ${e.toString()}',
        'error_code': 'provider_error',
      };
    }
  }

  Future<Map<String, dynamic>> generateInsights(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.generateInsights(_expenses, userId);
      
      _setLoading(false);
      return response;
    } catch (e) {
      _setError('Failed to generate insights: ${e.toString()}');
      _setLoading(false);
      return {
        'status': 'error',
        'data': 'Failed to generate insights: ${e.toString()}',
        'error_code': 'insights_error',
      };
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
    await _loadExpenses();
  }

  // Add a new expense to the database and refresh the expenses list
  Future<String?> addExpense(Expense expense) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Insert the expense into the database
      await _databaseService.insertExpense(expense);
      
      // Reload expenses to update the UI
      await _loadExpenses();
      
      _setLoading(false);
      return expense.id;
    } catch (e) {
      _setError('Failed to add expense: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }
  
  // Update an existing expense in the database and refresh the expenses list
  Future<String?> updateExpense(Expense expense) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Update the expense in the database
      await _databaseService.updateExpense(expense);
      
      // Reload expenses to update the UI
      await _loadExpenses();
      
      _setLoading(false);
      return expense.id;
    } catch (e) {
      _setError('Failed to update expense: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  // Delete an expense from the database and refresh the expenses list
  Future<bool> deleteExpense(String expenseId) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Delete the expense from the database
      await _databaseService.deleteExpense(expenseId);
      
      // Reload expenses to update the UI
      await _loadExpenses();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete expense: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Clear all data and reinitialize the database
  Future<bool> clearAllData() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Clear all data from the database
      await _databaseService.clearAllData();
      
      // Reset provider state
      _expenses.clear();
      _userPreferredCurrency = null;
      _isInitialized = false;
      
      // Reinitialize the database and load default data
      await _initializeDatabase();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to clear data: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
}