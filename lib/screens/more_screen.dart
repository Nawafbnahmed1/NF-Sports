import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Image(
            image: AssetImage('assets/images/highlights_mockup.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
