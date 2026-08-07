import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NFSportsBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NFSportsBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: screenHeight * 0.10,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.95),
          border: const Border(
            top: BorderSide(color: Colors.white10, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonBlue.withOpacity(0.03),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.neonBlue,
          unselectedItemColor: Colors.white38,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo'),
          unselectedLabelStyle: const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_max_outlined),
              activeIcon: Icon(Icons.home, color: AppTheme.neonBlue),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer_outlined),
              activeIcon: Icon(Icons.sports_soccer, color: AppTheme.neonBlue),
              label: 'المباريات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics, color: AppTheme.neonBlue),
              label: 'النتائج',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_outlined),
              activeIcon: Icon(Icons.newspaper, color: AppTheme.neonBlue),
              label: 'الأخبار',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle_filled, color: AppTheme.neonBlue),
              label: 'الملخصات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined),
              activeIcon: Icon(Icons.more_horiz, color: AppTheme.neonBlue),
              label: 'المزيد',
            ),
          ],
        ),
      ),
    );
  }
}
