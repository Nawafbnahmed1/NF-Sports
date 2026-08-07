import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ✅ تصحيح: استبدال withValues بـ withOpacity
        color: AppTheme.neonBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.neonBlue,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            // ✅ تصحيح: استبدال withValues بـ withOpacity
            color: AppTheme.neonBlue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          // ✅ تصحيح: استبدال withValues بـ withOpacity
          splashColor: AppTheme.neonBlue.withOpacity(0.3),
          // ✅ تصحيح: استبدال withValues بـ withOpacity
          highlightColor: AppTheme.neonBlue.withOpacity(0.1),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppTheme.neonBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
