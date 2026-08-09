import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class FeaturedMatchCard extends StatelessWidget {
  final String leagueName;
  final String homeTeam;
  final String awayTeam;
  final String matchTime;
  final String status;

  const FeaturedMatchCard({
    super.key,
    required this.leagueName,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchTime,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                leagueName,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              _buildTeam(
                homeTeam,
                Icons.shield_rounded,
              ),

              Column(
                children: [
                  Text(
                    matchTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              _buildTeam(
                awayTeam,
                Icons.shield_outlined,
              ),

            ],
          ),

          const SizedBox(height: 18),

          Container(
            height: 1,
            color: AppColors.border,
          ),

          const SizedBox(height: 12),

          const Text(
            "تفاصيل المباراة",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTeam(String name, IconData icon) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 30,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
