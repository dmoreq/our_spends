import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/repositories/expense_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';
import 'package:our_spends/services/storage/storage_service.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  group('SharedPreferencesExpenseRepository Persistence Tests', () {
    late ExpenseRepository expenseRepository;
    late StorageService storageService;

    setUp(() {
      // Initialize mock storage service
      storageService = MockStorageService();
      
      // Create repository with mock storage
      expenseRepository = SharedPreferencesExpenseRepository(storageService);
    });

    test('should persist expenses between repository instances', () async {
      // Create a test expense
      final expense = Expense(
        id: 'test-id',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Test Expense',
      );
      
      // Insert the expense using the first repository instance
      await expenseRepository.insertExpense(expense);
      
      // Create a new repository instance with the same storage service
      final newExpenseRepository = SharedPreferencesExpenseRepository(storageService);
      
      // Retrieve the expense using the new repository instance
      final retrievedExpense = await newExpenseRepository.getExpenseById('test-id');
      
      // Verify expense was retrieved correctly
      expect(retrievedExpense, isNotNull);
      expect(retrievedExpense!.id, equals('test-id'));
      expect(retrievedExpense.amount, equals(50.0));
      expect(retrievedExpense.item, equals('Test Expense'));
    });

    test('should persist expense updates between repository instances', () async {
      // Create and insert a test expense
      final expense = Expense(
        id: 'test-id',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Test Expense',
      );
      
      await expenseRepository.insertExpense(expense);
      
      // Update the expense using the first repository instance
      final updatedExpense = expense.copyWith(
        amount: 75.0,
        item: 'Updated Expense',
      );
      
      await expenseRepository.updateExpense(updatedExpense);
      
      // Create a new repository instance with the same storage service
      final newExpenseRepository = SharedPreferencesExpenseRepository(storageService);
      
      // Retrieve the updated expense using the new repository instance
      final retrievedExpense = await newExpenseRepository.getExpenseById('test-id');
      
      // Verify expense was updated correctly
      expect(retrievedExpense, isNotNull);
      expect(retrievedExpense!.amount, equals(75.0));
      expect(retrievedExpense.item, equals('Updated Expense'));
    });

    test('should persist expense deletions between repository instances', () async {
      // Create and insert a test expense
      final expense = Expense(
        id: 'test-id',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Test Expense',
      );
      
      await expenseRepository.insertExpense(expense);
      
      // Delete the expense using the first repository instance
      await expenseRepository.deleteExpense('test-id');
      
      // Create a new repository instance with the same storage service
      final newExpenseRepository = SharedPreferencesExpenseRepository(storageService);
      
      // Try to retrieve the deleted expense using the new repository instance
      final retrievedExpense = await newExpenseRepository.getExpenseById('test-id');
      
      // Verify expense was deleted
      expect(retrievedExpense, isNull);
    });
  });
}