import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'gemini_service.dart';
import '../models/expense.dart';

class AIService {
  late GeminiService _geminiService;
  bool _initialized = false;

  // Constructor
  AIService({
    GeminiService? geminiService,
  }) {
    _initializeServices(geminiService);
  }

  void _initializeServices(
    GeminiService? geminiService,
  ) {
    _geminiService = geminiService ?? GeminiService();
  }

  // Initialize the service
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Nothing to initialize from preferences anymore
      _initialized = true;
    } catch (e) {
      // Handle initialization error
      _initialized = true;
    }
  }

  /// Process message using Gemini
  Future<String> processMessage(
    String message, 
    List<Expense> userExpenses, {
    List<Map<String, String>>? conversationHistory,
    String? languageCode,
  }) async {
    await initialize();
    
    return await _geminiService.processMessage(
      message, 
      userExpenses, 
      conversationHistory: conversationHistory,
      languageCode: languageCode,
    );

  }

  /// Extract expense information from message using Gemini
  Future<Map<String, dynamic>?> extractExpenseInfo(String message) async {
    await initialize();
    return await _geminiService.extractExpenseInfo(message);
  }

  /// Generate spending insights using Gemini
  Future<String> generateSpendingInsights(
    List<Expense> expenses
  ) async {
    await initialize();
    
    try {
      return await _geminiService.generateSpendingInsights(expenses);
    } catch (e) {
      throw Exception('AI service error: $e');
    }
  }

  /// Test if Gemini is working
  Future<bool> testGemini() async {
    try {
      final testMessage = "Hello, this is a test message.";
      await processMessage(testMessage, []);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get provider display name
  String getProviderName() {
    return 'Google Gemini';
  }

  /// Get provider model name
  String getProviderModel() {
    return ApiConfig.defaultModels['gemini'] ?? 'Unknown';
  }

  /// Check if Gemini API key is valid
  Future<bool> isGeminiAvailable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key') ?? ApiConfig.geminiApiKey;
      return _isValidApiKey(apiKey);
    } catch (e) {
      // If we can't load from preferences, check the default API key
      return _isValidApiKey(ApiConfig.geminiApiKey);
    }
  }

  /// Get Gemini status
  Future<Map<String, dynamic>> getGeminiStatus() async {
    final isAvailable = await isGeminiAvailable();
    final isWorking = isAvailable ? await testGemini() : false;
    
    return {
      'name': getProviderName(),
      'model': getProviderModel(),
      'available': isAvailable,
      'working': isWorking,
    };
  }

  // Helper methods
  bool _isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty && 
           !apiKey.contains('YOUR_') && 
           !apiKey.contains('_HERE') &&
           apiKey.length > 10;
  }
}