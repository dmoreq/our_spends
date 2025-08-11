import 'package:flutter/material.dart';
import '../theme/chat_theme.dart';

class ChatOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  
  const ChatOptionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ChatTheme.optionBorderRadius),
        child: Container(
          padding: ChatTheme.optionPadding,
          decoration: BoxDecoration(
            color: ChatTheme.optionBackground,
            borderRadius: BorderRadius.circular(ChatTheme.optionBorderRadius),
          ),
          child: Text(
            text,
            style: ChatTheme.optionTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}