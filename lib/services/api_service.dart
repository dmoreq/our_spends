import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gemini_service.dart';
import '../models/expense.dart';

class ApiService {
  final GeminiService _geminiService = GeminiService();
  
  Future<Map<String, dynamic>> processMessage(String message, String userId, List<Expense> userExpenses, {List<Map<String, String>>? conversationHistory}) async {
    try {
      // Use Gemini AI to process the message with conversation history
      final aiResponse = await _geminiService.processMessage(message, userExpenses, conversationHistory: conversationHistory);
      
      // Try to extract expense information from the message
      final expenseInfo = await _geminiService.extractExpenseInfo(message);
      
      return {
        'status': 'success',
        'data': aiResponse,
        'type': 'text',
        'expense_info': expenseInfo,
      };
    } catch (e) {
      return {
        'status': 'error',
        'data': 'AI processing error: ${e.toString()}',
        'error_code': 'ai_error',
      };
    }
  }
  
  /// Generate spending insights using Gemini AI
  Future<Map<String, dynamic>> generateInsights(List<Expense> expenses) async {
    try {
      final insights = await _geminiService.generateSpendingInsights(expenses);
      
      return {
        'status': 'success',
        'data': insights,
        'type': 'insights',
      };
    } catch (e) {
      return {
        'status': 'error',
        'data': 'Failed to generate insights: ${e.toString()}',
        'error_code': 'insights_error',
      };
    }
  }
  
  // Keep the original method for backward compatibility (if needed)
  Future<Map<String, dynamic>> processMessageLegacy(String message, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-firebase-project.cloudfunctions.net/process_message'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'data': 'Server error: ${response.statusCode}',
          'error_code': 'server_error',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'data': 'Network error: ${e.toString()}',
        'error_code': 'network_error',
      };
    }
  }
}