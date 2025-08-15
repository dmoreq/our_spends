import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/models/tag.dart';
import 'package:our_spends/repositories/expense_repository.dart';
import 'package:our_spends/repositories/tag_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_expense_repository.dart';
import 'package:our_spends/repositories/implementations/shared_preferences_tag_repository.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:our_spends/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/mock_storage_service.dart';

void main() {
  group('AI and Database Integration Tests', () {
    late AIService aiService;
    late ExpenseRepository expenseRepository;
    late TagRepository tagRepository;
    late StorageService storageService;

    setUp(() async {
      // Setup SharedPreferences for testing
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'YOUR_API_KEY_HERE', // Use a placeholder for tests
      });
      
      // Initialize services
      storageService = MockStorageService();
      expenseRepository = SharedPreferencesExpenseRepository(storageService);
      tagRepository = SharedPreferencesTagRepository(storageService);
      aiService = AIService(geminiService: GeminiService());
      
      // Add some test data
      await tagRepository.addTag(Tag(id: 'tag1', name: 'Food'));
      await tagRepository.addTag(Tag(id: 'tag2', name: 'Transportation'));
      
      await expenseRepository.insertExpense(Expense(
        id: 'exp1',
        userId: 'test-user',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        item: 'Lunch',
      ));
      
      await expenseRepository.insertExpense(Expense(
        id: 'exp2',
        userId: 'test-user',
        date: DateTime(2023, 5, 14),
        amount: 30.0,
        currency: 'USD',
        item: 'Taxi',
      ));
      
      // Set expense tags
      await tagRepository.setExpenseTags('exp1', ['tag1']);
      await tagRepository.setExpenseTags('exp2', ['tag2']);
    });

    test('AI should extract expense and save to database', () async {
      // Skip actual API test if no valid API key
      final isAvailable = await aiService.isGeminiAvailable();
      if (!isAvailable) {
        markTestSkipped('Skipping test because valid Gemini API key is not set');
        return;
      }
      
      // Extract expense info
      final expenseInfo = await aiService.extractExpenseInfo('I spent 25 dollars on coffee yesterday');
      
      // Verify extraction worked
      expect(expenseInfo, isNotNull);
      if (expenseInfo != null) {
        expect(expenseInfo['amount'], 25.0);
        final description = expenseInfo['description'] ?? expenseInfo['item'];
        expect(description, contains('coffee'));
        
        // Create and save expense
        final expense = Expense(
          id: 'new-expense',
          userId: 'test-user',
          date: DateTime.now().subtract(Duration(days: 1)),
          amount: expenseInfo['amount'] as double,
          currency: 'USD',
          item: description as String,
        );
        
        await expenseRepository.insertExpense(expense);
        
        // Verify expense was saved
        final savedExpense = await expenseRepository.getExpenseById('new-expense');
        expect(savedExpense, isNotNull);
        expect(savedExpense!.amount, 25.0);
        expect(savedExpense.item, contains('coffee'));
      }
    });

    test('AI should generate spending insights from database expenses', () async {
      // Skip actual API test if no valid API key
      final isAvailable = await aiService.isGeminiAvailable();
      if (!isAvailable) {
        markTestSkipped('Skipping test because valid Gemini API key is not set');
        return;
      }
      
      // Get all expenses from repository
      final expenses = await expenseRepository.getExpenses();
      expect(expenses.length, 2);
      
      // Generate insights
      final insights = await aiService.generateSpendingInsights(expenses);
      
      // Verify insights
      expect(insights, isNotNull);
      expect(insights.isNotEmpty, isTrue);
      
      // Verify insights contain relevant information
      expect(insights, anyOf(
        contains('Total Expenses'),
        contains('USD'),
        contains('\$'),
      ));
      expect(insights, anyOf(
        contains('Food'),
        contains('Lunch'),
        contains('Taxi'),
        contains('Transportation'),
      ));
    });
  });
}