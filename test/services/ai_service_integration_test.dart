import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AIService Integration Tests', () {
    late AIService aiService;

    setUp(() async {
      // Setup SharedPreferences for testing
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'YOUR_API_KEY_HERE', // Use a placeholder for tests
      });
      
      // Initialize services
      final geminiService = GeminiService();
      aiService = AIService(geminiService: geminiService);
    });

    test('AIService should initialize correctly', () {
      expect(aiService, isNotNull);
    });

    test('AIService should provide provider information', () {
      final providerName = aiService.getProviderName();
      final providerModel = aiService.getProviderModel();
      
      expect(providerName, 'Google Gemini');
      expect(providerModel, isNotNull);
    });

    test('isGeminiAvailable should return false with placeholder API key', () async {
      final isAvailable = await aiService.isGeminiAvailable();
      expect(isAvailable, isFalse);
    });

    test('getGeminiStatus should return correct status with placeholder API key', () async {
      final status = await aiService.getGeminiStatus();
      expect(status, isNotNull);
      expect(status['name'], 'Google Gemini');
      expect(status['available'], isFalse);
      expect(status['working'], isFalse);
    });

    // Skip actual API tests if no valid API key is available
    test('processMessage should handle messages without API key', () async {
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          item: 'Lunch',
        ),
      ];
      
      // This should not throw an error, but return a message about API key
      final response = await aiService.processMessage(
        'How much did I spend on food?',
        expenses,
      );
      
      expect(response, contains('API key'));
    });

    test('extractExpenseInfo should handle messages without API key', () async {
      // This should not throw an error, but return a message about API key
      final response = await aiService.extractExpenseInfo(
        'I spent 10 on coffee',
      );
      
      expect(response, isNotNull);
      // The response might be null or a Map with an error key
      if (response != null) {
        expect(response.containsKey('error') || response.containsKey('message'), isTrue);
      }
    });

    test('generateSpendingInsights should handle expenses without API key', () async {
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          item: 'Lunch',
        ),
      ];
      
      // This should not throw an error, but return a message about API key
      final response = await aiService.generateSpendingInsights(expenses);
      
      expect(response, contains('API key'));
    });
  });
}