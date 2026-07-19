import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  // 0 = الرئيسية، 1 = المباريات، 2 = النتائج، 3 = الأخبار، 4 = المزيد (المعلومات)
  int _currentSection = 0;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          // 🌟 1. عرض صورة التصميم الصحيحة بناءً على القسم النشط بملء الشاشة
          Positioned.fill(
            child: Builder(
              builder: (context) {
                if (_currentSection == 0) {
                  return Image.asset('assets/images/home_mockup.png', fit: BoxFit.fill);
                } else if (_currentSection == 1) {
                  return Image.asset('assets/images/matches_mockup.png', fit: BoxFit.fill);
                } else if (_currentSection == 2) {
                  return Image.asset('assets/images/results_mockup.png', fit: BoxFit.fill);
                } else if (_currentSection == 3) {
                  return Image.asset('assets/images/news_mockup.png', fit: BoxFit.fill);
                } else {
                  return Image.asset('assets/images/more_info_mockup.png', fit: BoxFit.fill);
                }
              },
            ),
          ),

          // 🌟 2. مناطق اللمس الحساسة الخاصة بالشاشة الرئيسية فقط (تظهر فقط في القسم 0)
          if (_currentSection == 0) ...[
            // زر مباريات اليوم
            Positioned(
              top: screenHeight * 0.28,
              left: 20,
              right: 20,
              height: screenHeight * 0.28,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35),
                  onTap: () {
                    setState(() {
                      _currentSection = 1; // الانتقال لقسم المباريات المقصوص
                    });
                  },
                ),
              ),
            ),
            // زر آخر الأخبار
            Positioned(
              top: screenHeight * 0.58,
              left: 20,
              right: 20,
              height: screenHeight * 0.20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35),
                  onTap: () {
                    setState(() {
                      _currentSection = 3; // الانتقال لقسم الأخبار المقصوص
                    });
                  },
                ),
              ),
            ),
          ],

          // 🌟 3. مناطق اللمس العلوية التبادلية (تظهر داخل قسم المباريات والنتائج 1 و 2)
          if (_currentSection == 1 || _currentSection == 2) ...[
            // تبويب المباريات العلوي الشفاف
            Positioned(
              top: screenHeight * 0.05,
              right: screenWidth * 0.05,
              width: screenWidth * 0.43,
              height: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35),
                  onTap: () {
                    setState(() {
                      _currentSection = 1; // التبديل لصورة المباريات الحية
                    });
                  },
                ),
              ),
            ),
            // تبويب النتائج العلوي الشفاف
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.05,
              width: screenWidth * 0.43,
              height: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35),
                  onTap: () {
                    setState(() {
                      _currentSection = 2; // التبديل لصورة النتائج المقصوصة
                    });
                  },
                ),
              ),
            ),
          ],

          // 🌟 4. شريط أزرار التنقل السفلي الشفاف والذكي فوق شريط صورتك الرئيسية الثابت بالملي
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.11,
            child: Row(
              children: [
                // زر الرئيسية
                Expanded(
                  child: InkWell(
                    splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                    onTap: () {
                      setState(() {
                        _currentSection = 0;
                      });
                    },
                  ),
                ),
                // زر المباريات
                Expanded(
                  child: InkWell(
                    splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                    onTap: () {
                      setState(() {
                        _currentSection = 1;
                      });
                    },
                  ),
                ),
                // زر الأخبار
                Expanded(
                  child: InkWell(
                    splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                    onTap: () {
                      setState(() {
                        _currentSection = 3;
                      });
                    },
                  ),
                ),
                // زر المزيد
                Expanded(
                  child: InkWell(
                    splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                    onTap: () {
                      setState(() {
                        _currentSection = 4;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
