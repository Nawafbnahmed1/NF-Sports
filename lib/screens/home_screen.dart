import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الهيدر الفخم الممتد بالصورة الرسمية والتدرج اللوني واسم التطبيق
              Container(
                height: 230,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/home_mockup.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF050B14).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: const Text(
                    "NF Sports",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // عنوان مباريات اليوم وكارد عرض المباراة بتوقيت 20:00
              sectionTitle("مباريات اليوم"),
              matchCard("Team 1", "Team 2", "20:00"),
              const SizedBox(height: 25),

              // قسم الأخبار
              sectionTitle("آخر الأخبار"),
              newsCard("أحدث أخبار كرة القدم العالمية"),
              const SizedBox(height: 25),

              // قسم اللقطات
              sectionTitle("أبرز اللقطات"),
              newsCard("ملخصات وأهداف المباريات"),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // دالة عنوان القسم
  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // دالة كارد المباراة المتوافقة مع كود المطور
  Widget matchCard(String team1, String team2, String time) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF101C2B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            "$team1 VS $team2",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(
            time,
            style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // دالة كارد الأخبار واللقطات
  Widget newsCard(String text) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF101C2B),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
