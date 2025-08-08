import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/expense.dart';

class ClaudeService {
  static const String _baseUrl = ApiConfig.claudeBaseUrl;
  static const String _apiKey = ApiConfig.claudeApiKey;
  static const String _model = 'claude-3-haiku-20240307';
  static const String _anthropicVersion = '2023-06-01';

  /// Process a message using Anthropic Claude
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
        Uri.parse('$_baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': _anthropicVersion,
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': 1000,
          'messages': messages,
          'temperature': 0.7,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'];
        if (content is List && content.isNotEmpty) {
          return content[0]['text'] ?? 'No response generated';
        }
        return 'No response generated';
      } else {
        throw Exception('Claude API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Claude service error: $e');
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
  "date": "YYYY-MM-DD format"
}

For the date field:
- If a specific date is mentioned (like "yesterday", "today", or a date like "2023-05-15"), use that date.
- If a date is mentioned without a year (like "01/08"), interpret it as DD/MM format (day/month) and use the current year.
- If "yesterday" is mentioned, use yesterday's date in YYYY-MM-DD format.
- If "today" is mentioned, use today's date in YYYY-MM-DD format.
- If no date is mentioned, don't include the date field.

If no expense is mentioned, return null.

Message: "$message"
''';

      final response = await http.post(
        Uri.parse('$_baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': _anthropicVersion,
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': 200,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.1,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'];
        if (content is List && content.isNotEmpty) {
          final text = content[0]['text'];
          
          if (text.trim().toLowerCase() == 'null') {
            return null;
          }
          
          try {
            final result = jsonDecode(text);
            
            // If it's a valid expense, ensure time and location have default values if not provided
            if (result != null) {
              // Set default date to today if not provided
              if (result['date'] == null) {
                final now = DateTime.now();
                result['date'] = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                result['needs_date_confirmation'] = true;
              } else {
                result['needs_date_confirmation'] = false;
              }
              
              // Remove time field as we're focusing on date only
              result.remove('time');
              
              // Set default location to "Forgotted" if not provided
              if (result['location'] == null) {
                result['location'] = 'Forgotted';
                result['needs_location_confirmation'] = true;
              } else {
                result['needs_location_confirmation'] = false;
              }
            }
            
            return result;
          } catch (e) {
            return null;
          }
        }
        return null;
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
        Uri.parse('$_baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': _anthropicVersion,
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': 800,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'];
        if (content is List && content.isNotEmpty) {
          return content[0]['text'] ?? 'Unable to generate insights';
        }
        return 'Unable to generate insights';
      } else {
        throw Exception('Claude API error: ${response.statusCode}');
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

    // Add conversation history (Claude doesn't use system messages in the same way)
    if (conversationHistory != null) {
      for (final message in conversationHistory.take(10)) {
        if (message['role'] != 'system') {
          messages.add(message);
        }
      }
    }

    // Add current user message with system context
    final systemContext = 'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.';
    
    messages.add({
      'role': 'user',
      'content': '$systemContext\n\n$prompt',
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