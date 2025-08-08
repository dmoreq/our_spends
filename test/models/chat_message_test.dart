import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/chat_message.dart';

void main() {
  group('ChatMessage Model Tests', () {
    test('should create a ChatMessage instance with required parameters', () {
      final timestamp = DateTime(2023, 5, 15, 10, 30);
      final message = ChatMessage(
        text: 'Hello, how can I help you?',
        isUser: false,
        timestamp: timestamp,
      );

      expect(message.text, 'Hello, how can I help you?');
      expect(message.isUser, false);
      expect(message.timestamp, timestamp);
    });

    test('should create a user message', () {
      final timestamp = DateTime(2023, 5, 15, 10, 30);
      final message = ChatMessage(
        text: 'I spent \$50 on lunch today',
        isUser: true,
        timestamp: timestamp,
      );

      expect(message.text, 'I spent \$50 on lunch today');
      expect(message.isUser, true);
      expect(message.timestamp, timestamp);
    });

    test('should handle empty message text', () {
      final timestamp = DateTime(2023, 5, 15, 10, 30);
      final message = ChatMessage(
        text: '',
        isUser: true,
        timestamp: timestamp,
      );

      expect(message.text, '');
      expect(message.isUser, true);
      expect(message.timestamp, timestamp);
    });

    test('should handle long message text', () {
      final timestamp = DateTime(2023, 5, 15, 10, 30);
      final longText = 'A' * 1000; // 1000 character string
      final message = ChatMessage(
        text: longText,
        isUser: false,
        timestamp: timestamp,
      );

      expect(message.text, longText);
      expect(message.text.length, 1000);
      expect(message.isUser, false);
      expect(message.timestamp, timestamp);
    });
  });

  test('should convert ChatMessage to JSON', () {
    final timestamp = DateTime(2023, 5, 15, 10, 30);
    final message = ChatMessage(
      text: 'Hello, how can I help you?',
      isUser: false,
      timestamp: timestamp,
    );

    final json = message.toJson();

    expect(json['text'], 'Hello, how can I help you?');
    expect(json['is_user'], false);
    expect(json['timestamp'], '2023-05-15T10:30:00.000');
  });

  test('should create a ChatMessage from JSON', () {
    final json = {
      'text': 'Hello, how can I help you?',
      'is_user': false,
      'timestamp': '2023-05-15T10:30:00.000',
    };

    final message = ChatMessage.fromJson(json);

    expect(message.text, 'Hello, how can I help you?');
    expect(message.isUser, false);
    expect(message.timestamp, DateTime(2023, 5, 15, 10, 30));
  });

  test('should create a copy with updated fields using copyWith', () {
    final timestamp = DateTime(2023, 5, 15, 10, 30);
    final message = ChatMessage(
      text: 'Hello, how can I help you?',
      isUser: false,
      timestamp: timestamp,
    );

    final updatedMessage = message.copyWith(
      text: 'Updated message',
      isUser: true,
    );

    // Check that specified fields were updated
    expect(updatedMessage.text, 'Updated message');
    expect(updatedMessage.isUser, true);

    // Check that other fields remain the same
    expect(updatedMessage.timestamp, timestamp);
  });
}