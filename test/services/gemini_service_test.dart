import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/services/gemini_service.dart';

void main() {
  group('GeminiService Tests', () {
    late GeminiService geminiService;

    setUp(() {
      geminiService = GeminiService();
    });

    // We can't directly test the private _detectExpenseManually method,
    // so we'll test the public extractExpenseInfo method instead.
    // However, since extractExpenseInfo makes API calls, we'll skip these tests
    // and focus on manual testing in the app.

    test('GeminiService initialization', () {
      // Just verify that the service can be instantiated
      expect(geminiService, isNotNull);
      expect(geminiService, isA<GeminiService>());
    });
  });
}