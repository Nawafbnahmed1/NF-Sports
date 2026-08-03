import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'matches_screen.dart';
import 'results_screen.dart';
import 'news_screen.dart';
import 'highlights_screen.dart';
import 'more_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), 
    const MatchesScreen(),
    const ResultsScreen(),
    const NewsScreen(),
    const HighlightsScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      HapticFeedback.selectionClick();
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBody: true, 
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              // 🟢 التعديل الأول: الخلفية الكحلية الغامضة الزجاجية
              color: const Color(0xFF0B162C).withOpacity(0.92),
              borderRadius: BorderRadius.circular(22),
              // 🟢 التعديل الثاني: الحواف المضيئة باللون الأزرق
              border: Border.all(
                color: const Color(0xFF00A3FF).withOpacity(0.4),
                width: 1.5,
              ),
              // 🟢 التعديل الثالث: توهج نجمي أزرق للحواف
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00A3FF).withOpacity(0.25),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(0xFF00A3FF).withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'الرئيسية'),
                _buildNavItem(1, Icons.sports_soccer_outlined, Icons.sports_soccer, 'المباريات'),
                _buildNavItem(2, Icons.analytics_outlined, Icons.analytics, 'النتائج'),
                _buildNavItem(3, Icons.newspaper_outlined, Icons.newspaper, 'الأخبار'),
                _buildNavItem(4, Icons.play_circle_outline, Icons.play_circle_filled, 'الملخصات'),
                _buildNavItem(5, Icons.more_horiz_outlined, Icons.more_horiz, 'المزيد'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌊 كبسولة الموجة السائلة المضيئة المتوهجة بالأزرق
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut, 
              width: isSelected ? 55 : 0,
              height: isSelected ? 38 : 0,
              decoration: BoxDecoration(
                // 🟢 الخلفية الزرقاء الشفافة المضيئة
                color: const Color(0xFF00A3FF).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: const Color(0xFF00A3FF).withOpacity(0.25), width: 1) : null,
              ),
            ),
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.05 : 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? selectedIcon : unselectedIcon,
                    // 🟢 أيقونة نيون زرقاء فخمة
                    color: isSelected ? const Color(0xFF00A3FF) : Colors.white38,
                    size: isSelected ? 22 : 20,
                    shadows: isSelected ? [
                      const Shadow(color: Color(0xFF00A3FF).withOpacity(0.6), blurRadius: 10)
                    ] : null,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white38,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'Cairo',
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
