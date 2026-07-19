import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'matches_screen.dart';

class TempNewsScreen extends StatelessWidget { const TempNewsScreen({super.key}); @override Widget build(BuildContext context) { return const Scaffold(body: Center(child: Text("قسم الأخبار والملخصات قيد التطوير 🚀", style: TextStyle(color: Colors.white)))); } }
class TempMoreScreen extends StatelessWidget { const TempMoreScreen({super.key}); @override Widget build(BuildContext context) { return const Scaffold(body: Center(child: Text("قسم المزيد قيد التطوير 🚀", style: TextStyle(color: Colors.white)))); } }

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
    TempNewsScreen(),
    TempMoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NFSportsBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
