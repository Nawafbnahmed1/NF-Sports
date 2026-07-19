import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/highlights_mockup.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
