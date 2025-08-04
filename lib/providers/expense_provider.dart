import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendMessage(String message, String userId) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.processMessage(message, userId);
      
      if (response['status'] == 'success') {
        // Handle successful response
        if (response['type'] == 'text') {
          // Just a text response, no action needed
        } else if (response['type'] == 'report') {
          // Handle report data if needed
        } else if (response['type'] == 'comparison') {
          // Handle comparison data if needed
        }
      } else {
        _setError(response['data'] ?? 'Unknown error occurred');
      }

      _setLoading(false);
    } catch (e) {
      _setError('Failed to process message: ${e.toString()}');
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
}