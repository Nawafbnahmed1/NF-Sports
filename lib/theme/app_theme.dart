import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 درجات ألوان تصميمك الفخم بالملي عبر الأكواد
  static const Color backgroundColor = Color(0xFF050B14); // الخلفية الكحلية الداكنة
  static const Color surfaceColor = Color(0xFF0A1220);    // لون الكروت الزجاجية
  static const Color neonBlue = Color(0xFF00B4FF);        // النيون الأزرق المضيء بالشعار
  static const Color glowBlue = Color(0xFF1B5DFF);        // توهج النبضات الزرقاء

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: neonBlue,
      useMaterial3: true,
      fontFamily: 'Cairo', // خط عربي هندسي حاد للواجهات الرياضية
    );
  }
}
