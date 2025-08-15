import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:our_spends/repositories/expense_repository.dart';
import 'package:our_spends/repositories/tag_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_tag_repository.dart';
import 'package:our_spends/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  group('ExpenseProvider Persistence Tests', () {
    late ExpenseProvider expenseProvider;
    late ExpenseRepository expenseRepository;
    late TagRepository tagRepository;
    late StorageService storageService;
    
    setUp(() async {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      
      // Initialize repositories
      storageService = MockStorageService();
      expenseRepository = SharedPreferencesExpenseRepository(storageService);
      tagRepository = SharedPreferencesTagRepository(storageService);
      
      // Create ExpenseProvider instance
      expenseProvider = ExpenseProvider(
        expenseRepository: expenseRepository,
        tagRepository: tagRepository,
      );
      
      // Wait for initialization to complete
      await expenseProvider.initializationDone;
    });
    
    test('should load expenses from repository on initialization', () async {
      // Create a new instance with clean SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize repositories
      final testStorageService = MockStorageService();
      final testExpenseRepository = SharedPreferencesExpenseRepository(testStorageService);
      final testTagRepository = SharedPreferencesTagRepository(testStorageService);
      
      // Add test expenses to the repository
      await testExpenseRepository.insertExpense(Expense(
        id: 'test-id-1',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Lunch',
      ));
      
      await testExpenseRepository.insertExpense(Expense(
        id: 'test-id-2',
        userId: 'test-user',
        date: DateTime(2023, 5, 16),
        amount: 30.0,
        currency: 'USD',
        item: 'Bus fare',
      ));
      
      // Create a new provider that should load the test expenses
      final testExpenseProvider = ExpenseProvider(
        expenseRepository: testExpenseRepository,
        tagRepository: testTagRepository,
      );
      
      // Wait for initialization to complete
      await testExpenseProvider.initializationDone;
      
      // Verify expenses were loaded
      expect(testExpenseProvider.expenses.length, 2);
      expect(testExpenseProvider.expenses.any((e) => e.id == 'test-id-1'), isTrue);
      expect(testExpenseProvider.expenses.any((e) => e.id == 'test-id-2'), isTrue);
    });
  });
}