import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isHighlightsTab = false;

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
                          onTap: () { setState(() { _isHighlightsTab = false; }); },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !_isHighlightsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: !_isHighlightsTab ? AppTheme.neonBlue : Colors.white10, width: 2),
                              boxShadow: !_isHighlightsTab ? [const BoxShadow(color: Color(0x4D00B4FF), blurRadius: 12)] : null,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.newspaper, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text('الأخبار', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: InkWell(
                          onTap: () { setState(() { _isHighlightsTab = true; }); },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _isHighlightsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _isHighlightsTab ? AppTheme.neonBlue : Colors.white10, width: 2),
                              boxShadow: _isHighlightsTab ? [const BoxShadow(color: Color(0x4D00B4FF), blurRadius: 12)] : null,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_fill, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text('الملخصات', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isHighlightsTab) ...[
                _buildFeaturedBigCard(
                  title: 'الزعيم يحسم ديربي العاصمة المثير بثلاثية مدوية وينفرد بصدارة الترتيب',
                  buttonText: 'اقرأ المزيد',
                  isVideo: false,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.style, color: AppTheme.neonBlue, size: 16),
                      const SizedBox(width: 8),
                      Text('آخر الأخبار الرياضية', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                _buildSmallListItem(title: 'الاتحاد يستعيد نغمة الانتصارات بهدف قاتل وثمين في شباك الأهلي', buttonText: 'اقرأ المزيد', isVideo: false, timeOrDuration: 'قبل ١٠ د'),
                _buildSmallListItem(title: 'مدرب العالمي يرفض الأعذار ويعد الجماهير بتصحيح المسار في المواجهات القادمة', buttonText: 'اقرأ المزيد', isVideo: false, timeOrDuration: 'قبل ساعتين'),
              ] else ...[
                _buildFeaturedBigCard(
                  title: 'ملخص مباراة القمة المثيرة: الهلال ٣ - ١ النصر | الأهداف الكاملة واللقطات الحماسية',
                  buttonText: 'شاهد الملخص',
                  isVideo: true,
                  duration: '14:25',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.video_library, color: AppTheme.neonBlue, size: 16),
                      const SizedBox(width: 8),
                      Text('قائمة الملخصات والأهداف', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                _buildSmallListItem(title: 'أهداف وملخص مباراة الاتحاد والأهلي (٠ - ٢) بصوت المعلق الحماسي للدوري', buttonText: 'شاهد الملخص', isVideo: true, timeOrDuration: '08:40'),
                _buildSmallListItem(title: 'ملخص مواجهة الشباب والاتفاق النارية المليئة بالبطاقات الملونة والإثارة الكاملة', buttonText: 'شاهد الملخص', isVideo: true, timeOrDuration: '10:15'),
              ],
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBigCard({required String title, required String buttonText, required bool isVideo, String? duration}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        borderRadius: 28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x2600B4FF), width: 1.2),
              ),
              child: Center(
                child: Icon(
                  isVideo ? Icons.play_circle_filled : Icons.image,
                  color: const Color(0x6600B4FF),
                  size: 58,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.4, fontFamily: 'Cairo'),
                  ),
                ),
                if (isVideo && duration != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0x3300B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue, width: 1.2)),
                    child: Text(
                      duration,
                      style: const TextStyle(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10, height: 1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: NeonButton(text: buttonText, onPressed: () {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallListItem({required String title, required String buttonText, required bool isVideo, required String timeOrDuration}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 105,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0x05FFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x3300B4FF), width: 1.2),
              ),
              child: Center(
                child: Icon(isVideo ? Icons.play_circle_outline : Icons.newspaper, color: Colors.white38, size: 30),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 13, fontWeight: FontWeight.bold, height: 1.4, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 105,
                        child: NeonButton(text: buttonText, onPressed: () {}),
                      ),
                      // 🌟 طلب نواف الملكي: مربع توقيت كبير مستقل ومضيء بنيون فخم ومستقر
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0x2600B4FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.neonBlue, width: 1.2),
                          boxShadow: [const BoxShadow(color: Color(0x1F00B4FF), blurRadius: 6)],
                        ),
                        child: Row(
                          children: [
                            Icon(isVideo ? Icons.access_time : Icons.access_time_filled, color: AppTheme.neonBlue, size: 12),
                            const SizedBox(width: 5),
                            Text(
                              timeOrDuration,
                              style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
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
