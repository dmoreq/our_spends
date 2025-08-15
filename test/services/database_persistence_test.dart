import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';

import '../mocks/mock_storage_service.dart';

void main() {
  group('Expense Repository Persistence Tests', () {
    late SharedPreferencesExpenseRepository expenseRepository;
    late MockStorageService storageService;
    
    setUp(() {
      storageService = MockStorageService();
      expenseRepository = SharedPreferencesExpenseRepository(storageService);
    });
    
    test('should persist expenses between app restarts', () async {
      // Create test expenses
      final testExpense1 = Expense(
        id: 'test-id-1',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Lunch',
      );
      
      final testExpense2 = Expense(
        id: 'test-id-2',
        userId: 'test-user',
        date: DateTime(2023, 5, 16),
        amount: 30.0,
        currency: 'USD',
        item: 'Dinner',
      );
      
      // Insert expenses
      await expenseRepository.insertExpense(testExpense1);
      await expenseRepository.insertExpense(testExpense2);
      
      // Create a new repository instance with the same storage service
      final newExpenseRepository = SharedPreferencesExpenseRepository(storageService);
      
      // Retrieve expenses from the new repository
      final expenses = await newExpenseRepository.getExpenses();
      
      // Verify expenses were persisted
      expect(expenses.length, 2);
      expect(expenses.any((e) => e.id == 'test-id-1'), isTrue);
      expect(expenses.any((e) => e.id == 'test-id-2'), isTrue);
    });
  });
}