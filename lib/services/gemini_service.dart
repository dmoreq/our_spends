import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';
import '../config/api_config.dart';

class GeminiService {
  static const String _apiKey = ApiConfig.geminiApiKey;
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  /// Process a chat message and return AI response with conversation memory
  Future<String> processMessage(String message, List<Expense> userExpenses, {List<Map<String, String>>? conversationHistory, String? languageCode}) async {
    try {
      // Create context about user's expenses for better AI responses
      final expenseContext = _buildExpenseContext(userExpenses, languageCode);
      
      // Build conversation history context
      final conversationContext = _buildConversationContext(conversationHistory ?? [], languageCode);
      
      // Create the prompt with context and conversation history
      final prompt = _buildPrompt(expenseContext, conversationContext, message, languageCode);

      final response = await _makeGeminiRequest(prompt);
      return response ?? _getDefaultErrorMessage(languageCode);
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
  String _buildExpenseContext(List<Expense> expenses, [String? languageCode]) {
    if (expenses.isEmpty) {
      return languageCode == 'vi' ? 'Chưa có chi tiêu nào được ghi lại.' : 'No expenses recorded yet.';
    }

    final recentExpenses = expenses.take(10).toList();
    final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    
    final context = StringBuffer();
    if (languageCode == 'vi') {
      context.writeln('Tổng chi tiêu: \$${totalAmount.toStringAsFixed(2)}');
      context.writeln('Số lượng chi tiêu: ${expenses.length}');
      context.writeln('Chi tiêu gần đây:');
    } else {
      context.writeln('Total expenses: \$${totalAmount.toStringAsFixed(2)}');
      context.writeln('Number of expenses: ${expenses.length}');
      context.writeln('Recent expenses:');
    }
    
    for (final expense in recentExpenses) {
      context.writeln('- \$${expense.amount.toStringAsFixed(2)} for ${expense.item} (${expense.category})');
    }
    
    return context.toString();
  }

  /// Build conversation history context
  String _buildConversationContext(List<Map<String, String>> conversationHistory, [String? languageCode]) {
    if (conversationHistory.isEmpty) {
      return languageCode == 'vi' ? 'Đây là bắt đầu cuộc trò chuyện của chúng ta.' : 'This is the start of our conversation.';
    }

    final context = StringBuffer();
    context.writeln(languageCode == 'vi' ? 'Cuộc trò chuyện trước đó:' : 'Previous conversation:');
    
    // Show last 10 messages to keep context manageable
    final recentHistory = conversationHistory.take(10).toList();
    
    for (final message in recentHistory) {
      final role = message['role'] ?? 'unknown';
      final content = message['content'] ?? '';
      final prefix = role == 'user' 
          ? (languageCode == 'vi' ? 'Người dùng:' : 'User:')
          : (languageCode == 'vi' ? 'Trợ lý:' : 'Assistant:');
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

  /// Build language-specific prompt for AI
  String _buildPrompt(String expenseContext, String conversationContext, String message, String? languageCode) {
    if (languageCode == 'vi') {
      return '''
Bạn là một trợ lý AI hữu ích cho ứng dụng theo dõi chi tiêu gia đình. Vai trò của bạn là:
1. Giúp người dùng theo dõi và phân loại chi tiêu
2. Cung cấp thông tin chi tiết về các mô hình chi tiêu
3. Trả lời câu hỏi về dữ liệu tài chính của họ
4. Đề xuất cách tiết kiệm tiền
5. Nhớ và tham khảo các phần trước của cuộc trò chuyện

Bối cảnh chi tiêu hiện tại của người dùng:
$expenseContext

$conversationContext

Tin nhắn hiện tại của người dùng: $message

Vui lòng cung cấp phản hồi hữu ích và ngắn gọn bằng tiếng Việt. Nếu người dùng đề cập đến việc mua hàng hoặc chi tiêu, hãy xác nhận và đề nghị giúp phân loại. Tham khảo cuộc trò chuyện trước đó khi có liên quan.
''';
    } else {
      return '''
You are a helpful AI assistant for the Our Spends app. Your role is to:
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
    }
  }

  /// Get default error message based on language
  String _getDefaultErrorMessage(String? languageCode) {
    return languageCode == 'vi' 
        ? 'Xin lỗi, tôi không thể xử lý tin nhắn của bạn. Vui lòng thử lại.'
        : 'Sorry, I couldn\'t process your message. Please try again.';
  }
}