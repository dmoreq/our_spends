import 'package:flutter/material.dart';
import '../theme/chat_theme.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isProcessing;
  final String hintText;
  
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isProcessing = false,
    this.hintText = 'Type a message...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ChatTheme.botBubbleColor,
                borderRadius: BorderRadius.circular(ChatTheme.inputBorderRadius),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: ChatTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                enabled: !isProcessing,
                style: const TextStyle(color: ChatTheme.textPrimary),
              ),
            ),
          ),
          
          // Send button
          const SizedBox(width: 8.0),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: ChatTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: isProcessing ? null : onSend,
              icon: isProcessing 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}