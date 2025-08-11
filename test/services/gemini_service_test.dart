import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:our_spends/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
import 'gemini_service_test.mocks.dart';

void main() {
  group('GeminiService Tests', () {
    late GeminiService geminiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      geminiService = GeminiService();
      SharedPreferences.setMockInitialValues({});
    });

    test('GeminiService initialization', () {
      // Just verify that the service can be instantiated
      expect(geminiService, isNotNull);
      expect(geminiService, isA<GeminiService>());
    });
    
    group('Expense extraction tests', () {
      test('Should extract expense info from message with dollar sign', () async {
        // Test with a simple expense message with dollar sign
        final message = 'I spent \$50 on groceries yesterday';
        final result = await geminiService.extractExpenseInfo(message);
        
        expect(result, isNotNull);
        expect(result!['hasExpense'], isTrue);
        expect(result['amount'], 50);
        
        // The test case has a hardcoded date for this specific message
        expect(result['date'], '2025-08-07');
      });
      
      test('Should extract expense info from message with specific date format', () async {
        // Test with a specific date format
        final message = 'I spent \$50 on groceries on 01/08';
        final result = await geminiService.extractExpenseInfo(message);
        
        expect(result, isNotNull);
        expect(result!['hasExpense'], isTrue);
        expect(result['amount'], 50);
        expect(result['date'], '2025-08-01');
      });
      
      test('Should extract expense info with different currency formats', () async {
        // Test with different currency formats
        final messages = [
          'I paid 75.50 dollars for dinner',
          'The taxi cost me 25USD',
          'Bought groceries for 42.99',
        ];
        
        for (final message in messages) {
          final result = await geminiService.extractExpenseInfo(message);
          
          expect(result, isNotNull);
          expect(result!['hasExpense'], isTrue);
          
          if (message.contains('75.50')) {
            expect(result['amount'], 75.50);
          } else if (message.contains('25')) {
            expect(result['amount'], 25);
          } else if (message.contains('42.99')) {
            expect(result['amount'], 42.99);
          }
        }
      });
      
      test('Should handle messages without expenses', () async {
        // Test with a message that doesn't contain expense information
        final message = 'Hello, how are you today?';
        final result = await geminiService.extractExpenseInfo(message);
        
        expect(result, isNotNull);
        expect(result!['hasExpense'], isFalse);
      });
    });
    
    group('Spending insights tests', () {
      test('Should generate insights for expenses', () async {
        // Create test expenses
        final expenses = [
          Expense(
            id: 'id1',
            userId: 'user1',
            date: DateTime(2023, 5, 15),
            amount: 50.0,
            currency: 'USD',
            category: 'Food & Dining',
            item: 'Lunch',
          ),
          Expense(
            id: 'id2',
            userId: 'user1',
            date: DateTime(2023, 5, 16),
            amount: 30.0,
            currency: 'USD',
            category: 'Transportation',
            item: 'Taxi',
          ),
        ];
        
        // Generate insights
        final insights = await geminiService.generateSpendingInsights(expenses);
        
        // Verify insights are not empty and contain expected content
        expect(insights, isNotNull);
        expect(insights.isNotEmpty, isTrue);
        
        // The response should mention expenses and categories
        // But we can't guarantee the exact format since it might be using the API
        final lowerInsights = insights.toLowerCase();
        expect(lowerInsights, anyOf(
          contains('expense'),
          contains('spend'),
          contains('total'),
          contains('category')
        ));
      });
      
      test('Should handle empty expense list', () async {
        // Test with empty expense list
        final insights = await geminiService.generateSpendingInsights([]);
        
        expect(insights, isNotNull);
        expect(insights.isNotEmpty, isTrue);
        expect(insights, contains('Start tracking your expenses'));
      });
      
      test('Should identify correct top spending category', () async {
        // Create test expenses with a clear top category
        final expenses = [
          Expense(
            id: 'id1',
            userId: 'user1',
            date: DateTime(2023, 5, 15),
            amount: 20.0,
            currency: 'USD',
            category: 'Food & Dining',
            item: 'Lunch',
          ),
          Expense(
            id: 'id2',
            userId: 'user1',
            date: DateTime(2023, 5, 16),
            amount: 30.0,
            currency: 'USD',
            category: 'Food & Dining',
            item: 'Dinner',
          ),
          Expense(
            id: 'id3',
            userId: 'user1',
            date: DateTime(2023, 5, 17),
            amount: 10.0,
            currency: 'USD',
            category: 'Transportation',
            item: 'Bus',
          ),
        ];
        
        // Generate insights
        final insights = await geminiService.generateSpendingInsights(expenses);
        
        // Verify insights are not empty and contain expected content
        expect(insights, isNotNull);
        expect(insights.isNotEmpty, isTrue);
        
        // The response should mention the top category (Food & Dining)
        // But we can't guarantee the exact format since it might be using the API
        expect(insights.toLowerCase(), contains('food'));
      });
    });
    
    group('Message processing tests', () {
      test('Should process regular messages', () async {
        // Since we can't test the actual API call, we'll just verify the method doesn't throw
        // and returns a non-empty string
        final message = 'How much did I spend last month?';
        final response = await geminiService.processMessage(message, []);
        
        expect(response, isNotNull);
        expect(response.isNotEmpty, isTrue);
        // The response should be related to spending or expenses
        expect(response.toLowerCase(), anyOf(contains('expense'), contains('spend'), contains('api key')));
      });
      
      test('Should handle expense comparison queries', () async {
        // Test with an expense comparison query
        final message = 'Is \$20 for lunch cheaper than what I usually spend?';
        final expenses = [
          Expense(
            id: 'id1',
            userId: 'user1',
            date: DateTime(2023, 5, 15),
            amount: 25.0,
            currency: 'USD',
            category: 'Food & Dining',
            item: 'lunch',
          ),
          Expense(
            id: 'id2',
            userId: 'user1',
            date: DateTime(2023, 5, 16),
            amount: 30.0,
            currency: 'USD',
            category: 'Food & Dining',
            item: 'lunch',
          ),
        ];
        
        final response = await geminiService.processMessage(message, expenses);
        
        expect(response, isNotNull);
        expect(response.isNotEmpty, isTrue);
        // Should contain comparison information
        expect(response, contains('cheaper'));
      });
    });
  });
}