import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          // عرض صورة تصميم النتائج المقصوصة في المساحة العلوية
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: screenHeight * 0.11,
            child: Image.asset(
              'assets/images/results_mockup.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
