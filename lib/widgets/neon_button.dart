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
        color: AppTheme.neonBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.neonBlue,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonBlue.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: AppTheme.neonBlue.withValues(alpha: 0.3),
          highlightColor: AppTheme.neonBlue.withValues(alpha: 0.1),
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
