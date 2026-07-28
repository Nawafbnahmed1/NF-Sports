import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _NavigationScreenState extends State<NavigationScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // 🌟 طهرنا المصفوفة ومسحنا كلمة const من أمام HomeScreen لتشتغل السحبة الأفقية بدون أي تعارض
  final List<Widget> _screens = [
    const HomeScreen(), 
    const MatchesScreen(),
    const NewsScreen(),
    const ResultsScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      HapticFeedback.selectionClick(); // اهتزاز تكتيكي فخم فائق الخفة عند الانتقال
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // تفعيل وضعية تمدد الشاشات خلف البار العائم ليعطي عمق زجاجي أسطوري
      extendBody: true, 
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0), // رفع البار برمجياً ليصبح عائماً بشكل رائع
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              // مظهر زجاجي شفاف كالكريستال الفخم يعكس محتوى التطبيق من خلفه
              color: AppTheme.surfaceColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(22),
              // إطار نيون رفيع ومشع يدمج لونك الرسمي مع التوهج لمنحه مظهر ثلاثي الأبعاد
              border: Border.all(
                color: AppTheme.neonBlue.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.glowBlue.withOpacity(0.12),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'الرئيسية'),
                _buildNavItem(1, Icons.sports_soccer_outlined, Icons.sports_soccer, 'المباريات'),
                _buildNavItem(2, Icons.newspaper_outlined, Icons.newspaper, 'الأخبار'),
                _buildNavItem(3, Icons.more_horiz_outlined, Icons.more_horiz, 'المزيد'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🛠️ دالة هندسية ذكية لبناء الأيقونات التفاعلية مع تأثير كبسولة الموجة السائلة المنزلقة
  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌊 كبسولة الموجة السائلة المضيئة: تتحرك وتستقر خلف الأيقونة النشطة بنعومة فائقة
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCommom,
              width: isSelected ? 55 : 0,
              height: isSelected ? 38 : 0,
              decoration: BoxDecoration(
                color: AppTheme.neonBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: AppTheme.neonBlue.withOpacity(0.2), width: 1) : null,
              ),
            ),
            
            // محتوى الزر (الأيقونة والنص) مع تأثير التكبير واللمعان الانسيابي
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.05 : 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? selectedIcon : unselectedIcon,
                    color: isSelected ? AppTheme.neonBlue : Colors.white38,
                    size: isSelected ? 22 : 20,
                    shadows: isSelected ? [
                      Shadow(color: AppTheme.neonBlue.withOpacity(0.6), blurRadius: 10)
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
