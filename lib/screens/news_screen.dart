import 'package:flutter/material.dart';
import 'more_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          // 1. عرض صورة تصميم الأخبار المقصوصة في المساحة العلوية
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: screenHeight * 0.11,
            child: Image.asset(
              'assets/images/news_mockup.png',
              fit: BoxFit.fill,
            ),
          ),

          // 2. زر تفاعلي شفاف فوق تبويب "الملخصات" العلوي لفتح صفحة اللقطات والملخصات
          Positioned(
            top: screenHeight * 0.05,
            right: 20, // ضبط الاتجاه ليكون فوق زر الملخصات في تصميمك
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
                    MaterialPageRoute(builder: (_) => const MoreScreen()),
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
