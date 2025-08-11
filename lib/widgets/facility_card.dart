import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/chat_theme.dart';

class FacilityCard extends StatelessWidget {
  final String title;
  final String distance;
  final String price;
  final List<FacilityType> facilityTypes;
  final VoidCallback onTap;
  
  const FacilityCard({
    super.key,
    required this.title,
    required this.distance,
    required this.price,
    required this.facilityTypes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        padding: ChatTheme.cardPadding,
        decoration: BoxDecoration(
          color: ChatTheme.cardBackground,
          borderRadius: BorderRadius.circular(ChatTheme.cardBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: ChatTheme.cardTitleStyle,
            ),
            const SizedBox(height: 12),
            
            // Info row
            Row(
              children: [
                // Distance
                Text(
                  distance,
                  style: ChatTheme.cardSubtitleStyle,
                ),
                const SizedBox(width: 8),
                
                // Separator dot
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: ChatTheme.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                
                // Price
                Text(
                  price,
                  style: ChatTheme.cardSubtitleStyle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Facility types
            Row(
              children: facilityTypes.map((type) => _buildFacilityTypeChip(type)).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFacilityTypeChip(FacilityType type) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            type.iconAsset,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(ChatTheme.primaryColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            type.name,
            style: const TextStyle(
              fontSize: 14,
              color: ChatTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class FacilityType {
  final String name;
  final String iconAsset;
  
  const FacilityType({
    required this.name,
    required this.iconAsset,
  });
  
  static const FacilityType gym = FacilityType(
    name: 'Gym',
    iconAsset: 'assets/images/dumbbell_icon.svg',
  );
  
  static const FacilityType spa = FacilityType(
    name: 'SPA',
    iconAsset: 'assets/images/spa_icon.svg',
  );
  
  static const FacilityType pool = FacilityType(
    name: 'Pool',
    iconAsset: 'assets/images/pool_icon.svg',
  );
}