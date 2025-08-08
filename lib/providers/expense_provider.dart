import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../services/expense_query_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  late final ExpenseQueryService _queryService;
  
  final List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  ExpenseProvider() {
    _queryService = ExpenseQueryService();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _databaseService.init();
      await _loadExpenses();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize database: ${e.toString()}');
    }
  }

  Future<void> _loadExpenses() async {
    try {
      final expenses = await _databaseService.getExpenses();
      _expenses.clear();
      _expenses.addAll(expenses);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load expenses: ${e.toString()}');
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
      final expenseId = await _databaseService.insertExpense(expense);
      
      // Reload expenses to update the UI
      await _loadExpenses();
      
      _setLoading(false);
      return expenseId;
    } catch (e) {
      _setError('Failed to add expense: ${e.toString()}');
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
}