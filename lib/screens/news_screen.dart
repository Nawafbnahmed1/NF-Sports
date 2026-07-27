import 'package:flutter/material.dart';
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

class _NewsScreenState extends State<NewsScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<NewsArticleModel>> newsFuture;
  bool _isVideosTab = false;

  @override
  void initState() {
    super.initState();
    newsFuture = fetchNews();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(_isVideosTab ? Icons.play_circle_filled : Icons.stars, color: const Color(0xFF00B4FF), size: 18),
                    const SizedBox(width: 8),
                    Text(_isVideosTab ? 'قائمة الملخصات والأهداف' : 'آخر الأخبار الرياضية', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<NewsArticleModel>>(
                future: newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  final articles = snapshot.data ?? [];
                  if (articles.isEmpty) {
                    return const Center(child: Text("لا توجد أخبار"));
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
    );
  }

  Widget _buildMainArticleCard(BuildContext context, NewsArticleModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
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
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0x2600B4FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.neonBlue, width: 1),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article)),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: const Center(
                            child: Text('اقرأ المزيد', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          ),
                        ),
                      ),
                      Text(
                        "${article.publishedAt.day}/${article.publishedAt.month}",
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
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
              width: 90,
              height: 90,
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
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
                              MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article)),
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
                            "${article.publishedAt.day}/${article.publishedAt.month}",
                            style: const TextStyle(color: Colors.white24, fontSize: 11, fontFamily: 'Cairo'),
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
