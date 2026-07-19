import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'matches_screen.dart';
import 'news_screen.dart'; // استدعاء شاشة الأخبار الحقيقية الجديدة

// شاشة مؤقتة للمزيد لكي لا يحدث خطأ برمي حتى نبرمجها تالياً
class TempMoreScreen extends StatelessWidget { const TempMoreScreen({super.key}); @override Widget build(BuildContext context) { return const Scaffold(body: Center(child: Text("قسم المزيد والمطور قيد التطوير 🚀", style: TextStyle(color: Colors.white)))); } }

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  // القائمة الرسمية التي تربط الشاشات الحقيقية الفخمة بالأكواد
  final List<Widget> _pages = const [
    HomeScreen(),
    MatchesScreen(),
    NewsScreen(), // ربط شاشة الأخبار والملخصات الكبيرة والصغيرة رسمياً هنا
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
