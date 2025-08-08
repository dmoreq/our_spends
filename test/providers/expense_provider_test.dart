import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ExpenseProvider Tests', () {
    late ExpenseProvider expenseProvider;

    setUp(() {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
      
      // Create ExpenseProvider instance
      expenseProvider = ExpenseProvider();
    });

    test('should initialize with empty expenses', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify initial state
      expect(expenseProvider.expenses, isEmpty);
      expect(expenseProvider.isLoading, false);
      expect(expenseProvider.errorMessage, null);
      expect(expenseProvider.isInitialized, true);
    });

    test('should load expenses from database', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Setup test data
      final testExpenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          category: 'Food & Dining',
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime(2023, 5, 16),
          amount: 30.0,
          currency: 'USD',
          category: 'Transportation',
          item: 'Bus fare',
        ),
      ];
      
      // Setup SharedPreferences with test data
      SharedPreferences.setMockInitialValues({
        'expenses_data': json.encode(testExpenses.map((e) => e.toJson()).toList()),
      });
      
      // Create new provider instance to load the test data
      expenseProvider = ExpenseProvider();
      
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify expenses were loaded
      expect(expenseProvider.expenses.length, 2);
      
      // Find expenses by id instead of assuming order
      final expense1 = expenseProvider.expenses.firstWhere((e) => e.id == 'id1');
      final expense2 = expenseProvider.expenses.firstWhere((e) => e.id == 'id2');
      
      // Verify expense details
      expect(expense1.id, 'id1');
      expect(expense1.amount, 50.0);
      expect(expense1.category, 'Food & Dining');
      
      expect(expense2.id, 'id2');
      expect(expense2.amount, 30.0);
      expect(expense2.category, 'Transportation');
    });

    test('should send message and process response', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Send a test message
      final response = await expenseProvider.sendMessage(
        'I spent 50 USD on lunch today',
        'user1',
      );
      
      // Verify response structure
      expect(response, isA<Map<String, dynamic>>());
      expect(response.containsKey('status'), true);
      
      // Note: The actual response depends on the API implementation
      // This test mainly verifies the method doesn't throw an exception
    });

    test('should generate insights', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Generate insights
      final insights = await expenseProvider.generateInsights('user1');
      
      // Verify insights structure
      expect(insights, isA<Map<String, dynamic>>());
      expect(insights.containsKey('status'), true);
      
      // Note: The actual insights depend on the API implementation
      // This test mainly verifies the method doesn't throw an exception
    });

    test('should handle loading state', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Set loading state
      expenseProvider.setLoading(true);
      
      // Verify loading state
      expect(expenseProvider.isLoading, true);
      
      // Set loading state to false
      expenseProvider.setLoading(false);
      
      // Verify loading state was updated
      expect(expenseProvider.isLoading, false);
    });

    test('should handle error state', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Wait for initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Set error message
      expenseProvider.setError('Test error message');
      
      // Verify error state
      expect(expenseProvider.errorMessage, 'Test error message');
      
      // Clear error
      expenseProvider.clearError();
      
      // Verify error was cleared
      expect(expenseProvider.errorMessage, null);
    });
  });
}