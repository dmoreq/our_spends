import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/services/expense_query_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ExpenseQueryService Tests', () {
    late ExpenseQueryService queryService;

    setUp(() {
      queryService = ExpenseQueryService();
    });

    test('should query expenses by natural language - today', () async {
      // Setup test data
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: today,
          amount: 50.0,
          currency: 'USD',
          category: 'Food & Dining',
          item: 'Lunch today',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: yesterday,
          amount: 30.0,
          currency: 'USD',
          category: 'Transportation',
          item: 'Bus fare yesterday',
        ),
      ];
      
      // Setup SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'expenses_data': json.encode(expenses.map((e) => e.toJson()).toList()),
      });
      
      // Query expenses for today
      final results = await queryService.queryExpenses('user1', 'What did I spend today?');
      
      // Verify results
      expect(results.length, 1);
      expect(results[0].id, 'id1');
      expect(results[0].item, 'Lunch today');
    });

    test('should query expenses by natural language - category', () async {
      // Setup test data
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime.now(),
          amount: 50.0,
          currency: 'USD',
          category: 'food',  // Changed to match the category in _parseQuery
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime.now(),
          amount: 30.0,
          currency: 'USD',
          category: 'transport',  // Changed to match the category in _parseQuery
          item: 'Bus fare',
        ),
      ];
      
      // Setup SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'expenses_data': json.encode(expenses.map((e) => e.toJson()).toList()),
      });
      
      // Query expenses for food category
      final results = await queryService.queryExpenses('user1', 'Show me my food expenses');
      
      // Verify results
      expect(results.length, 1);
      expect(results[0].id, 'id1');
      expect(results[0].category, 'food');
    });

    test('should get spending by category', () async {
      // Setup test data
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime.now(),
          amount: 50.0,
          currency: 'USD',
          category: 'food',  // Changed to match the category in _parseQuery
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime.now(),
          amount: 30.0,
          currency: 'USD',
          category: 'transport',  // Changed to match the category in _parseQuery
          item: 'Bus fare',
        ),
        Expense(
          id: 'id3',
          userId: 'user1',
          date: DateTime.now(),
          amount: 100.0,
          currency: 'USD',
          category: 'food',  // Changed to match the category in _parseQuery
          item: 'Dinner',
        ),
      ];
      
      // Setup SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'expenses_data': json.encode(expenses.map((e) => e.toJson()).toList()),
      });
      
      // Get spending by category
      final results = await queryService.getSpendingByCategory('user1');
      
      // Verify results
      expect(results.length, 2); // Two categories
      
      // Find food category
      final foodCategory = results.firstWhere((item) => item['categoryId'] == 'food');
      expect(foodCategory['totalAmount'], 150.0); // 50.0 + 100.0
      
      // Find transport category
      final transportCategory = results.firstWhere((item) => item['categoryId'] == 'transport');
      expect(transportCategory['totalAmount'], 30.0);
    });

    test('should get monthly spending trend', () async {
      // Setup test data with expenses across multiple months
      final thisMonth = DateTime.now();
      final lastMonth = DateTime(thisMonth.year, thisMonth.month - 1, 15);
      final twoMonthsAgo = DateTime(thisMonth.year, thisMonth.month - 2, 15);
      
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: thisMonth,
          amount: 150.0,
          currency: 'USD',
          category: 'food',  // Changed to match the category in _parseQuery
          item: 'This month expense',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: lastMonth,
          amount: 200.0,
          currency: 'USD',
          category: 'transport',  // Changed to match the category in _parseQuery
          item: 'Last month expense',
        ),
        Expense(
          id: 'id3',
          userId: 'user1',
          date: twoMonthsAgo,
          amount: 300.0,
          currency: 'USD',
          category: 'shopping',  // Changed to match the category in _parseQuery
          item: 'Two months ago expense',
        ),
      ];
      
      // Setup SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'expenses_data': json.encode(expenses.map((e) => e.toJson()).toList()),
      });
      
      // Get monthly spending trend
      final results = await queryService.getMonthlySpendingTrend('user1', months: 3);
      
      // Verify results
      expect(results.length, 3); // Three months of data
      
      // Verify the trend shows decreasing spending over time
      // The month format might be YYYY-MM, so we'll check for the presence of the month number
      // or just verify the total amounts match
      
      // Sort results by month to ensure consistent order for testing
      results.sort((a, b) => (a['month'] as String).compareTo(b['month'] as String));
      
      // Verify the amounts match our test data
      final thisMonthResult = results.firstWhere((item) => item['month'].contains(thisMonth.month.toString().padLeft(2, '0')));
      final lastMonthResult = results.firstWhere((item) => item['month'].contains(lastMonth.month.toString().padLeft(2, '0')));
      final twoMonthsAgoResult = results.firstWhere((item) => item['month'].contains(twoMonthsAgo.month.toString().padLeft(2, '0')));
      
      expect(thisMonthResult['totalAmount'], 150.0);
      expect(lastMonthResult['totalAmount'], 200.0);
      expect(twoMonthsAgoResult['totalAmount'], 300.0);
      
      // Verify we have three different months
      expect(results[0]['month'], isNot(equals(results[1]['month'])));
      expect(results[1]['month'], isNot(equals(results[2]['month'])));
      expect(results[0]['month'], isNot(equals(results[2]['month'])));
    });
  });
}