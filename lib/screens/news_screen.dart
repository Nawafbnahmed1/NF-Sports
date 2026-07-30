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

  final Set<String> _readArticlesMemory = <String>{};

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

  String _getFormatedTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) return 'الآن';
    if (duration.inMinutes < 60) return 'منذ ${duration.inMinutes} د';
    if (duration.inHours < 24) return 'قبل ${duration.inHours} ساعة';
    return 'قبل ${duration.inDays} يوم';
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      newsFuture = fetchNews();
    });
  }

  String _generateDynamicViews(NewsArticleModel article) {
    final int seed = article.articleUrl.hashCode.abs();
    final int baseViews = 300 + (seed % 300);
    final duration = DateTime.now().difference(article.publishedAt);
    final int growth = (duration.inMinutes ~/ 30) * 8;
    final int totalViews = baseViews + growth;
    
    if (totalViews >= 1000) {
      return '${(totalViews / 1000).toStringAsFixed(1)}K';
    }
    return '$totalViews';
  }

  void _openFuturisticVideoPlayer(BuildContext context, NewsArticleModel article) {
    HapticFeedback.vibrate();
    setState(() {
      _readArticlesMemory.add(article.articleUrl);
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    double localVolume = 0.8;
    double localBrightness = 0.6;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Player",
      barrierColor: Colors.black.withOpacity(0.95), // ✅ تم التصحيح هنا
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setPlayerState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            if (article.imageUrl.isNotEmpty)
                              Positioned.fill(child: Image.network(article.imageUrl, fit: BoxFit.cover)),
                            Container(color: Colors.black45),
                            
                            Positioned(
                              top: 16,
                              right: 16,
                              child: FadeTransition(
                                opacity: _pulseController,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3)),
                                  ),
                                  child: const Text(
                                    "NF SPORTS",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF00F0FF), width: 1),
                                ),
                                child: const Text("1080p HD", style: TextStyle(color: Color(0xFF00F0FF), fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ),

                            const Center(
                              child: Icon(Icons.play_arrow_rounded, color: AppTheme.neonBlue, size: 64),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setPlayerState(() {
                                localBrightness = (localBrightness - details.primaryDelta! / 200).clamp(0.0, 1.0);
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: localBrightness < 0.5 
                                  ? const Icon(Icons.brightness_low, color: Colors.white24)
                                  : const Icon(Icons.brightness_high, color: AppTheme.neonBlue),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setPlayerState(() {
                                localVolume = (localVolume - details.primaryDelta! / 200).clamp(0.0, 1.0);
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: localVolume == 0 
                                  ? const Icon(Icons.volume_off, color: Colors.white24)
                                  : const Icon(Icons.volume_up, color: AppTheme.neonBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.neonBlue.withOpacity(0.2)),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(Icons.pause_circle_filled, color: AppTheme.neonBlue, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              article.title,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.download_for_offline, color: AppTheme.neonBlue, size: 24),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('جاري التحميل...', style: TextStyle(fontFamily: 'Cairo'))),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 24),
                            onPressed: () {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                                boxShadow: !_isVideosTab ? AppTheme.neonGlow(blur: 8) : null,
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
                                boxShadow: _isVideosTab ? AppTheme.neonGlow(blur: 8) : null,
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
                FutureBuilder<List<NewsArticleModel>>(
                  future: newsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.only(top: 80.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString(), style: const TextStyle(color: Colors.white24)));
                    }
                    final articles = snapshot.data ?? [];
                    if (articles.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.only(top: 80.0),
                        child: Text("لا توجد بيانات حالية", style: TextStyle(color: Colors.white38, fontFamily: 'Cairo')),
                      ));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              physics: const BouncingScrollPhysics(),
                              itemCount: articles.length > 8 ? 8 : articles.length,
                              itemBuilder: (context, i) {
                                final bool isRead = _readArticlesMemory.contains(articles[i].articleUrl);
                                
                                return GestureDetector(
                                  onTap: () {
                                    if (!_isVideosTab) {
                                      setState(() { _readArticlesMemory.add(articles[i].articleUrl); });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: articles[i])));
                                    } else {
                                      _openFuturisticVideoPlayer(context, articles[i]);
                                    }
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
                                            border: Border.all(color: isRead ? Colors.white24 : AppTheme.neonBlue, width: 2),
                                            boxShadow: !isRead ? AppTheme.neonGlow(blur: 6) : null,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(40),
                                            child: articles[i].imageUrl.isNotEmpty
                                                ? Image.network(articles[i].imageUrl, fit: BoxFit.cover)
                                                : Container(color: AppTheme.surfaceColor, child: const Icon(Icons.flash_on, color: AppTheme.neonBlue)),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(_isVideosTab ? Icons.play_arrow : Icons.visibility, size: 10, color: isRead ? Colors.white24 : AppTheme.neonBlue.withOpacity(0.7)),
                                            const SizedBox(width: 2),
                                            Text(
                                              _generateDynamicViews(articles[i]),
                                              style: TextStyle(
                                                color: isRead ? Colors.white24 : Colors.white60, 
                                                fontSize: 9.5, 
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo'
                                              ),
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
                                      boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 8, spreadRadius: 2)],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isVideosTab ? 'أحدث الملخصات والأهداف' : 'آخر الأخبار الرياضية',
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'Cairo'),
                                ),
                                const Spacer(),
                                const Text("LIVE", style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold)),
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

  Widget _buildMainArticleCard(BuildContext context, NewsArticleModel article) {
    final bool isRead = _readArticlesMemory.contains(article.articleUrl);
    // ✅ تم تصحيح التعبير النمطي هنا
    final bool isHotMatch = RegExp(
      r'classico|derby|real madrid|barcelona|final|urgent',
      caseSensitive: false,
    ).hasMatch(article.title);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isRead ? 0.7 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: !isRead ? AppTheme.neonGlow(blur: 16) : null,
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
                    
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Text(
                          "NF SPORTS",
                          style: TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),

                    if (_isVideosTab)
                      Positioned.fill(
                        child: Center(
                          child: FadeTransition(
                            opacity: _pulseController,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                                border: Border.all(color: isRead ? Colors.white38 : AppTheme.neonBlue, width: 2),
                                boxShadow: !isRead ? AppTheme.neonGlow(blur: 12) : null,
                              ),
                              child: Icon(Icons.play_arrow_rounded, color: isRead ? Colors.white38 : AppTheme.neonBlue, size: 36),
                            ),
                          ),
                        ),
                      ),
                    if (_isVideosTab)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black70, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF00F0FF), width: 1)),
                          child: const Text("HD", style: TextStyle(color: Color(0xFF00F0FF), fontSize: 9, fontWeight: FontWeight.bold)),
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
                                  height: 1.4
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
                              color: isRead ? Colors.white10 : const Color(0x2600B4FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isRead ? Colors.white24 : AppTheme.neonBlue, width: 1.5),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() { _readArticlesMemory.add(article.articleUrl); });
                                if (!_isVideosTab) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
                                } else {
                                  _openFuturisticVideoPlayer(context, article);
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Text(_isVideosTab ? 'شاهد الملخص' : 'اقرأ المزيد', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ),
                            ),
                          ),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              if (_isVideosTab)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isRead ? Colors.white10 : const Color(0x1F00B4FF), 
                                    borderRadius: BorderRadius.circular(6), 
                                    border: Border.all(color: isRead ? Colors.white24 : AppTheme.neonBlue.withOpacity(0.4))
                                  ),
                                  child: Text("10 د", style: TextStyle(color: isRead ? Colors.white38 : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              Icon(_isVideosTab ? Icons.videocam : Icons.flash_on, color: isRead ? Colors.white24 : (_isVideosTab ? AppTheme.neonBlue : Colors.amber), size: 13),
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

  Widget _buildSubArticleCard(BuildContext context, NewsArticleModel article) {
    final bool isRead = _readArticlesMemory.contains(article.articleUrl);
    // ✅ تم تصحيح التعبير النمطي هنا أيضاً
    final bool isHotMatch = RegExp(
      r'classico|derby|real madrid|barcelona|final|urgent',
      caseSensitive: false,
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

                  if (_isVideosTab)
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black45, 
                            shape: BoxShape.circle, 
                            border: Border.all(color: isRead ? Colors.white38 : AppTheme.neonBlue, width: 1.5)
                          ),
                          child: Icon(Icons.play_arrow_rounded, color: isRead ? Colors.white38 : AppTheme.neonBlue, size: 18),
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
                                height: 1.3
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
                            color: isRead ? Colors.white10 : const Color(0x1F00B4FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isRead ? Colors.white24 : AppTheme.neonBlue.withOpacity(0.5), width: 1),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() { _readArticlesMemory.add(article.articleUrl); });
                              if (!_isVideosTab) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
                              } else {
                                _openFuturisticVideoPlayer(context, article);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Text(_isVideosTab ? 'شاهد الملخص' : 'اقرأ المزيد', style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                          ),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            if (_isVideosTab)
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isRead ? Colors.white10 : const Color(0x1A00B4FF), 
                                  borderRadius: BorderRadius.circular(5), 
                                  border: Border.all(color: isRead ? Colors.white24 : AppTheme.neonBlue.withOpacity(0.3))
                                ),
                                child: Text("12 د", style: TextStyle(color: isRead ? Colors.white38 : Colors.white60, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            Icon(_isVideosTab ? Icons.video_collection_outlined : Icons.access_time, color: Colors.white24, size: 11),
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
