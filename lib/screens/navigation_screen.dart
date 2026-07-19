import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  // 0 = الرئيسية، 1 = المباريات، 2 = النتائج، 3 = الأخبار، 4 = اللقطات (المزيد)
  int _currentSection = 0;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Stack(
          children: [
            // 🌟 أولاً: عرض الصورة الصحيحة في المساحة العلوية بناءً على القسم النشط
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: screenHeight * 0.11, // ترك مساحة دقيقة متناسقة مع شريطك السفلي الأصلي
              child: Builder(
                builder: (context) {
                  if (_currentSection == 0) {
                    return Image.asset('assets/images/home_mockup.png', fit: BoxFit.fill);
                  } else if (_currentSection == 1) {
                    return Image.asset('assets/images/matches_mockup.png', fit: BoxFit.fill);
                  } else if (_currentSection == 2) {
                    return Image.asset('assets/images/results_mockup.jpeg', fit: BoxFit.fill);
                  } else if (_currentSection == 3) {
                    return Image.asset('assets/images/news_mockup.jpeg', fit: BoxFit.fill);
                  } else {
                    return Image.asset('assets/images/more_mockup.png', fit: BoxFit.fill);
                  }
                },
              ),
            ),

            // 🌟 ثانياً: الأزرار الشفافة التفاعلية الخاصة بالشاشة الرئيسية فقط (تظهر في القسم 0)
            if (_currentSection == 0) ...[
              // منطقة مباريات اليوم التفاعلية
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
                        _currentSection = 1; // الانتقال لقسم المباريات فوراً بدون شاشة جديدة
                      });
                    },
                  ),
                ),
              ),
              // منطقة آخر الأخبار التفاعلية
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
                        _currentSection = 3; // الانتقال لقسم الأخبار فوراً بدون شاشة جديدة
                      });
                    },
                  ),
                ),
              ),
            ],

            // 🌟 ثالثاً: الأزرار الشفافة التفاعلية الخاصة بقسم المباريات والنتائج (تظهر في الأقسام 1 و 2)
            if (_currentSection == 1 || _currentSection == 2) ...[
              // زر تبويب "المباريات" العلوي
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
                        _currentSection = 1; // التحول لصورة المباريات
                      });
                    },
                  ),
                ),
              ),
              // زر تبويب "النتائج" العلوي
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
                        _currentSection = 2; // التحول لصورة النتائج
                      });
                    },
                  ),
                ),
              ),
            ],

            // 🌟 رابعاً: شريط أزرار التنقل السفلي الشفاف والثابت طوال الوقت فوق صورتك الأصلية بالملي
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.11,
              child: Row(
                children: [
                  // 🏠 زر الرئيسية
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
                  // ⚽ زر المباريات
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
                  // 📰 زر الأخبار
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
                  // ⚙️ زر المزيد
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
      ),
    );
  }
}
