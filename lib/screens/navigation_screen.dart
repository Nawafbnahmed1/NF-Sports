import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'matches_screen.dart';
import 'news_screen.dart';
import 'results_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  // 🌟 طهرنا المصفوفة تماماً ومسحنا كلمة const من أمام HomeScreen لتشتغل السحبة الأفقية بدون تعارض
  final List<Widget> _screens = [
    HomeScreen(), 
    const MatchesScreen(),
    const NewsScreen(),
    const ResultsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white10, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: const Color(0xFF0A1220),
            selectedItemColor: AppTheme.neonBlue,
            unselectedItemColor: Colors.white38,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo'),
            unselectedLabelStyle: const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home, shadows: [Shadow(color: AppTheme.neonBlue, blurRadius: 10)]), label: 'الرئيسية'),
              BottomNavigationBarItem(icon: Icon(Icons.sports_soccer_outlined), activeIcon: Icon(Icons.sports_soccer, shadows: [Shadow(color: AppTheme.neonBlue, blurRadius: 10)]), label: 'المباريات'),
              BottomNavigationBarItem(icon: Icon(Icons.newspaper_outlined), activeIcon: Icon(Icons.newspaper, shadows: [Shadow(color: AppTheme.neonBlue, blurRadius: 10)]), label: 'الأخبار'),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz_outlined), activeIcon: Icon(Icons.more_horiz, shadows: [Shadow(color: AppTheme.neonBlue, blurRadius: 10)]), label: 'المزيد'),
            ],
          ),
        ),
      ),
    );
  }
}
