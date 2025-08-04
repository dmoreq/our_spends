import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';
import '../config/api_config.dart';

class GeminiService {
  static const String _apiKey = ApiConfig.geminiApiKey;
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  /// Process a chat message and return AI response with conversation memory
  Future<String> processMessage(String message, List<Expense> userExpenses, {List<Map<String, String>>? conversationHistory}) async {
    try {
      // Create context about user's expenses for better AI responses
      final expenseContext = _buildExpenseContext(userExpenses);
      
      // Build conversation history context
      final conversationContext = _buildConversationContext(conversationHistory ?? []);
      
      // Create the prompt with context and conversation history
      final prompt = '''
You are a helpful AI assistant for a family expense tracker app. Your role is to:
1. Help users track and categorize their expenses
2. Provide insights about spending patterns
3. Answer questions about their financial data
4. Suggest ways to save money
5. Remember and reference previous parts of our conversation

Current user expenses context:
$expenseContext

$conversationContext

Current user message: $message

Please provide a helpful, concise response. If the user mentions a purchase or expense, acknowledge it and offer to help categorize it. Reference previous conversation when relevant.
''';

      final response = await _makeGeminiRequest(prompt);
      return response ?? 'Sorry, I couldn\'t process your message. Please try again.';
    } catch (e) {
      throw Exception('Failed to get AI response: ${e.toString()}');
    }
  }

  /// Extract expense information from user message
  Future<Map<String, dynamic>?> extractExpenseInfo(String message) async {
    try {
      final prompt = '''
Analyze this message and extract expense information if any. Return a JSON object with the following structure if an expense is mentioned:
{
  "hasExpense": true,
  "amount": number,
  "description": "string",
  "category": "string (one of: food, transport, shopping, entertainment, bills, healthcare, other)",
  "confidence": number (0-1)
}

If no expense is mentioned, return:
{
  "hasExpense": false
}

Message: $message

Only return the JSON object, no other text.
''';

      final response = await _makeGeminiRequest(prompt);
      
      if (response != null) {
        // Parse the JSON response
        try {
          final jsonStr = response.trim();
          // Remove markdown code blocks if present
          final cleanJson = jsonStr.replaceAll(RegExp(r'```json\s*|\s*```'), '');
          
          // Try to parse as JSON
          final parsed = jsonDecode(cleanJson);
          return parsed is Map<String, dynamic> ? parsed : {'hasExpense': false};
        } catch (e) {
          // If parsing fails, try to detect expense manually
          return _detectExpenseManually(message);
        }
      }
      return {'hasExpense': false};
    } catch (e) {
      return _detectExpenseManually(message);
    }
  }

  /// Generate spending insights
  Future<String> generateSpendingInsights(List<Expense> expenses) async {
    if (expenses.isEmpty) {
      return 'Start tracking your expenses to get personalized insights! 📊\n\nOnce you add some expenses, I can help you:\n• Analyze spending patterns\n• Identify top categories\n• Suggest ways to save money';
    }

    try {
      final expenseContext = _buildExpenseContext(expenses);
      
      final prompt = '''
Based on the following expense data, provide helpful spending insights and suggestions:

$expenseContext

Please provide:
1. A brief summary of spending patterns
2. Top spending categories
3. 2-3 actionable suggestions for better financial management

Keep the response concise and friendly.
''';

      final response = await _makeGeminiRequest(prompt);
      return response ?? _generateBasicInsights(expenses);
    } catch (e) {
      return _generateBasicInsights(expenses);
    }
  }

  /// Make HTTP request to Gemini API
  Future<String?> _makeGeminiRequest(String prompt) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      // Return a helpful message if API key is not configured
      return 'Please configure your Gemini API key in lib/config/api_config.dart to enable AI features. Visit https://ai.google.dev/ to get your free API key.';
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] as String?;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Build context string from user's expenses
  String _buildExpenseContext(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return 'No expenses recorded yet.';
    }

    final recentExpenses = expenses.take(10).toList();
    final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    
    final context = StringBuffer();
    context.writeln('Total expenses: \$${totalAmount.toStringAsFixed(2)}');
    context.writeln('Number of expenses: ${expenses.length}');
    context.writeln('Recent expenses:');
    
    for (final expense in recentExpenses) {
      context.writeln('- \$${expense.amount.toStringAsFixed(2)} for ${expense.item} (${expense.category})');
    }
    
    return context.toString();
  }

  /// Build conversation history context
  String _buildConversationContext(List<Map<String, String>> conversationHistory) {
    if (conversationHistory.isEmpty) {
      return 'This is the start of our conversation.';
    }

    final context = StringBuffer();
    context.writeln('Previous conversation:');
    
    // Show last 10 messages to keep context manageable
    final recentHistory = conversationHistory.take(10).toList();
    
    for (final message in recentHistory) {
      final role = message['role'] ?? 'unknown';
      final content = message['content'] ?? '';
      final prefix = role == 'user' ? 'User:' : 'Assistant:';
      context.writeln('$prefix $content');
    }
    
    return context.toString();
  }

  /// Fallback method to detect expenses manually using simple patterns
  Map<String, dynamic> _detectExpenseManually(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Look for money patterns
    final moneyPattern = RegExp(r'\$?(\d+(?:\.\d{2})?)', caseSensitive: false);
    final match = moneyPattern.firstMatch(message);
    
    // Look for expense keywords
    final expenseKeywords = ['bought', 'spent', 'paid', 'cost', 'price', 'purchase', 'bill'];
    final hasExpenseKeyword = expenseKeywords.any((keyword) => lowerMessage.contains(keyword));
    
    if (match != null && hasExpenseKeyword) {
      final amount = double.tryParse(match.group(1) ?? '0') ?? 0;
      return {
        'hasExpense': true,
        'amount': amount,
        'description': message,
        'category': 'other',
        'confidence': 0.7,
      };
    }
    
    return {'hasExpense': false};
  }

  /// Generate basic insights without AI
  String _generateBasicInsights(List<Expense> expenses) {
    final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final avgExpense = totalAmount / expenses.length;
    
    // Group by category
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    
    // Find top category
    final topCategory = categoryTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
    
    return '''
📊 Your Spending Insights

💰 Total Expenses: \$${totalAmount.toStringAsFixed(2)}
📈 Average per transaction: \$${avgExpense.toStringAsFixed(2)}
🏆 Top category: ${topCategory.key} (\$${topCategory.value.toStringAsFixed(2)})

💡 Suggestions:
• Track daily expenses to identify patterns
• Set monthly budgets for each category
• Look for opportunities to reduce spending in your top category

Configure your Gemini API key for more detailed AI insights!
''';
  }
}