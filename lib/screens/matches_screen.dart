import 'package:flutter/material.dart';
import 'results_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/matches_mockup.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: 20,
            width: screenWidth * 0.43,
            height: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                splashColor: const Color(0xFF1B5DFF).withValues(alpha: 0.35),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultsScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
