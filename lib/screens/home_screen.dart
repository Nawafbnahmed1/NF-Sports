import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // زيادة الارتفاع ليعطي هيبة وفخامة أكبر
        child: Container(
          decoration: const BoxDecoration(
            // تأثير التدرج اللوني الرياضي الفخم المتناسق تماماً مع صورتك
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF07111F),         // ... الكحلي الغامق الأساسي للتطبيق
                Color(0xFF0A1628),         // درجة كحلية مدمجة
                Color(0xFF0F223C),         // درجة زجاجية عميقة لتندمج مع بداية الشاشة
              ],
            ),
            // إطار سفلي نحيف جداً بتأثير توهج نيون أزرق خفيف لفصل الشريط بأناقة
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF00B4FF),
                width: 0.8,
              ),
            ),
          ),
          child: AppBar(
            title: Text(
              "NF SPORTS",
              style: TextStyle(
                fontWeight: FontWeight.w900, // خط عريض وقوي جداً للمظهر الرياضي
                fontSize: 25,
                letterSpacing: 2.5,          // مسافات احترافية فخمة بين الحروف
                color: Colors.white,
                // تأثير توهج النيون المزدوج ليعطي الاسم هيبة ومؤثراً بصرياً عميقاً
                shadows: [
                  Shadow(
                    blurRadius: 12.0,
                    color: const Color(0xFF00B4FF).withOpacity(0.8),
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    blurRadius: 4.0,
                    color: const Color(0xFF0055FF).withOpacity(0.5),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent, // جعل الخلفية شفافة ليعمل التدرج الخلفي الذكي
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/home_mockup.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
