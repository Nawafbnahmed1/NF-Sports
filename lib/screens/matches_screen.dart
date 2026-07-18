import 'package:flutter/material.dart';
import 'results_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  bool showResults = false;

  @override
  Widget build(BuildContext context) {
    return showResults
        ? const ResultsScreen()
        : Scaffold(
            backgroundColor: const Color(0xFF050B14),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/matches_mockup.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showResults = true;
                            });
                          },
                          child: const Text("عرض النتائج"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
