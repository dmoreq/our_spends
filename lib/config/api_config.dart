class ApiConfig {
  // AI Provider API Keys
  // Replace these with your actual API keys
  
  // Gemini AI (Google)
  // Get your API key from: https://ai.google.dev/
  static const String geminiApiKey = 'AIzaSyA_8uPpEl5FW4FejjSO38b9rexEHOieUvI';
  
  // OpenAI ChatGPT
  // Get your API key from: https://platform.openai.com/api-keys
  static const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: 'YOUR_OPENAI_API_KEY_HERE');
  
  // Anthropic Claude
  // Get your API key from: https://console.anthropic.com/
  static const String claudeApiKey = String.fromEnvironment('CLAUDE_API_KEY', defaultValue: 'YOUR_CLAUDE_API_KEY_HERE');
  
  // DeepSeek
  // Get your API key from: https://platform.deepseek.com/
  static const String deepseekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY', defaultValue: 'YOUR_DEEPSEEK_API_KEY_HERE');
  
  // API Endpoints
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String claudeBaseUrl = 'https://api.anthropic.com/v1';
  static const String deepseekBaseUrl = 'https://api.deepseek.com/v1';
  
  // Default AI Provider
  static const String defaultProvider = 'gemini'; // Options: 'gemini', 'openai', 'claude', 'deepseek'
  
  // Supported providers list
  static const List<String> supportedProviders = ['gemini', 'openai', 'claude', 'deepseek'];
  
  // Model configurations
  static const Map<String, String> defaultModels = {
    'gemini': 'gemini-1.5-flash',
    'openai': 'gpt-4o-mini',
    'claude': 'claude-3-haiku-20240307',
    'deepseek': 'deepseek-chat',
  };
  
  // Rate limiting and retry configurations
  static const int maxRetries = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 1);
}