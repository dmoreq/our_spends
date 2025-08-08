import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Simple Database Persistence Tests', () {
    late DatabaseService databaseService;
    
    setUp(() {
      databaseService = DatabaseService();
    });
    
    test('should persist expense deletion', () async {
      // Setup SharedPreferences mock with empty initial values
      SharedPreferences.setMockInitialValues({});
      
      // Initialize database
      await databaseService.init();
      
      // Create and insert a test expense
      final testExpense = Expense(
        id: '',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        category: 'Food & Dining',
        item: 'Test Expense',
      );
      
      // Insert expense
      final expenseId = await databaseService.insertExpense(testExpense);
      
      // Verify expense was saved
      var expenses = await databaseService.getExpenses();
      expect(expenses.length, 1, reason: 'Should have one expense after insertion');
      
      // Get the SharedPreferences instance to verify data was actually saved
      var prefs = await SharedPreferences.getInstance();
      var expensesJson = prefs.getString('expenses_data');
      expect(expensesJson, isNotNull, reason: 'Expenses data should be saved in SharedPreferences');
      
      // Verify the saved JSON contains one expense
      var savedExpenses = json.decode(expensesJson!);
      expect(savedExpenses.length, 1, reason: 'Should have one expense in SharedPreferences');
      
      // Delete the expense
      await databaseService.deleteExpense(expenseId);
      
      // Verify expense was deleted from memory
      expenses = await databaseService.getExpenses();
      expect(expenses.length, 0, reason: 'Should have no expenses after deletion');
      
      // Verify expense was deleted from SharedPreferences
      prefs = await SharedPreferences.getInstance();
      expensesJson = prefs.getString('expenses_data');
      expect(expensesJson, isNotNull, reason: 'Expenses data should still exist in SharedPreferences');
      
      savedExpenses = json.decode(expensesJson!);
      expect(savedExpenses.length, 0, reason: 'Should have no expenses in SharedPreferences after deletion');
      
      // Create a new database service to simulate app restart
      final newDatabaseService = DatabaseService();
      await newDatabaseService.init();
      
      // Verify expense is still deleted after "restart"
      final persistedExpenses = await newDatabaseService.getExpenses();
      expect(persistedExpenses.length, 0, reason: 'Should have no expenses after app restart');
    });
  });
}