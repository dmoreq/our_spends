import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/chat_theme.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;
  final String botName;
  final String statusText;
  
  const ChatAppBar({
    super.key,
    required this.onBackPressed,
    required this.onMenuPressed,
    this.botName = 'FitBot',
    this.statusText = 'Always active',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            _buildIconButton(
              onPressed: onBackPressed,
              svgAsset: 'assets/images/left_arrow.svg',
            ),
            
            const SizedBox(width: 12),
            
            // Bot avatar and info
            Row(
              children: [
                // Bot avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: ChatTheme.botAvatarBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/bot_icon.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Bot name and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bot name
                    Text(
                      botName,
                      style: ChatTheme.botNameStyle,
                    ),
                    
                    // Status indicator
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: ChatTheme.activeIndicator,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: ChatTheme.activeStatusStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const Spacer(),
            
            // Menu button
            _buildIconButton(
              onPressed: onMenuPressed,
              svgAsset: 'assets/images/menu_icon.svg',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIconButton({required VoidCallback onPressed, required String svgAsset}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          svgAsset,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(Colors.grey.shade800, BlendMode.srcIn),
        ),
        padding: EdgeInsets.zero,
        iconSize: 20,
        splashRadius: 20,
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}