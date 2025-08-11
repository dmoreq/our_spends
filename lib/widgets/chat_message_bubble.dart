import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat_message.dart';
import '../theme/chat_theme.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  
  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[  
            // Bot avatar
            _buildBotAvatar(),
            const SizedBox(width: 8),
          ],
          
          // Message bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Timestamp for bot messages
                if (!isUser) ...[  
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text(
                      _formatTimestamp(message.timestamp),
                      style: ChatTheme.timestampStyle,
                    ),
                  ),
                ],
                
                // Message bubble
                Container(
                  padding: ChatTheme.messagePadding,
                  decoration: BoxDecoration(
                    color: isUser 
                        ? ChatTheme.userBubbleColor 
                        : (message.isError ? Colors.red[100] : ChatTheme.botBubbleColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUser ? ChatTheme.messageBorderRadius : 0),
                      topRight: Radius.circular(isUser ? 0 : ChatTheme.messageBorderRadius),
                      bottomLeft: const Radius.circular(ChatTheme.messageBorderRadius),
                      bottomRight: const Radius.circular(ChatTheme.messageBorderRadius),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: isUser 
                        ? ChatTheme.userMessageTextStyle 
                        : (message.isError 
                            ? ChatTheme.messageTextStyle.copyWith(color: Colors.red[900]) 
                            : ChatTheme.messageTextStyle),
                  ),
                ),
              ],
            ),
          ),
          
          if (isUser) ...[  
            // User avatar
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildBotAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: ChatTheme.botAvatarBackground,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/bot_icon.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    String formattedTime = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    
    if (messageDate == today) {
      return 'Today $formattedTime';
    } else if (messageDate == yesterday) {
      return 'Yesterday $formattedTime';
    } else {
      return '${timestamp.day}/${timestamp.month} $formattedTime';
    }
  }
}