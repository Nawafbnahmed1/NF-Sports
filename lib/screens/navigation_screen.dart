import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'matches_screen.dart';
import 'results_screen.dart';
import 'news_screen.dart';
import 'more_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    MatchesScreen(),
    ResultsScreen(),
    NewsScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: _pages[_currentIndex],
    );
  }
}
