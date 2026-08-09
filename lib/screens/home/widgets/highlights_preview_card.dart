import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class HighlightsPreviewCard extends StatelessWidget {
  final String title;
  final String duration;
  final String? thumbnailUrl;
  final VoidCallback? onTap;
 
  const HighlightsPreviewCard({
    super.key,
    required this.title,
    required this.duration,
    this.thumbnailUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [

          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      thumbnailUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.sports_soccer_rounded,
                      color: AppColors.primary,
                      size: 55,
                    ),
                  ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            right: 15,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Text(
                      duration,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(width: 6),

                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),

                  ],
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
