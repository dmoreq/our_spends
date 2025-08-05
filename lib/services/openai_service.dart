import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/expense.dart';

class OpenAIService {
  static const String _baseUrl = ApiConfig.openaiBaseUrl;
  static const String _apiKey = ApiConfig.openaiApiKey;
  static const String _model = 'gpt-4o-mini';

  /// Process a message using OpenAI ChatGPT
  Future<String> processMessage(
    String message,
    List<Expense> userExpenses, {
    List<Map<String, String>>? conversationHistory,
    String? languageCode,
  }) async {
    try {
      final prompt = _buildPrompt(message, userExpenses, languageCode);
      final messages = _buildMessages(prompt, conversationHistory);

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': 1000,
          'temperature': 0.7,
          'stream': false,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response generated';
      } else {
        throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('OpenAI service error: $e');
    }
  }

  /// Extract expense information from a message
  Future<Map<String, dynamic>?> extractExpenseInfo(String message) async {
    try {
      final prompt = '''
Analyze this message and extract expense information. Return ONLY a JSON object with these fields if an expense is mentioned:
{
  "amount": number,
  "currency": "VND",
  "category": "food|transport|shopping|entertainment|bills|healthcare|education|travel|family|other",
  "item": "description of what was bought",
  "location": "where it was purchased (if mentioned)",
  "date": "YYYY-MM-DD format (today if not specified)"
}

If no expense is mentioned, return null.

Message: "$message"
''';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 200,
          'temperature': 0.1,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        if (content.trim().toLowerCase() == 'null') {
          return null;
        }
        
        try {
          return jsonDecode(content);
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Generate spending insights
  Future<String> generateSpendingInsights(List<Expense> expenses) async {
    try {
      if (expenses.isEmpty) {
        return 'No expenses to analyze. Start tracking your expenses to get insights!';
      }

      final expenseContext = _buildExpenseContext(expenses);
      final prompt = '''
Analyze these expense data and provide helpful spending insights:

$expenseContext

Please provide:
1. Total spending summary
2. Top spending categories
3. Spending patterns and trends
4. Money-saving recommendations
5. Budget suggestions

Keep the response concise and actionable.
''';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 800,
          'temperature': 0.7,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'Unable to generate insights';
      } else {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error generating insights: $e';
    }
  }

  List<Map<String, String>> _buildMessages(
    String prompt,
    List<Map<String, String>>? conversationHistory,
  ) {
    final messages = <Map<String, String>>[];
    
    // Add system message
    messages.add({
      'role': 'system',
      'content': 'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.',
    });

    // Add conversation history
    if (conversationHistory != null) {
      for (final message in conversationHistory.take(10)) {
        messages.add(message);
      }
    }

    // Add current user message
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    return messages;
  }

  String _buildPrompt(
    String message,
    List<Expense> userExpenses,
    String? languageCode,
  ) {
    final expenseContext = userExpenses.isNotEmpty 
        ? _buildExpenseContext(userExpenses.take(20).toList())
        : 'No recent expenses recorded.';

    final language = languageCode == 'vi' ? 'Vietnamese' : 'English';

    return '''
User message: "$message"

Recent expenses context:
$expenseContext

Please respond in $language and help the user with their expense tracking needs.
''';
  }

  String _buildExpenseContext(List<Expense> expenses) {
    if (expenses.isEmpty) return 'No expenses recorded.';

    final buffer = StringBuffer();
    buffer.writeln('Recent expenses:');
    
    for (final expense in expenses.take(10)) {
      buffer.writeln('- ${expense.item}: ${expense.amount} ${expense.currency} (${expense.category}) on ${expense.date.toString().split(' ')[0]}');
    }

    // Add summary statistics
    final total = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final categories = expenses.map((e) => e.category).toSet();
    
    buffer.writeln('\nSummary:');
    buffer.writeln('- Total: ${total.toStringAsFixed(0)} VND');
    buffer.writeln('- Categories: ${categories.join(', ')}');
    buffer.writeln('- Count: ${expenses.length} expenses');

    return buffer.toString();
  }
}