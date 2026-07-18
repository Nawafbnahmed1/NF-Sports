import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Image(
            image: AssetImage('assets/images/results_mockup.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
