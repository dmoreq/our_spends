import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AI Service Integration Tests', () {
    late AIService aiService;
    
    setUp(() async {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'test_api_key_12345', // Set test API key
      });
      
      // Create AIService instance
      aiService = AIService();
      
      // Initialize the service
      await aiService.initialize();
    });

    test('AIService should initialize correctly', () {
      expect(aiService, isNotNull);
    });

    test('AIService should return correct provider information', () {
      expect(aiService.getProviderName(), 'Google Gemini');
      expect(aiService.getProviderModel(), isNotNull);
    });
    
    test('AIService should check Gemini availability', () async {
      final status = await aiService.getGeminiStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status['name'], 'Google Gemini');
      expect(status['available'], isTrue);
    });
    
    test('AIService should process messages', () async {
      // Skip if API key is not configured
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key');
      if (apiKey == null || apiKey.isEmpty || apiKey.contains('YOUR_') || apiKey.length < 10) {
        markTestSkipped('Skipping test because valid Gemini API key is not set');
        return;
      }
      
      // Create test expenses
      final expenses = <Expense>[];
      
      // Process a test message
      final response = await aiService.processMessage(
        'Hello, how are you?',
        expenses,
        conversationHistory: [],
        languageCode: 'en',
      );
      
      // Verify response is not empty
      expect(response, isNotNull);
      expect(response.isNotEmpty, isTrue);
    });
    
    test('AIService should extract expense information', () async {
      // Skip if API key is not configured
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key');
      if (apiKey == null || apiKey.isEmpty || apiKey.contains('YOUR_') || apiKey.length < 10) {
        markTestSkipped('Skipping test because valid Gemini API key is not set');
        return;
      }
      
      // Extract expense info
      final result = await aiService.extractExpenseInfo('I spent \$50 on groceries yesterday');
      
      // Verify result structure
      expect(result, isNotNull);
      expect(result!['amount'], 50.0);
      expect(result['description'] ?? result['item'], contains('groceries'));
    });
    
    test('AIService should generate spending insights', () async {
      // Skip if API key is not configured
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key');
      if (apiKey == null || apiKey.isEmpty || apiKey.contains('YOUR_') || apiKey.length < 10) {
        markTestSkipped('Skipping test because valid Gemini API key is not set');
        return;
      }
      
      // Create test expenses
      final expenses = [
        Expense(
          id: '1',
          userId: 'test-user',
          date: DateTime.now(),
          amount: 50.0,
          currency: 'USD',
          category: 'Food & Dining',
          item: 'Lunch',
        ),
        Expense(
          id: '2',
          userId: 'test-user',
          date: DateTime.now().subtract(Duration(days: 1)),
          amount: 30.0,
          currency: 'USD',
          category: 'Transportation',
          item: 'Taxi',
        ),
      ];
      
      // Generate spending insights
      final insights = await aiService.generateSpendingInsights(expenses);
      
      // Verify insights are not empty
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
        contains('Dining'),
        contains('Transportation'),
      ));
    });
  });
}