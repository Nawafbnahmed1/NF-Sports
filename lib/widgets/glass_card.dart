import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ تصحيح: استخدام withOpacity بدلاً من withValues
        color: AppTheme.surfaceColor.withOpacity(0.75),
        borderRadius: BorderRadius.circular(borderRadius ?? 24),
        border: Border.all(
          // ✅ تصحيح: استخدام withOpacity بدلاً من withValues
          color: AppTheme.neonBlue.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonBlue.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
