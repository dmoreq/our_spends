import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:our_spends/models/expense.dart';

void main() {
  group('Expense Model Tests', () {
    test('should create an Expense instance with required parameters', () {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      final expense = Expense(
        id: '1',
        userId: 'user1',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        category: 'Food & Dining',
        item: 'Lunch',
      );

      expect(expense.id, '1');
      expect(expense.userId, 'user1');
      expect(expense.date, DateTime(2023, 5, 15));
      expect(expense.amount, 50.0);
      expect(expense.currency, 'USD');
      expect(expense.category, 'Food & Dining');
      expect(expense.item, 'Lunch');
      expect(expense.isRecurring, false); // Default value
    });

    test('should create an Expense from JSON', () {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      final json = {
        'id': '1',
        'user_id': 'user1',
        'date': '2023-05-15T00:00:00.000',
        'amount': 50.0,
        'currency': 'USD',
        'category': 'Food & Dining',
        'item': 'Lunch',
        'description': 'Business lunch',
        'is_recurring': true,
        'recurring_frequency': 'monthly',
      };

      final expense = Expense.fromJson(json);

      expect(expense.id, '1');
      expect(expense.userId, 'user1');
      expect(expense.date, DateTime(2023, 5, 15));
      expect(expense.amount, 50.0);
      expect(expense.currency, 'USD');
      expect(expense.category, 'Food & Dining');
      expect(expense.item, 'Lunch');
      expect(expense.description, 'Business lunch');
      expect(expense.isRecurring, true);
      expect(expense.recurringFrequency, 'monthly');
    });

    test('should convert Expense to JSON', () {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      final expense = Expense(
        id: '1',
        userId: 'user1',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        category: 'Food & Dining',
        item: 'Lunch',
        description: 'Business lunch',
        isRecurring: true,
        recurringFrequency: 'monthly',
      );

      final json = expense.toJson();

      expect(json['id'], '1');
      expect(json['user_id'], 'user1');
      expect(json['date'], '2023-05-15T00:00:00.000');
      expect(json['amount'], 50.0);
      expect(json['currency'], 'USD');
      expect(json['category'], 'Food & Dining');
      expect(json['item'], 'Lunch');
      expect(json['description'], 'Business lunch');
      expect(json['is_recurring'], true);
      expect(json['recurring_frequency'], 'monthly');
    });

    test('should create a copy with updated fields using copyWith', () {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      final expense = Expense(
        id: '1',
        userId: 'user1',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        category: 'Food & Dining',
        item: 'Lunch',
      );

      final updatedExpense = expense.copyWith(
        amount: 75.0,
        description: 'Updated lunch',
      );

      // Check that specified fields were updated
      expect(updatedExpense.amount, 75.0);
      expect(updatedExpense.description, 'Updated lunch');

      // Check that other fields remain the same
      expect(updatedExpense.id, '1');
      expect(updatedExpense.userId, 'user1');
      expect(updatedExpense.date, DateTime(2023, 5, 15));
      expect(updatedExpense.currency, 'USD');
      expect(updatedExpense.category, 'Food & Dining');
      expect(updatedExpense.item, 'Lunch');
    });
  });
}