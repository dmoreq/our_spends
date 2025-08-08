import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:our_spends/services/openai_service.dart';
import 'package:our_spends/services/claude_service.dart';
import 'package:our_spends/services/deepseek_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generate mocks
@GenerateMocks([GeminiService, OpenAIService, ClaudeService, DeepSeekService])
import 'ai_service_test.mocks.dart';

void main() {
  group('AIService Tests', () {
    late AIService aiService;
    late MockGeminiService mockGeminiService;
    late MockOpenAIService mockOpenAIService;
    late MockClaudeService mockClaudeService;
    late MockDeepSeekService mockDeepSeekService;

    setUp(() {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'ai_provider': 'gemini', // Set default provider for testing
      });
      
      // Create mock services
      mockGeminiService = MockGeminiService();
      mockOpenAIService = MockOpenAIService();
      mockClaudeService = MockClaudeService();
      mockDeepSeekService = MockDeepSeekService();
      
      // Create AIService instance with mocks
      aiService = AIService(
        geminiService: mockGeminiService,
        openaiService: mockOpenAIService,
        claudeService: mockClaudeService,
        deepseekService: mockDeepSeekService
      );
    });

    test('should initialize with default provider', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Initialize the service
      await aiService.initialize();
      
      // Verify default provider
      expect(aiService.currentProvider, 'gemini');
    });

    test('should change provider', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Initialize the service
      await aiService.initialize();
      
      // Change provider
      await aiService.setProvider('openai');
      
      // Verify provider was changed
      expect(aiService.currentProvider, 'openai');
      
      // Verify provider was saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ai_provider'), 'openai');
    });

    test('should process message with current provider', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Initialize the service
      await aiService.initialize();
      
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

    test('should test provider availability', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Initialize the service
      await aiService.initialize();
      
      // Setup mock response for successful test
      when(mockGeminiService.processMessage(
        any,
        any,
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) async => 'Test response');
      
      // Setup mock response for failed test
      when(mockOpenAIService.processMessage(
        any,
        any,
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).thenThrow(Exception('API Error'));
      
      // Test successful provider
      final geminiAvailable = await aiService.testProvider('gemini');
      expect(geminiAvailable, true);
      
      // Test failed provider
      final openaiAvailable = await aiService.testProvider('openai');
      expect(openaiAvailable, false);
    });

    test('should handle invalid provider gracefully', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Initialize the service
      await aiService.initialize();
      
      // Try to set an invalid provider
      await aiService.setProvider('invalid_provider');
      
      // Verify provider was not changed (still using default)
      expect(aiService.currentProvider, 'gemini');
      
      // Verify no preferences were saved
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ai_provider'), 'gemini');
    });
  });
}