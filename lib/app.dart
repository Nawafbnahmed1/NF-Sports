import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
 
class NFApp extends StatelessWidget {
  const NFApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NF Sports',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
