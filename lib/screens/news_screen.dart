import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/no_internet_widget.dart';
import 'news_detail_screen.dart';

class NewsArticleModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String articleUrl;
  final DateTime publishedAt;

  const NewsArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.articleUrl,
    required this.publishedAt,
  });

  factory NewsArticleModel.fromMap(Map<String, dynamic> map) {
    return NewsArticleModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title_ar'] ?? map['title'] ?? '').toString(),
      description: (map['description_ar'] ?? map['description'] ?? 'اضغط على تفاصيل الخبر لقراءة المقال كاملاً من المصدر.').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      source: (map['source'] ?? 'NF Sports').toString(),
      articleUrl: (map['article_url'] ?? '').toString(),
      publishedAt: DateTime.parse(map['published_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late AnimationController _pulseController;
  late AnimationController _marqueeController;
  final Set<String> _readArticlesMemory = <String>{};
  
  // مصفوفات لإدارة وتثبيت الذاكرة الحية لمستشعر التمويه التفاعلي الذكي للأرقام العشوائية المتنفسة
  final Map<String, int> _baseViewsMap = {};
  final Map<String, int> _timeOffsetMap = {};
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  // 📡 محرك التمويه التفاعلي الذكي: حساب مشاهدات عشوائية متباينة تبدأ فوق الـ 200 وتنمو عشوائياً كل 2-6 دقائق
  String _generateStealthViews(NewsArticleModel article) {
    final String key = article.id.isNotEmpty ? article.id : article.articleUrl;
    
    // 1️⃣ الطبقة الأولى: تحديد رقم البداية العشوائي الفريد لكل خبر فوق الـ 200 مشاهدة
    if (!_baseViewsMap.containsKey(key)) {
      final int seed = key.hashCode.abs();
      _baseViewsMap[key] = 200 + (seed % 190); // خيارات لامتناهية تبدأ من 200 إلى 390 مشاهدة أولية
      _timeOffsetMap[key] = 2 + (seed % 5);    // توزيع تفاوت أوقات التحديث عشوائياً (كل 2 أو 3 أو 4 أو 5 أو 6 دقائق)
    }

    final int baseViews = _baseViewsMap[key]!;
    final int minutesInterval = _timeOffsetMap[key]!;
    
    // 2️⃣ الطبقة الثانية: حساب الوقت المنقضي منذ نشر الخبر وتوليد قفزات نمو عشوائية فوق الـ 100 مشاهدة
    final duration = DateTime.now().difference(article.publishedAt);
    final int passedIntervals = duration.inMinutes ~/ minutesInterval;
    
    int growth = 0;
    if (passedIntervals > 0) {
      final int cryptoSeed = key.hashCode.abs() + passedIntervals;
      // قفزة نمو عشوائية تماماً ومستقلة لكل خبر تتراوح بين 100 إلى 220 مشاهدة إضافية لكل نبضة وقت
      final int stepValue = 100 + (cryptoSeed % 120); 
      growth = passedIntervals * stepValue;
    }

    final int totalViews = baseViews + growth;

    if (totalViews >= 1000) {
      return '${(totalViews / 1000).toStringAsFixed(1)}K';
    }
    return '$totalViews';
  }

  String _getFormatedTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) return 'الآن';
    if (duration.inMinutes < 60) return 'منذ ${duration.inMinutes} د';
    if (duration.inHours < 24) return 'قبل ${duration.inHours} ساعة';
    return 'قبل ${duration.inDays} يوم';
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: StreamBuilder(
          // 🔮 بث السحاب اللحظي المفتوح: استماع حي وتلقائي لجدول الأخبار المستقل ليتحدث التطبيق في الأجزاء من الثانية وبوزن صفر كيلوبايت
          stream: supabase.from('news').stream(primaryKey: ['id']).order('published_at', ascending: false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF00FF66)));
            }
            if (snapshot.hasError) {
              return const Center(child: Text("تعذر جلب البيانات الحالية", style: TextStyle(color: Colors.white24, fontFamily: 'Cairo')));
            }
            
            final List<dynamic> rawData = snapshot.data ?? [];
            final List<NewsArticleModel> articles = rawData.map((e) => NewsArticleModel.fromMap(e as Map<String, dynamic>)).toList();

            if (articles.isEmpty) {
              return const Center(child: Text("لا توجد أخبار طازجة حالياً", style: TextStyle(color: Colors.white38, fontFamily: 'Cairo')));
            }

            return RefreshIndicator(
              color: const Color(0xFF00FF66),
              backgroundColor: const Color(0xFF0A1220),
              strokeWidth: 3,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // ⭕ شريط دوائر الستوري الأفقية اللانهائية الممتدة لتبث التفاعل المرئي اللامحدود لآلاف الأخبار
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          itemCount: articles.length, // تم إلغاء الحصار القديم لـ 8 دوائر لتصبح قائمة ممتدة لانهائية
                          itemBuilder: (context, i) {
                            final bool isRead = _readArticlesMemory.contains(articles[i].articleUrl);

                            return GestureDetector(
                              onTap: () {
                                setState(() => _readArticlesMemory.add(articles[i].articleUrl));
                                HapticFeedback.mediumImpact();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: articles[i])));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 14),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // حواف نيونية مشعة باللون الأخضر المضيء المعتمد
                                        border: Border.all(color: isRead ? Colors.white24 : const Color(0xFF00FF66), width: 2),
                                        boxShadow: !isRead ? [BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.3), blurRadius: 6)] : null,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: articles[i].imageUrl.isNotEmpty
                                            ? Image.network(articles[i].imageUrl, fit: BoxFit.cover)
                                            : Container(color: AppTheme.surfaceColor, child: const Icon(Icons.flash_on, color: Color(0xFF00FF66))),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.visibility, size: 10, color: isRead ? Colors.white24 : const Color(0xFF00FF66).withOpacity(0.7)),
                                        const SizedBox(width: 2),
                                        Text(
                                          _generateStealthViews(articles[i]), // ربط فوري بمحرك التمويه التفاعلي اللامتناهي
                                          style: TextStyle(color: isRead ? Colors.white24 : Colors.white60, fontSize: 9.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // 🛸 مستطيل الإعلانات الخرافي المذهللللل والمتحرك سحابياً بالكامل (Zero-GitHub Deployment)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          // مظهر أزرق زجاجي فاخر مشع (Glassmorphism Midnight)
                          color: AppTheme.surfaceColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                          // حواف نيونية مشعة باللون الأخضر المضيء المعتمد لتوحيد الواجهات السداسية
                          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.3), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF66).withOpacity(0.12),
                              blurRadius: 10,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedBuilder(
                            animation: _marqueeController,
                            builder: (context, child) {
                              return FractionalTranslation(
                                // تحريك النص وانسيابه أفقياً بنعومة فائقة من جهة إلى جهة كشاشات البث العالمية
                                translation: Offset(-1.0 + (_marqueeController.value * 2.0), 0.0),
                                child: Center(
                                  child: Text(
                                    '⚡ NF SPORTS NEWS ⚡',
                                    maxLines: 1,
                                    whiteSpace: WhiteSpace.noWrap,
                                    style: GoogleFonts.cairo(
                                      color: const Color(0xFF00FF66),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(color: const Color(0xFF00FF66).withOpacity(0.6), blurRadius: 8)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // 🚨 ترويسة العنوان الرئيسي المضيء لقسم الأخبار الصافي
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0x1A00FF66),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.2), width: 1),
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            FadeTransition(
                              opacity: _pulseController,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 8, spreadRadius: 2)],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'آخر الأخبار الرياضية',
                              style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                            ),
                            const Spacer(),
                            const Text("LIVE", style: TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return index == 0
                            ? _buildMainArticleCard(context, article)
                            : _buildSubArticleCard(context, article);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🎬 تشييد كرت الخبر الرئيسي والسينمائي الكبير بالألوان النيونية الخضراء والألواح الزجاجية
  Widget _buildMainArticleCard(BuildContext context, NewsArticleModel article) {
    final bool isRead = _readArticlesMemory.contains(article.articleUrl);
    
    final bool isHotMatch = RegExp(
      r'classico|derby|real madrid|barcelona|final|urgent|كلاسيكو|ديربي|ريال مدريد|برشلونة|نهائي|عاجل', 
      caseSensitive: false
    ).hasMatch(article.title);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isRead ? 0.7 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: !isRead ? [BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.12), blurRadius: 16)] : null,
          ),
          child: GlassCard(
            padding: EdgeInsets.zero,
            borderRadius: 24,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 155,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: article.imageUrl.isNotEmpty
                            ? Image.network(article.imageUrl, fit: BoxFit.cover)
                            : Container(color: Colors.black26, child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 48))),
                      ),
                    ),
                    // 🏷️ نظام وسم الحقوق التلقائي والمحمي السينمائي لـ NF SPORTS على غلاف غلاف الكرت
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black60,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.2)),
                        ),
                        child: const Text(
                          "NF SPORTS",
                          style: TextStyle(color: Color(0xFF00FF66), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            if (isHotMatch && !isRead)
                              FadeTransition(
                                opacity: _pulseController,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.local_fire_department, color: Colors.redAccent, size: 18),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                article.title,
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isRead ? Colors.white38 : Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.white10 : const Color(0x1A00FF66),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isRead ? Colors.white24 : const Color(0xFF00FF66), width: 1.5),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() => _readArticlesMemory.add(article.articleUrl));
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: const Center(
                                child: Text('اقرأ المزيد', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ),
                            ),
                          ),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(Icons.flash_on, color: Colors.amber, size: 13),
                              const SizedBox(width: 4),
                              Text(
                                _getFormatedTimeAgo(article.publishedAt),
                                style: TextStyle(color: isRead ? Colors.white24 : Colors.white60, fontSize: 10.5, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // 📰 تشييد كروت الأخبار الفرعية والمنتظمة بالألوان النيونية الخضراء والألواح الزجاجية
  Widget _buildSubArticleCard(BuildContext context, NewsArticleModel article) {
    final bool isRead = _readArticlesMemory.contains(article.articleUrl);
    
    final bool isHotMatch = RegExp(
      r'classico|derby|real madrid|barcelona|final|urgent|كلاسيكو|ديربي|ريال مدريد|برشلونة|نهائي|عاجل', 
      caseSensitive: false
    ).hasMatch(article.title);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isRead ? 0.75 : 1.0,
        child: GlassCard(
          padding: const EdgeInsets.all(11),
          borderRadius: 20,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Stack(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: article.imageUrl.isNotEmpty
                          ? Image.network(article.imageUrl, fit: BoxFit.cover)
                          : Container(color: Colors.black26, child: const Center(child: Icon(Icons.image, color: Colors.white10, size: 28))),
                    ),
                  ),
                  // 🏷️ نظام وسم الحقوق التلقائي والمحمي لـ NF على زاوية الصورة الفرعية المصغرة
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                      child: const Text(
                        "NF",
                        style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          if (isHotMatch && !isRead)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.local_fire_department, color: Colors.redAccent, size: 15),
                            ),
                          Expanded(
                            child: Text(
                              article.title,
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isRead ? Colors.white38 : Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isRead ? Colors.white10 : const Color(0x1A00FF66),
                            borderRadius: BorderRadius.circular(8),
                            // حواف نيونية مشعة باللون الأخضر المضيء للزر التفاعلي الفرعي
                            border: Border.all(color: isRead ? Colors.white24 : const Color(0xFF00FF66).withOpacity(0.5), width: 1),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() => _readArticlesMemory.add(article.articleUrl));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: const Center(
                              child: Text('اقرأ المزيد', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                          ),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            const Icon(Icons.access_time, color: Colors.white24, size: 11),
                            const SizedBox(width: 4),
                            Text(
                              _getFormatedTimeAgo(article.publishedAt),
                              style: TextStyle(color: isRead ? Colors.white24 : Colors.white38, fontSize: 10, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
