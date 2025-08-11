import 'package:flutter/material.dart';

class ChatTheme {
  // Colors from Figma design
  static const Color primaryColor = Color(0xFF6C5CE7); // Purple color for primary elements
  static const Color backgroundColor = Color(0xFFF9F9F9); // Light background
  static const Color surfaceColor = Colors.white; // White surface
  static const Color botBubbleColor = Color(0xFFF1F1F1); // Light gray for bot messages
  static const Color userBubbleColor = Color(0xFF6C5CE7); // Purple for user messages
  static const Color textPrimary = Color(0xFF2D3436); // Dark text
  static const Color textSecondary = Color(0xFF636E72); // Secondary text
  static const Color botAvatarBackground = Color(0xFF6C5CE7); // Purple for bot avatar
  static const Color activeIndicator = Color(0xFF00B894); // Green for active indicator
  static const Color cardBackground = Color(0xFFFFFFFF); // White for cards
  static const Color optionBackground = Color(0xFF6C5CE7); // Purple for option buttons
  static const Color optionText = Color(0xFFFFFFFF); // White text for options
  
  // Border radius values
  static const double messageBorderRadius = 24.0;
  static const double optionBorderRadius = 24.0;
  static const double cardBorderRadius = 24.0;
  static const double inputBorderRadius = 24.0;
  
  // Padding values
  static const EdgeInsets messagePadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets optionPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  
  // Text styles
  static const TextStyle botNameStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle activeStatusStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  static const TextStyle messageTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );
  
  static const TextStyle userMessageTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  
  static const TextStyle timestampStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  static const TextStyle optionTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle cardSubtitleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
  
  // Input decoration
  static InputDecoration chatInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'Type a message...',
      hintStyle: const TextStyle(color: textSecondary),
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide.none,
      ),
    );
  }
}