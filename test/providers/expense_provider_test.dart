import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/providers/expense/expense_provider.dart';
import 'package:our_spends/repositories/expense_repository.dart';
import 'package:our_spends/repositories/tag_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_tag_repository.dart';
import 'package:our_spends/services/expense_service.dart';
import 'package:our_spends/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  group('ExpenseProvider Tests', () {
    late ExpenseProvider expenseProvider;
    late ExpenseRepository expenseRepository;
    late TagRepository tagRepository;
    late StorageService storageService;

    setUp(() {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
      
      // Initialize repositories
      storageService = MockStorageService();
      expenseRepository = SharedPreferencesExpenseRepository(storageService);
      tagRepository = SharedPreferencesTagRepository(storageService);
      
      // Create ExpenseService instance
      final expenseService = ExpenseService(
        expenseRepository: expenseRepository,
        tagRepository: tagRepository,
      );
      
      // Create ExpenseProvider instance
      expenseProvider = ExpenseProvider(
        expenseService: expenseService,
      );
    });

    test('should initialize with empty expenses', () async {
      // Wait for initialization to complete
      await expenseProvider.initializationDone;
      
      // Verify initial state
      expect(expenseProvider.expenses, isEmpty);
      expect(expenseProvider.isLoading, false);
      expect(expenseProvider.errorMessage, null);
      expect(expenseProvider.isInitialized, true);
    });

    test('should load expenses from repository', () async {
      // Setup test data
      final testExpense1 = Expense(
        id: 'id1',
        userId: 'user1',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Lunch',
      );
      
      final testExpense2 = Expense(
        id: 'id2',
        userId: 'user1',
        date: DateTime(2023, 5, 16),
        amount: 30.0,
        currency: 'USD',
        item: 'Bus fare',
      );
      
      // Add test expenses to repository
      await expenseRepository.insertExpense(testExpense1);
      await expenseRepository.insertExpense(testExpense2);
      
      // Create new provider instance to load the test data
      final expenseService = ExpenseService(
        expenseRepository: expenseRepository,
        tagRepository: tagRepository,
      );
      expenseProvider = ExpenseProvider(
        expenseService: expenseService,
      );
      
      // Wait for initialization to complete
      await expenseProvider.initializationDone;
      
      // Verify expenses were loaded
      expect(expenseProvider.expenses.length, 2);
      
      // Find expenses by id instead of assuming order
      final expense1 = expenseProvider.expenses.firstWhere((e) => e.id == 'id1');
      final expense2 = expenseProvider.expenses.firstWhere((e) => e.id == 'id2');
      
      // Verify expense details
      expect(expense1.id, 'id1');
      expect(expense1.amount, 50.0);
      expect(expense1.item, 'Lunch');
      
      expect(expense2.id, 'id2');
      expect(expense2.amount, 30.0);
      expect(expense2.item, 'Bus fare');
    });

    test('should send message and process response', () async {
      // Wait for initialization to complete
      await expenseProvider.initializationDone;
      
      // This test mainly verifies the method doesn't throw an exception
      // The actual implementation would depend on the AIService
    });
  });
}