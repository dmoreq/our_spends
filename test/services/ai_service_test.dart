import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generate mocks
@GenerateMocks([GeminiService])
import 'ai_service_test.mocks.dart';

void main() {
  group('AIService Tests', () {
    late AIService aiService;
    late MockGeminiService mockGeminiService;

    setUp(() {
      // Create mock services
      mockGeminiService = MockGeminiService();
      
      // Create AIService instance with mocks
      aiService = AIService(
        geminiService: mockGeminiService,
      );
    });

    test('should process message with Gemini service', () async {
      // Create test expenses
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
      
      // Setup mock response
      when(mockGeminiService.processMessage(
        'How much did I spend on food?',
        expenses,
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) async => 'You spent \$50.00 on Food & Dining');
      
      // Process a test message
      final response = await aiService.processMessage(
        'How much did I spend on food?',
        expenses,
      );
      
      // Verify response
      expect(response, 'You spent \$50.00 on Food & Dining');
      
      // Verify the correct service was called
      verify(mockGeminiService.processMessage(
        'How much did I spend on food?',
        expenses,
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).called(1);
    });

    test('should extract expense info with Gemini service', () async {
      final expectedResponse = {'amount': 10.0, 'description': 'coffee'};
      // Setup mock response
      when(mockGeminiService.extractExpenseInfo(any))
          .thenAnswer((_) async => expectedResponse);
      
      // Process a test message
      final response = await aiService.extractExpenseInfo(
        'I spent 10 on coffee',
      );
      
      // Verify response
      expect(response, expectedResponse);
      
      // Verify the correct service was called
      verify(mockGeminiService.extractExpenseInfo(any)).called(1);
    });

    test('should generate spending insights with Gemini service', () async {
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
      // Setup mock response
      when(mockGeminiService.generateSpendingInsights(any))
          .thenAnswer((_) async => 'You are spending a lot on food.');
      
      // Process a test message
      final response = await aiService.generateSpendingInsights(
        expenses,
      );
      
      // Verify response
      expect(response, 'You are spending a lot on food.');
      
      // Verify the correct service was called
      verify(mockGeminiService.generateSpendingInsights(any)).called(1);
    });

    test('testGemini should return true on success', () async {
      when(mockGeminiService.processMessage(any, any)).thenAnswer((_) async => "Success");
      final result = await aiService.testGemini();
      expect(result, isTrue);
    });

    test('testGemini should return false on failure', () async {
      when(mockGeminiService.processMessage(any, any)).thenThrow(Exception());
      final result = await aiService.testGemini();
      expect(result, isFalse);
    });
    
    test('getGeminiStatus should return correct status information', () async {
      // Setup SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'test_api_key_12345',
      });
      
      // Setup mock response for testGemini
      when(mockGeminiService.processMessage(any, any)).thenAnswer((_) async => "Success");
      
      // Get Gemini status
      final status = await aiService.getGeminiStatus();
      
      // Verify status structure and values
      expect(status, isA<Map<String, dynamic>>());
      expect(status['name'], 'Google Gemini');
      expect(status['model'], isNotNull);
      expect(status['available'], isTrue);
      expect(status['working'], isTrue);
    });
    
    test('getGeminiStatus should handle unavailable API key', () async {
      // Setup SharedPreferences mock with invalid API key
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'YOUR_API_KEY_HERE',
      });
      
      // Get Gemini status
      final status = await aiService.getGeminiStatus();
      
      // Verify status shows API is not available
      expect(status['available'], isFalse);
      expect(status['working'], isFalse);
    });
    
    test('isGeminiAvailable should validate API key correctly', () async {
      // Setup SharedPreferences mock with valid API key
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'valid_api_key_12345',
      });
      
      // Check if Gemini is available
      final isAvailable = await aiService.isGeminiAvailable();
      
      // Verify result
      expect(isAvailable, isTrue);
    });
  });
}