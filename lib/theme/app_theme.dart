import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color surfaceColor = Color(0xFF151515);
  static const Color cardColor = Color(0xFF1E1E1E);

  static const Color neonBlue = Color(0xFF00B4FF);
  static const Color glowBlue = Color(0xFF00B4FF);
  static const Color black95 = Color(0xFF0A0A0A);
  static const Color black70 = Color(0xB3000000);

  static List<BoxShadow> neonGlow({double blur = 8}) {
    return [
      BoxShadow(
        color: neonBlue.withOpacity(0.2),
        blurRadius: blur,
        spreadRadius: 1,
      ),
    ];
  }

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: neonBlue,
    colorScheme: const ColorScheme.dark(
      primary: neonBlue,
      secondary: neonBlue,
      surface: surfaceColor,
    ),
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
