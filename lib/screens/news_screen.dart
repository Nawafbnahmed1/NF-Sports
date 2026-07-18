import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Image(
            image: AssetImage('assets/images/news_mockup.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
