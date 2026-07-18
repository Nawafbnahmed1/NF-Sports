import 'package:flutter/material.dart';
import 'matches_screen.dart';
import 'news_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Stack(
          children: [
            // خلفية الصورة الفخمة والأصلية للتصميم
            Positioned.fill(
              child: Image.asset(
                'assets/images/home_mockup.png',
                fit: BoxFit.cover,
              ),
            ),

            // 1️⃣ زر منطقة مباريات اليوم (مع تأثير انبثاق أزرق غامض)
            Positioned(
              top: 250,
              left: 20,
              right: 20,
              height: 260,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35), // الانبثاق الأزرق الغامض
                  highlightColor: const Color(0xFF00B4FF).withValues(alpha: 0.15), // توهج اللمس الخفيف
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MatchesScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 2️⃣ زر منطقة آخر الأخبار (مع تأثير انبثاق أزرق غامض)
            Positioned(
              top: 540,
              left: 20,
              right: 20,
              height: 210,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35), // الانبثاق الأزرق الغامض
                  highlightColor: const Color(0xFF00B4FF).withValues(alpha: 0.15), // توهج اللمس الخفيف
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NewsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
