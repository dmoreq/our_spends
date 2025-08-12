class ApiConfig {
  // AI Provider API Key
  // Replace this with your actual API key
  
  // Gemini AI (Google)
  // Get your API key from: https://ai.google.dev/
  static const String geminiApiKey = 'AIzaSyA_8uPpEl5FW4FejjSO38b9rexEHOieUvI';
  
  // Model configuration
  static const Map<String, String> defaultModels = {
    'gemini': 'gemini-2.5-flash',
  };
  
  // Rate limiting and retry configurations
  static const int maxRetries = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 1);
}