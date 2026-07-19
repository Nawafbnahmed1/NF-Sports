import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          // 🌟 شريط النيون العمودي المضيء والمتوهج بجانب العنوان (نفس تصميمك)
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.neonBlue,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonBlue.withValues(alpha: 0.6),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // العنوان الفخم بالخط العريض
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
