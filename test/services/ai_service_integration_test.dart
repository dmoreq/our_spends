import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:our_spends/services/openai_service.dart';
import 'package:our_spends/services/claude_service.dart';
import 'package:our_spends/services/deepseek_service.dart';
import 'package:our_spends/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_api/test_api.dart' show Timeout;

void main() {
  group('AI Service Integration Tests', () {
    late AIService aiService;
    late GeminiService geminiService;
    late OpenAIService openaiService;
    late ClaudeService claudeService;
    late DeepSeekService deepseekService;
    
    setUp(() async {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'ai_provider': 'gemini', // Set default provider for testing
      });
      
      // Create service instances
      geminiService = GeminiService();
      openaiService = OpenAIService();
      claudeService = ClaudeService();
      deepseekService = DeepSeekService();
      
      // Create AIService instance with real services
      aiService = AIService(
        geminiService: geminiService,
        openaiService: openaiService,
        claudeService: claudeService,
        deepseekService: deepseekService
      );
      
      // Initialize the service
      await aiService.initialize();
    });

    test('AIService should initialize with default provider', timeout: Timeout(Duration(seconds: 10)), () {
      expect(aiService.currentProvider, 'gemini');
    });

    test('AIService should change provider', timeout: Timeout(Duration(seconds: 10)), () async {
      // Change provider
      await aiService.setProvider('openai');
      
      // Verify provider was changed
      expect(aiService.currentProvider, 'openai');
      
      // Verify provider was saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ai_provider'), 'openai');
    });
  });
  
  group('GeminiService Integration Tests', () {
    late GeminiService geminiService;
    
    setUp(() {
      geminiService = GeminiService();
    });
    
    test('GeminiService should extract expense information', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('GEMINI_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because GEMINI_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with a simple message
      final result = await geminiService.extractExpenseInfo('I spent \$50 on groceries yesterday');
      
      // Verify result structure
      expect(result, isNotNull);
      expect(result!['hasExpense'], isTrue);
      expect(result['amount'], 50);
      expect(result['description'] ?? result['item'], contains('groceries'));
      
      // Verify date is yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayFormatted = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      expect(result['date'], yesterdayFormatted);
    });
    
    test('GeminiService should extract expense with DD/MM format', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('GEMINI_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because GEMINI_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with DD/MM format
      final result = await geminiService.extractExpenseInfo('I spent \$50 on groceries on 01/08');
      
      // Verify result structure
      expect(result, isNotNull);
      expect(result!['hasExpense'], isTrue);
      expect(result['amount'], 50);
      
      // Verify date is August 1st of 2025 (hardcoded in test)
      expect(result['date'], '2025-08-01', reason: 'Date should be formatted as YYYY-MM-DD with 2025 as year and DD/MM format (01/08 -> August 1st)');
    });
  });
  
  group('OpenAIService Integration Tests', () {
    late OpenAIService openaiService;
    
    setUp(() {
      openaiService = OpenAIService();
    });
    
    test('OpenAIService should extract expense information', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('OPENAI_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because OPENAI_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with a simple message
      final result = await openaiService.extractExpenseInfo('I spent \$50 on groceries yesterday');
      
      // Verify result structure
      expect(result, isNotNull);
      
      // Verify date is yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayFormatted = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      expect(result!['date'], yesterdayFormatted);
    });
    
    test('OpenAIService should extract expense with DD/MM format', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('OPENAI_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because OPENAI_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with DD/MM format
      final result = await openaiService.extractExpenseInfo('I spent \$50 on groceries on 01/08');
      
      // Verify result structure
      expect(result, isNotNull);
      
      // Verify date is August 1st of current year
      final currentYear = DateTime.now().year;
      expect(result!['date'], '$currentYear-08-01');
    });
  });
  
  group('ClaudeService Integration Tests', () {
    late ClaudeService claudeService;
    
    setUp(() {
      claudeService = ClaudeService();
    });
    
    test('ClaudeService should extract expense information', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('CLAUDE_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because CLAUDE_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with a simple message
      final result = await claudeService.extractExpenseInfo('I spent \$50 on groceries yesterday');
      
      // Verify result structure
      expect(result, isNotNull);
      
      // Verify date is yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayFormatted = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      expect(result!['date'], yesterdayFormatted);
    });
    
    test('ClaudeService should extract expense with DD/MM format', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('CLAUDE_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because CLAUDE_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with DD/MM format
      final result = await claudeService.extractExpenseInfo('I spent \$50 on groceries on 01/08');
      
      // Verify result structure
      expect(result, isNotNull);
      
      // Verify date is August 1st of current year
      final currentYear = DateTime.now().year;
      expect(result!['date'], '$currentYear-08-01');
    });
  });
  
  group('DeepSeekService Integration Tests', () {
    late DeepSeekService deepseekService;
    
    setUp(() {
      deepseekService = DeepSeekService();
    });
    
    test('DeepSeekService should extract expense information', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('DEEPSEEK_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because DEEPSEEK_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with a simple message
      final result = await deepseekService.extractExpenseInfo('I spent \$50 on groceries yesterday');
      
      // Verify result structure
      expect(result, isNotNull);
      
      // Verify date is yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayFormatted = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      expect(result!['date'], yesterdayFormatted);
    });
    
    test('DeepSeekService should extract expense with DD/MM format', timeout: Timeout(Duration(seconds: 10)), () async {
      // Skip if API key is not configured
      if (const String.fromEnvironment('DEEPSEEK_API_KEY').isEmpty) {
        markTestSkipped('Skipping test because DEEPSEEK_API_KEY is not set');
        return;
      }
      
      // Test expense extraction with DD/MM format
      final result = await deepseekService.extractExpenseInfo('I spent \$50 on groceries on 01/08');
      
      // Verify result structure
      expect(result, isNotNull);
      
      // Verify date is August 1st of current year
      final currentYear = DateTime.now().year;
      expect(result!['date'], '$currentYear-08-01');
    });
  });
}