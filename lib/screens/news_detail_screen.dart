import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'dart:ui' as ui;
import 'news_screen.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsArticleModel article;

  const NewsDetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _sparkController;
  late Animation<double> _sparkAnimation;
  double _readingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_updateReadingProgress);
    
    // متحكم الوميض الليزري لعنوان الخبر لـ NF SPORTS عند الدخول لشد انتباه القارئ
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _sparkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateReadingProgress);
    _scrollController.dispose();
    _sparkController.dispose();
    super.dispose();
  }

  // رياضيات صافية صفر كيلوبايت لحساب مؤشر القراءة الليزري الأفقي مع حركة الإصبع
  void _updateReadingProgress() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    setState(() {
      _readingProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    try {
      DateTime parsedDate = widget.article.publishedAt.toLocal();
      formattedDate = DateFormat('yyyy/MM/dd • hh:mm a').format(parsedDate);
    } catch (e) {
      formattedDate = 'منذ قليل';
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, // توحيد اللون الكحلي الفخم للتطبيق لمنع التشتت البصري
      body: Stack(
        children: [
          // 💎 أ. الـ CustomScrollView المركزي الذي يدمج المقال وسحب الأنيميشن الانسيابي
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController, // ربط مستشعر حركة الإصبع لمزامنة مؤشر القراءة
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 🎬 ب. الهيدر البارالاكس السينمائي الممتد والذوبان الكحلي الشفاف في الخلفية
                SliverAppBar(
                  expandedHeight: 320.0,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: AppTheme.backgroundColor,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: const Color(0xFF161926).withOpacity(0.8),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.neonBlue, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'news_image_${widget.article.articleUrl}',
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.article.imageUrl.isNotEmpty
                              ? Image.network(
                                  widget.article.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: const Color(0xFF1A1D2E));
                                  },
                                )
                              : Container(color: const Color(0xFF1A1D2E)),
                          // الذوبان الزجاجي المتدرج لإخفاء حواف الصورة ودمجها مع عشب الخلفية الداكنة بنعومة فائقة
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, AppTheme.backgroundColor],
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
                // 💎 ج. تفاصيل ومحتوى الخبر الإنسيابي الموحد بـ صفحة واحدة
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
                                color: AppTheme.neonBlue.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3), width: 1),
                              ),
                              child: Text(
                                widget.article.source,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.neonBlue,
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

                        // ⚡ الوميض البرقي السريع والأنيميشن اللحظي لعنوان الخبر عند الفتح لشد انتباه القارئ
                        AnimatedBuilder(
                          animation: _sparkAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _sparkAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, (1.0 - _sparkAnimation.value) * 8),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            widget.article.title,
                            textDirection: ui.TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.4,
                              shadows: [
                                Shadow(color: AppTheme.neonBlue.withOpacity(0.3), blurRadius: 15)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // 🎙️ كبسولة الاستماع وبودكاست الذبذبات الرقمية لـ NF SPORTS (أكواد صافية بوزن صفر كيلوبايت لإبهار المشجع)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0x0FFFFFFF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.neonBlue.withOpacity(0.15), width: 1),
                          ),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  const Icon(Icons.mic_external_on_rounded, color: AppTheme.neonBlue, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'الاستماع الذكي للخبر والتحليل اللحظي',
                                    style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // خطوط الذبذبات النيونية الصوتية النابضة برياضيات متناغمة لراحة العين
                              Row(
                                children: List.generate(4, (index) {
                                  return AnimatedBuilder(
                                    animation: _sparkAnimation,
                                    builder: (context, _) {
                                      final double sine = math.sin((_sparkAnimation.value * math.pi * 2) + (index * 0.5));
                                      final double heightValue = 4.0 + (sine.abs() * 14.0);
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                        width: 2.5,
                                        height: heightValue,
                                        decoration: BoxDecoration(
                                          color: index % 2 == 0 ? AppTheme.neonBlue : AppTheme.glowBlue,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.neonBlue.withOpacity(0.4), Colors.transparent],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 💎 د. حاوية متن نص الخبر والتحليلات الكروية الكاملة (قراءة زجاجية مريحة جداً لعين المشجع)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161926).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF1F2438).withOpacity(0.5), width: 1),
                          ),
                          child: Text(
                            widget.article.description.isEmpty
                                ? 'لا يوجد وصف متوفر لهذا الخبر.'
                                : widget.article.description,
                            textDirection: ui.TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFE2E8F0),
                              height: 1.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 🚀 زر "مشاركة المتعة الكروية" النيونية النابضة مع الأصدقاء بالاهتزاز اللمسي الذكي
                        InkWell(
                          onTap: () {
                            HapticFeedback.mediumImpact(); // اهتزاز تكتيكي ناعم يشعر المستخدم بقوة التفاعل
                            // هنا يستدعي لاحقاً حزمة share_plus لإطلاق لوحة النظام للمشاركة حياً بالسحاب
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0x1F00B4FF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.neonBlue.withOpacity(0.25)),
                              boxShadow: [
                                BoxShadow(color: AppTheme.neonBlue.withOpacity(0.08), blurRadius: 10)
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: ui.TextDirection.rtl,
                                children: [
                                  const Icon(Icons.share_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'شارك المتعة الكروية مع الأصدقاء الآن',
                                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // 🚨 هـ. شريط حقوق وتوقيع التطبيق الختامي الفخم لتوحيد هوية الأقسام بالكامل
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF707E94),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 🚨 و. مؤشر القراءة الليزري الأفقي العلوي (Cyber Reading Pulse) المتفاعل مع حركة الإصبع بالملي 
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 2.5,
              width: double.infinity,
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  width: MediaQuery.of(context).size.width * _readingProgress,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: AppTheme.neonBlue,
                    boxShadow: [
                      BoxShadow(color: AppTheme.neonBlue.withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
