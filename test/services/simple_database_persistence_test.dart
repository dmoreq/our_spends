import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';
import 'package:our_spends/services/storage/storage_service.dart';

class MockStorageService implements StorageService {
  Map<String, String> storage = {};
  
  @override
  Future<void> init() async {}
  
  @override
  Future<String?> getString(String key) async => storage[key];
  
  @override
  Future<bool> setString(String key, String value) async {
    storage[key] = value;
    return true;
  }

  @override
  Future<bool> clear() async {
    storage.clear();
    return true;
  }

  @override
  Future<bool> containsKey(String key) async {
    return storage.containsKey(key);
  }

  @override
  Future<bool> remove(String key) async {
    storage.remove(key);
    return true;
  }
}

void main() {
  group('SharedPreferencesExpenseRepository', () {
    late SharedPreferencesExpenseRepository repository;
    late MockStorageService storageService;
    
    setUp(() {
      storageService = MockStorageService();
      repository = SharedPreferencesExpenseRepository(storageService);
    });
    
    test('should persist expense insertion', () async {
      final expense = Expense(
        id: '1',
        userId: 'user1',
        date: DateTime(2024, 1, 1),
        amount: 100.0,
        currency: 'USD',
        item: 'Test Item',
      );
      
      await repository.insertExpense(expense);
      final expenses = await repository.getExpenses();
      
      expect(expenses.length, 1);
      expect(expenses.first.item, 'Test Item');
    });
    
    test('should persist expense deletion', () async {
      final expense = Expense(
        id: '1',
        userId: 'user1',
        date: DateTime(2024, 1, 1),
        amount: 100.0,
        currency: 'USD',
        item: 'Test Item',
      );
      
      await repository.insertExpense(expense);
      await repository.deleteExpense('1');
      final expenses = await repository.getExpenses();
      
      expect(expenses.isEmpty, true);
    });
    
    test('should persist multiple expenses', () async {
      final storageService = MockStorageService();
      final repository = SharedPreferencesExpenseRepository(storageService);
      
      final expenses = await repository.getExpenses();
      expect(expenses.isEmpty, true);
      
      await repository.insertExpense(Expense(
        id: '1',
        userId: 'user1',
        date: DateTime(2024, 1, 1),
        amount: 100.0,
        currency: 'USD',
        item: 'Item 1',
      ));
      
      await repository.insertExpense(Expense(
        id: '2',
        userId: 'user1',
        date: DateTime(2024, 1, 2),
        amount: 200.0,
        currency: 'USD',
        item: 'Item 2',
      ));
      
      final savedExpenses = await repository.getExpenses();
      expect(savedExpenses.length, 2);
      expect(savedExpenses.map((e) => e.item).toList(), ['Item 1', 'Item 2']);
    });
  });
}