import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'gemini_service.dart';
import 'openai_service.dart';
import 'claude_service.dart';
import 'deepseek_service.dart';
import '../models/expense.dart';

class AIService {
  late GeminiService _geminiService;
  late OpenAIService _openaiService;
  late ClaudeService _claudeService;
  late DeepSeekService _deepseekService;
  
  String _currentProvider = ApiConfig.defaultProvider;
  bool _initialized = false;

  // Constructor
  AIService({
    GeminiService? geminiService,
    OpenAIService? openaiService,
    ClaudeService? claudeService,
    DeepSeekService? deepseekService,
  }) {
    _initializeServices(geminiService, openaiService, claudeService, deepseekService);
  }

  void _initializeServices(
    GeminiService? geminiService,
    OpenAIService? openaiService,
    ClaudeService? claudeService,
    DeepSeekService? deepseekService,
  ) {
    _geminiService = geminiService ?? GeminiService();
    _openaiService = openaiService ?? OpenAIService();
    _claudeService = claudeService ?? ClaudeService();
    _deepseekService = deepseekService ?? DeepSeekService();
  }

  // Initialize with settings from shared preferences
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentProvider = prefs.getString('ai_provider') ?? ApiConfig.defaultProvider;
      _initialized = true;
    } catch (e) {
      // Fallback to default provider if loading fails
      _currentProvider = ApiConfig.defaultProvider;
      _initialized = true;
    }
  }

  // Get current provider
  String get currentProvider => _currentProvider;

  // Set provider
  Future<void> setProvider(String provider) async {
    if (ApiConfig.supportedProviders.contains(provider)) {
      _currentProvider = provider;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ai_provider', provider);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  /// Process message using the current AI provider
  Future<String> processMessage(
    String message, 
    List<Expense> userExpenses, {
    List<Map<String, String>>? conversationHistory,
    String? languageCode,
  }) async {
    await initialize();
    
    switch (_currentProvider) {
      case 'gemini':
        return await _geminiService.processMessage(
          message, 
          userExpenses, 
          conversationHistory: conversationHistory,
          languageCode: languageCode,
        );
      case 'openai':
        return await _openaiService.processMessage(
          message, 
          userExpenses, 
          conversationHistory: conversationHistory,
          languageCode: languageCode,
        );
      case 'claude':
        return await _claudeService.processMessage(
          message, 
          userExpenses, 
          conversationHistory: conversationHistory,
          languageCode: languageCode,
        );
      case 'deepseek':
        return await _deepseekService.processMessage(
          message, 
          userExpenses, 
          conversationHistory: conversationHistory,
          languageCode: languageCode,
        );
      default:
        return await _geminiService.processMessage(
          message, 
          userExpenses, 
          conversationHistory: conversationHistory,
          languageCode: languageCode,
        );
    }
  }

  /// Extract expense information from message using the current AI provider
  Future<Map<String, dynamic>?> extractExpenseInfo(String message) async {
    await initialize();
    
    switch (_currentProvider) {
      case 'gemini':
        return await _geminiService.extractExpenseInfo(message);
      case 'openai':
        return await _openaiService.extractExpenseInfo(message);
      case 'claude':
        return await _claudeService.extractExpenseInfo(message);
      case 'deepseek':
        return await _deepseekService.extractExpenseInfo(message);
      default:
        return await _geminiService.extractExpenseInfo(message);
    }
  }

  /// Generate spending insights using the current AI provider
  Future<String> generateSpendingInsights(
    List<Expense> expenses, {
    String? provider,
  }) async {
    await initialize();
    
    final selectedProvider = provider ?? _currentProvider;
    
    try {
      switch (selectedProvider) {
        case 'gemini':
          return await _geminiService.generateSpendingInsights(expenses);
        case 'openai':
          return await _openaiService.generateSpendingInsights(expenses);
        case 'claude':
          return await _claudeService.generateSpendingInsights(expenses);
        case 'deepseek':
          return await _deepseekService.generateSpendingInsights(expenses);
        default:
          return await _geminiService.generateSpendingInsights(expenses);
      }
    } catch (e) {
      // Fallback to Gemini if the selected provider fails
      if (selectedProvider != 'gemini') {
        try {
          return await _geminiService.generateSpendingInsights(expenses);
        } catch (fallbackError) {
          throw Exception('All AI providers failed: $e, $fallbackError');
        }
      }
      throw Exception('AI service error: $e');
    }
  }

  /// Test if a provider is working
  Future<bool> testProvider(String provider) async {
    try {
      final testMessage = "Hello, this is a test message.";
      final originalProvider = _currentProvider;
      _currentProvider = provider;
      await processMessage(testMessage, []);
      _currentProvider = originalProvider;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get provider display name
  String getProviderName(String provider) {
    switch (provider) {
      case 'gemini':
        return 'Google Gemini';
      case 'openai':
        return 'OpenAI ChatGPT';
      case 'claude':
        return 'Anthropic Claude';
      case 'deepseek':
        return 'DeepSeek';
      default:
        return provider.toUpperCase();
    }
  }

  /// Get provider model name
  String getProviderModel(String provider) {
    return ApiConfig.defaultModels[provider] ?? 'Unknown';
  }

  /// Get available providers (those with valid API keys)
  Future<List<String>> getAvailableProviders() async {
    final availableProviders = <String>[];
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      for (String provider in ApiConfig.supportedProviders) {
        final apiKey = prefs.getString('${provider}_api_key') ?? '';
        if (_isValidApiKey(apiKey)) {
          availableProviders.add(provider);
        }
      }
    } catch (e) {
      // If we can't load from preferences, return all providers
      return List.from(ApiConfig.supportedProviders);
    }
    
    return availableProviders;
  }

  /// Get provider status
  Future<Map<String, dynamic>> getProviderStatus() async {
    final status = <String, dynamic>{};
    final availableProviders = await getAvailableProviders();
    
    for (final provider in ApiConfig.supportedProviders) {
      final isAvailable = availableProviders.contains(provider);
      final isWorking = isAvailable ? await testProvider(provider) : false;
      
      status[provider] = {
        'name': getProviderName(provider),
        'model': getProviderModel(provider),
        'available': isAvailable,
        'working': isWorking,
        'current': provider == _currentProvider,
      };
    }
    
    return status;
  }

  // Helper methods
  bool _isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty && 
           !apiKey.contains('YOUR_') && 
           !apiKey.contains('_HERE') &&
           apiKey.length > 10;
  }
}