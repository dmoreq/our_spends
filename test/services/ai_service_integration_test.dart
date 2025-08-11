import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:our_spends/services/gemini_service.dart';
import 'package:our_spends/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_api/test_api.dart' show Timeout;

void main() {
  group('AI Service Integration Tests', () {
    late AIService aiService;
    late GeminiService geminiService;
    
    setUp(() async {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({
        'gemini_api_key': 'test_api_key_12345', // Set test API key
      });
      
      // Create service instances
      geminiService = GeminiService();
      
      // Create AIService instance with real services
      aiService = AIService(
        geminiService: geminiService,
      );
      
      // Initialize the service
      await aiService.initialize();
    });

    test('AIService should initialize correctly', timeout: Timeout(Duration(seconds: 10)), () {
      expect(aiService, isNotNull);
    });

    test('AIService should return correct provider information', timeout: Timeout(Duration(seconds: 10)), () {
      expect(aiService.getProviderName(), 'Google Gemini');
      expect(aiService.getProviderModel(), isNotNull);
    });
    
    test('AIService should check Gemini availability', timeout: Timeout(Duration(seconds: 10)), () async {
      final status = await aiService.getGeminiStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status['name'], 'Google Gemini');
      expect(status['available'], isTrue);
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
  
  // Add additional integration tests for AIService with GeminiService
  test('AIService should process messages through GeminiService', timeout: Timeout(Duration(seconds: 30)), () async {
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
        id: 'id1',
        userId: 'user1',
        date: DateTime(2023, 5, 15),
        amount: 50.0,
        currency: 'USD',
        category: 'Food & Dining',
        item: 'Lunch',
      ),
    ];
    
    // Process a test message
    final response = await aiService.processMessage(
      'How much did I spend on food?',
      expenses,
    );
    
    // Verify response is not empty
    expect(response, isNotNull);
    expect(response.isNotEmpty, isTrue);
  });
  
  test('AIService should extract expense information through GeminiService', timeout: Timeout(Duration(seconds: 30)), () async {
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
    expect(result!['amount'], 50);
    expect(result['description'] ?? result['item'], contains('groceries'));
  });
  
  test('AIService should generate spending insights through GeminiService', timeout: Timeout(Duration(seconds: 30)), () async {
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
    final insights = await aiService.generateSpendingInsights(expenses);
    
    // Verify insights are not empty
    expect(insights, isNotNull);
    expect(insights.isNotEmpty, isTrue);
  });
}