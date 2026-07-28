import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'news_detail_screen.dart';

class NewsArticleModel {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String articleUrl;
  final DateTime publishedAt;

  const NewsArticleModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.articleUrl,
    required this.publishedAt,
  });

  factory NewsArticleModel.fromMap(Map<String, dynamic> map) {
    return NewsArticleModel(
      title: (map['title_ar'] ?? map['title'] ?? '').toString(),
      description: (map['description_ar'] ?? map['description'] ?? '').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      source: (map['source'] ?? '').toString(),
      articleUrl: (map['article_url'] ?? '').toString(),
      publishedAt: DateTime.parse(map['published_at']),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late Future<List<NewsArticleModel>> newsFuture;
  bool _isVideosTab = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    newsFuture = fetchNews();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<List<NewsArticleModel>> fetchNews() async {
    final data = await supabase
        .from('news')
        .select()
        .order('published_at', ascending: false)
        .limit(50);

    return (data as List)
        .map((e) => NewsArticleModel.fromMap(e))
        .toList();
  }

  // دالة ذكية لحساب الوقت المنقضي بطريقة رياضية حية وعربية كاملة
  String _getFormatedTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) return 'الآن';
    if (duration.inMinutes < 60) return 'منذ ${duration.inMinutes} د';
    if (duration.inHours < 24) return 'قبل ${duration.inHours} ساعة';
    return 'قبل ${duration.inDays} يوم';
  }

  // دالة تفعيل التحديث عند سحب الشاشة للأسفل مع اهتزاز فخم للهاتف
  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      newsFuture = fetchNews();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.neonBlue,
          backgroundColor: const Color(0xFF0A1220),
          strokeWidth: 3,
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () { setState(() { _isVideosTab = false; }); },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !_isVideosTab ? const Color(0x3300B4FF) : const Color(0xCC0A1220),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: !_isVideosTab ? AppTheme.neonBlue : Colors.white10, width: 2),
                                boxShadow: !_isVideosTab ? [
                                  BoxShadow(color: AppTheme.neonBlue.withOpacity(0.2), blurRadius: 8, spreadRadius: 1)
                                ] : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.newspaper, color: !_isVideosTab ? AppTheme.neonBlue : Colors.white38, size: 20),
                                  const SizedBox(width: 10),
                                  Text('الأخبار', style: TextStyle(color: !_isVideosTab ? AppTheme.neonBlue : Colors.white38, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () { setState(() { _isVideosTab = true; }); },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _isVideosTab ? const Color(0x3300B4FF) : const Color(0xCC0A1220),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _isVideosTab ? AppTheme.neonBlue : Colors.white10, width: 2),
                                boxShadow: _isVideosTab ? [
                                  BoxShadow(color: AppTheme.neonBlue.withOpacity(0.2), blurRadius: 8, spreadRadius: 1)
                                ] : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle_outline, color: _isVideosTab ? AppTheme.neonBlue : Colors.white38, size: 20),
                                  const SizedBox(width: 10),
                                  Text('الملخصات', style: TextStyle(color: _isVideosTab ? AppTheme.neonBlue : Colors.white38, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ⚡ شريط الأندية والمؤشرات التفاعلي المصغر لإضفاء فخامة عالمية على الشاشة
                if (!_isVideosTab)
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SizedBox(
                      height: 35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildMiniTag("🔥 العالمية"),
                          _buildMiniTag("⚽ الدوريات الكبرى"),
                          _buildMiniTag("🏆 دوري الأبطال"),
                          _buildMiniTag("🚨 عاجل"),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 15),

                // 🚨 شريط عنوان النيون المطور والنبّاض المخصص للأخبار العاجلة (بديل النجمة التالفة)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x1A00B4FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3), width: 1),
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
                              boxShadow: [
                                BoxShadow(color: Colors.redAccent, blurRadius: 8, spreadRadius: 2)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isVideosTab ? 'قائمة الملخصات والأهداف' : 'آخر الأخبار الرياضية الحية',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Cairo',
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "LIVE",
                          style: TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                FutureBuilder<List<NewsArticleModel>>(
                  future: newsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString(), style: const TextStyle(color: Colors.white24)));
                    }
                    final articles = snapshot.data ?? [];
                    if (articles.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text("لا توجد أخبار حالية", style: TextStyle(color: Colors.white38, fontFamily: 'Cairo')),
                      ));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return index == 0
                            ? _buildMainArticleCard(context, article)
                            : _buildSubArticleCard(context, article);
                      },
                    );
                  },
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTag(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo'))),
    );
  }

  // 👑 تعديل حجم الكرت الرئيسي المتضخم ليصبح متناسقاً ومميزاً وحوافه متوهجة بالنيون الأزرق الفخم
  Widget _buildMainArticleCard(BuildContext context, NewsArticleModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonBlue.withOpacity(0.15),
              blurRadius: 16,
              spreadRadius: 1,
            )
          ],
        ),
        child: GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 24,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 160, // تم ضبط الارتفاع ليكون متناسقاً تماماً ومحمي من التضخم المزعج
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: article.imageUrl.isNotEmpty
                      ? Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.black26,
                            child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 48)),
                          ),
                        )
                      : Container(
                          color: Colors.black26,
                          child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 48)),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        article.title,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo', height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: const Color(0x2600B4FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.neonBlue, width: 1.5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(article: article),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: const Center(
                              child: Text('اقرأ المزيد', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                          ),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            const Icon(Icons.flash_on, color: Colors.amber, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              _getFormatedTimeAgo(article.publishedAt), // محرك الوقت الرياضي الحي التنازلي
                              style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
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
  Widget _buildSubArticleCard(BuildContext context, NewsArticleModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 20,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: article.imageUrl.isNotEmpty
                    ? Image.network(
                        article.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black26,
                          child: const Center(child: Icon(Icons.image, color: Colors.white10, size: 28)),
                        ),
                      )
                    : Container(
                        color: Colors.black26,
                        child: const Center(child: Icon(Icons.image, color: Colors.white10, size: 28)),
                      ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      article.title,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo', height: 1.3),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0x1F00B4FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.neonBlue.withOpacity(0.5), width: 1),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(article: article),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: const Center(
                            child: Text('اقرأ المزيد', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          ),
                        ),
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(Icons.access_time, color: Colors.white24, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            _getFormatedTimeAgo(article.publishedAt), // محرك الوقت الرياضي الحي للكروت التحتية
                            style: const TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo'),
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
    );
  }
}
