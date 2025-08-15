import 'dart:async';

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/currency.dart';
import '../models/tag.dart';
import '../repositories/expense_repository.dart';
import '../repositories/tag_repository.dart';
import '../services/service_provider.dart';
import '../services/ai_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final TagRepository _tagRepository;
  final AIService _aiService = AIService();
  
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
  Future<void> get initializationDone => _initFuture;
  late Future<void> _initFuture;

  Stream<List<Expense>> get expensesStream => _expenseStreamController.stream;

  ExpenseProvider({
    required ExpenseRepository expenseRepository,
    required TagRepository tagRepository,
  }) : _expenseRepository = expenseRepository,
       _tagRepository = tagRepository {
    _initFuture = _initializeDatabase();
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
      await _expenseRepository.insert(expense);
    }
  }

  Future<Tag?> getTagById(String tagId) async {
    return await _tagRepository.getById(tagId);
  }

  Future<List<Tag>> getTags() async {
    return await _tagRepository.getAll();
  }

  Future<List<String>> getExpenseTags(String expenseId) async {
    return await _tagRepository.getExpenseTags(expenseId);
  }

  Future<void> setExpenseTags(String expenseId, List<String> tagIds) async {
    await _tagRepository.setExpenseTags(expenseId, tagIds);
    notifyListeners();
  }

  Future<void> addTag(Tag tag) async {
    await _tagRepository.insert(tag);
    notifyListeners();
  }

  Future<void> updateTag(Tag tag) async {
    await _tagRepository.update(tag);
    notifyListeners();
  }

  Future<void> deleteTag(String tagId) async {
    await _tagRepository.delete(tagId);
    notifyListeners();
  }

  Future<String> formatCurrency(double amount, String currencyCode) async {
    final currency = await _expenseRepository.getUserPreferredCurrency();
    return currency.formatAmount(amount);
  }

  Future<double> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    final sourceCurrency = Currency.vnd; // For now, we'll use VND as the source currency
    final targetCurrency = await _expenseRepository.getUserPreferredCurrency();
    return sourceCurrency.convertTo(amount, targetCurrency);
  }

  Future<void> setUserPreferredCurrency(Currency currency) async {
    await _expenseRepository.setUserPreferredCurrency(currency);
    _userPreferredCurrency = currency;
    notifyListeners();
  }

  Future<Currency> getUserPreferredCurrency() async {
    if (_userPreferredCurrency == null) {
      _userPreferredCurrency = await _expenseRepository.getUserPreferredCurrency();
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
      await _expenseRepository.init();
      _userPreferredCurrency = await _expenseRepository.getUserPreferredCurrency();

      var expenses = await _expenseRepository.getAll();
      if (expenses.isEmpty) {
        await _addTestData();
        expenses = await _expenseRepository.getAll();
      }
      _expenses.clear();
      _expenses.addAll(expenses);
      _expenseStreamController.add(_expenses);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize database: ${e.toString()}');
    }
  }

  Future<void> loadExpenses() async {
    try {
      _setLoading(true);
      final expenses = await _expenseRepository.getAll();
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

      final responseText = await _aiService.processMessage(message, _expenses, conversationHistory: conversationHistory, languageCode: languageCode);
      
      final response = {
        'status': 'success',
        'data': responseText,
        'error_code': null,
      };
      
      _setLoading(false);
      return response;
    } catch (e) {
      _setError('Failed to process message: ${e.toString()}');
      _setLoading(false);
      return {
        'status': 'error',
        'data': null,
        'error_code': 'message_processing_failed',
        'error_message': e.toString(),
      };
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      _setLoading(true);
      _clearError();

      await _expenseRepository.insert(expense);
      await loadExpenses();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to add expense: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      _setLoading(true);
      _clearError();

      await _expenseRepository.update(expense);
      await loadExpenses();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to update expense: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      _setLoading(true);
      _clearError();

      await _expenseRepository.delete(expenseId);
      await loadExpenses();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete expense: ${e.toString()}');
      _setLoading(false);
    }
  }

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

  Future<void> clearAllData() async {
    try {
      _setLoading(true);
      _clearError();

      await _expenseRepository.clearAll();
      await loadExpenses();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to clear data: ${e.toString()}');
      _setLoading(false);
    }
  }
}