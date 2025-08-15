import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/repositories/expense_repository.dart';
import 'package:our_spends/repositories/tag_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_tag_repository.dart';
import 'package:our_spends/services/storage/storage_service.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  group('SharedPreferencesExpenseRepository Tests', () {
    late ExpenseRepository expenseRepository;
    late TagRepository tagRepository;
    late StorageService storageService;

    setUp(() {
      // Initialize mock storage service
      storageService = MockStorageService();
      
      // Create repositories with mock storage
      expenseRepository = SharedPreferencesExpenseRepository(storageService);
      tagRepository = SharedPreferencesTagRepository(storageService);
    });

    test('should initialize with default tags', () async {
      // Get all tags
      final tags = await tagRepository.getTags();
      
      // Verify default tags were created
      expect(tags.length, greaterThan(0));
      expect(tags.any((tag) => tag.name == 'Food'), isTrue);
      expect(tags.any((tag) => tag.name == 'Transportation'), isTrue);
      expect(tags.any((tag) => tag.name == 'Entertainment'), isTrue);
    });

    test('should insert and retrieve an expense', () async {
      // Create a test expense
      final expense = Expense(
        id: 'test-id',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Test Expense',
      );
      
      // Insert the expense
      await expenseRepository.insertExpense(expense);
      
      // Retrieve the expense
      final retrievedExpense = await expenseRepository.getExpenseById('test-id');
      
      // Verify expense was retrieved correctly
      expect(retrievedExpense, isNotNull);
      expect(retrievedExpense!.id, equals('test-id'));
      expect(retrievedExpense.amount, equals(50.0));
      expect(retrievedExpense.item, equals('Test Expense'));
    });

    test('should update an expense', () async {
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
      
      // Update the expense
      final updatedExpense = expense.copyWith(
        amount: 75.0,
        item: 'Updated Expense',
      );
      
      await expenseRepository.updateExpense(updatedExpense);
      
      // Retrieve the updated expense
      final retrievedExpense = await expenseRepository.getExpenseById('test-id');
      
      // Verify expense was updated correctly
      expect(retrievedExpense, isNotNull);
      expect(retrievedExpense!.amount, equals(75.0));
      expect(retrievedExpense.item, equals('Updated Expense'));
    });

    test('should delete an expense', () async {
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
      
      // Delete the expense
      await expenseRepository.deleteExpense('test-id');
      
      // Try to retrieve the deleted expense
      final retrievedExpense = await expenseRepository.getExpenseById('test-id');
      
      // Verify expense was deleted
      expect(retrievedExpense, isNull);
    });

    test('should get all expenses', () async {
      // Create and insert multiple test expenses
      final expense1 = Expense(
        id: 'test-id-1',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Expense 1',
      );
      
      final expense2 = Expense(
        id: 'test-id-2',
        userId: 'test-user',
        date: DateTime(2023, 5, 16),
        amount: 30.0,
        currency: 'USD',
        item: 'Expense 2',
      );
      
      await expenseRepository.insertExpense(expense1);
      await expenseRepository.insertExpense(expense2);
      
      // Get all expenses
      final expenses = await expenseRepository.getExpenses();
      
      // Verify all expenses were retrieved
      expect(expenses.length, equals(2));
      expect(expenses.any((e) => e.id == 'test-id-1'), isTrue);
      expect(expenses.any((e) => e.id == 'test-id-2'), isTrue);
    });
  });
}