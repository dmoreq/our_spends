class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, dynamic>? confirmationData;
  final bool isError;
  final bool isOption;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.confirmationData,
    this.isError = false,
    this.isOption = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      isUser: json['is_user'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      confirmationData: json['confirmation_data'],
      isError: json['is_error'] ?? false,
      isOption: json['is_option'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'confirmation_data': confirmationData,
      'is_error': isError,
      'is_option': isOption,
    };
  }

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    Map<String, dynamic>? confirmationData,
    bool? isError,
    bool? isOption,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      confirmationData: confirmationData ?? this.confirmationData,
      isError: isError ?? this.isError,
      isOption: isOption ?? this.isOption,
    );
  }
}