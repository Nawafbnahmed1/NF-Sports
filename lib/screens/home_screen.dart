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
            Positioned.fill(
              child: Image.asset(
                'assets/images/home_mockup.png',
                fit: BoxFit.cover,
              ),
            ),

            // منطقة مباريات اليوم الشفافة والتفاعلية
            Positioned(
              top: 250,
              left: 20,
              right: 20,
              height: 260,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MatchesScreen(),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

            // منطقة آخر الأخبار الشفافة والتفاعلية
            Positioned(
              top: 540,
              left: 20,
              right: 20,
              height: 210,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewsScreen(),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
