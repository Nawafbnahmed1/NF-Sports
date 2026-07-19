import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NF Sports',
      theme: AppTheme.darkTheme,
      home: const NavigationScreen(), // الانطلاق المباشر من شاشة الإدارة والشريط الموحد المتناسق
    );
  }
}
