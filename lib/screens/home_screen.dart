import 'package:flutter/material.dart';
import 'matches_screen.dart';
import 'news_screen.dart';
import 'more_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/home_mockup.png',
                fit: BoxFit.fill,
              ),
            ),
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
                  highlightColor: const Color(0xFF00B4FF).withValues(alpha: 0.15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MatchesScreen()),
                    );
                  },
                ),
              ),
            ),
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
                  highlightColor: const Color(0xFF00B4FF).withValues(alpha: 0.15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewsScreen()),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.10,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MatchesScreen()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NewsScreen()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.25),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MoreScreen()),
                        );
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
