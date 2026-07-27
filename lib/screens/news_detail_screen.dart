import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'news_screen.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticleModel article;

  const NewsDetailScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    // تنسيق التاريخ
    String formattedDate = '';
    try {
      DateTime parsedDate = article.publishedAt.toLocal();
      formattedDate = DateFormat('yyyy/MM/dd • hh:mm a').format(parsedDate);
    } catch (e) {
      formattedDate = 'منذ قليل';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0E15), // خلفية داكنة فخمة
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // الهيدر السينمائي المضيء مع زر الرجوع
          SliverAppBar(
            expandedHeight: 320.0,
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: const Color(0xFF0D0E15),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: const Color(0xFF161926).withOpacity(0.8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00FFCC), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'news_image_${article.articleUrl}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    article.imageUrl.isNotEmpty
                        ? Image.network(
                            article.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: const Color(0xFF1A1D2E));
                            },
                          )
                        : Container(color: const Color(0xFF1A1D2E)),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0xFF0D0E15)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // تفاصيل ومحتوى الخبر
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00FFCC).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00FFCC).withOpacity(0.3), width: 1),
                        ),
                        child: Text(
                          article.source,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00FFCC),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, color: Color(0xFF707E94), size: 14),
                          const SizedBox(width: 5),
                          Text(
                            formattedDate,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: const Color(0xFF707E94),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    article.title,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF00FFCC).withOpacity(0.4), Colors.transparent],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161926).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1F2438), width: 1),
                    ),
                    child: Text(
                      article.description.isEmpty
                          ? 'لا يوجد وصف متوفر لهذا الخبر.'
                          : article.description,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE2E8F0),
                        height: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // شريط حقوق وتوقيع التطبيق
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          width: 60,
                          color: const Color(0xFF1F2438),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "NF Sports © 2026",
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF707E94),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
