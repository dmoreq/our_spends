import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  final List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> sendMessage(String message, String userId, {List<Map<String, String>>? conversationHistory}) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.processMessage(message, userId, _expenses, conversationHistory: conversationHistory);
      
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

  Future<Map<String, dynamic>> generateInsights() async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.generateInsights(_expenses);
      
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
}