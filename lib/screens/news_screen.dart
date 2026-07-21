import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class NewsArticleModel {
  final String title;
  final String time;
  final String imageUrl;
  final bool isMain;

  const NewsArticleModel({
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.isMain,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isVideosTab = false;

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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final article = NewsArticleModel(
                    title: '',
                    time: index == 0 ? '--:--' : '--:--',
                    imageUrl: '',
                    isMain: index == 0,
                  );
                  return article.isMain 
                      ? _buildMainArticleCard(context, article)
                      : _buildSubArticleCard(context, article);
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // 📐 دالة كارت الخبر أو الملخص الرئيسي مفرغة ومستعدة لاستقبال الروابط بدون تكرار
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
                color: Color(0x0DFFFFFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Center(
                child: Icon(
                  _isVideosTab ? Icons.play_circle_outline : Icons.image, 
                  color: Colors.white12, 
                  size: 48,
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
                      _isVideosTab ? 'في انتظار تفاصيل الملخص للـ API...' : 'في انتظار العناوين الحية للـ API...',
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
                          onTap: () {},
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: Text(
                              _isVideosTab ? 'شاهد الملخص' : 'اقرأ المزيد', 
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                        ),
                      ),
                      if (_isVideosTab)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0x3300B4FF), borderRadius: BorderRadius.circular(6)),
                          child: const Text('00:00', style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                        )
                      else
                        Text(article.time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
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

  // 📐 دالة كارت الخبر أو الملخص الفرعي مفرغة كلياً ومطهرة من نصوص التجارب لطلب نواف
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
                color: const Color(0x0DFFFFFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  _isVideosTab ? Icons.play_circle_outline : Icons.image, 
                  color: Colors.white10, 
                  size: 28,
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
                      _isVideosTab ? 'في انتظار تفاصيل الملخص للـ API...' : 'في انتظار تفاصيل الخبر للـ API...',
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
                          border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.5), width: 1),
                        ),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: Text(
                              _isVideosTab ? 'شاهد الملخص' : 'اقرأ المزيد', 
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Icon(_isVideosTab ? Icons.schedule : Icons.access_time, color: Colors.white24, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            _isVideosTab ? '00:00' : (article.time.isEmpty ? '--' : article.time), 
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
