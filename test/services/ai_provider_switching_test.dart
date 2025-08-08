import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:our_spends/services/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AI Provider Switching Tests', () {
    late AIService aiService;
    
    setUp(() async {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'ai_provider': 'gemini', // Set default provider for testing
      });
      
      // Create service instance
      aiService = AIService();
      
      // Initialize the service
      await aiService.initialize();
    });

    test('AIService should initialize with default provider', () {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      expect(aiService.currentProvider, 'gemini');
    });

    test('AIService should change provider', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Change provider to OpenAI
      await aiService.setProvider('openai');
      
      // Verify provider was changed
      expect(aiService.currentProvider, 'openai');
      
      // Verify provider was saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ai_provider'), 'openai');
      
      // Change provider to Claude
      await aiService.setProvider('claude');
      
      // Verify provider was changed
      expect(aiService.currentProvider, 'claude');
      
      // Verify provider was saved to SharedPreferences
      final prefs2 = await SharedPreferences.getInstance();
      expect(prefs2.getString('ai_provider'), 'claude');
      
      // Change provider to DeepSeek
      await aiService.setProvider('deepseek');
      
      // Verify provider was changed
      expect(aiService.currentProvider, 'deepseek');
      
      // Verify provider was saved to SharedPreferences
      final prefs3 = await SharedPreferences.getInstance();
      expect(prefs3.getString('ai_provider'), 'deepseek');
      
      // Change provider back to Gemini
      await aiService.setProvider('gemini');
      
      // Verify provider was changed
      expect(aiService.currentProvider, 'gemini');
      
      // Verify provider was saved to SharedPreferences
      final prefs4 = await SharedPreferences.getInstance();
      expect(prefs4.getString('ai_provider'), 'gemini');
    });

    test('AIService should handle invalid provider', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Try to set an invalid provider
      await aiService.setProvider('invalid_provider');
      
      // Verify provider was not changed (still using default)
      expect(aiService.currentProvider, 'gemini');
      
      // Verify provider was not saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ai_provider'), 'gemini');
    });

    test('AIService should process messages with different providers', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Skip this test as it requires real API keys
      markTestSkipped('Skipping test because it requires real API keys');
    });
  });
}