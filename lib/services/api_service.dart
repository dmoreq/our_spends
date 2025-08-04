import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // This would be your Firebase Functions endpoint
  // For now, we'll use a placeholder URL
  static const String _baseUrl = 'https://your-firebase-project.cloudfunctions.net';
  
  Future<Map<String, dynamic>> processMessage(String message, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/process_message'),
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