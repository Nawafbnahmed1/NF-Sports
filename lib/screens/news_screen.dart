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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isHighlightsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: !_isHighlightsTab ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                              boxShadow: !_isHighlightsTab ? [const BoxShadow(color: Color(0x4D00B4FF), blurRadius: 10)] : null,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.newspaper_outlined, color: AppTheme.neonBlue, size: 18),
                                const SizedBox(width: 8),
                                Text('الأخبار', style: TextStyle(color: AppTheme.neonBlue, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isHighlightsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _isHighlightsTab ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                              boxShadow: _isHighlightsTab ? [const BoxShadow(color: Color(0x4D00B4FF), blurRadius: 10)] : null,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_outline, color: AppTheme.neonBlue, size: 18),
                                const SizedBox(width: 8),
                                Text('الملخصات', style: TextStyle(color: AppTheme.neonBlue, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 🏆 عرض المحتوى ديناميكياً بناءً على اختيار التبويب العلوي (الأخبار أو الملخصات)
              if (!_isHighlightsTab) ...[
                // 📰 أولاً: قسم الأخبار
                _buildFeaturedBigCard(
                  title: 'الهلال يحسم ديربي الرياض المثير بثلاثية مدوية وينفرد بالصدارة',
                  buttonText: 'اقرأ المزيد',
                  isVideo: false,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Icon(Icons.style, color: AppTheme.neonBlue, size: 14),
                      SizedBox(width: 6),
                      Text('آخر الأخبار', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                _buildSmallListItem(title: 'الاتحاد يستعيد نغمة الانتصارات بهدف قاتل في شباك الأهلي', buttonText: 'اقرأ المزيد', isVideo: false, timeOrDuration: 'قبل ١٠ د'),
                _buildSmallListItem(title: 'مدرب النصر يرفض الأعذار ويعد الجماهير بتصحيح المسار في المباريات القادمة', buttonText: 'اقرأ المزيد', isVideo: false, timeOrDuration: 'قبل ساعتين'),
              ] else ...[
                // 🎬 ثانياً: قسم الملخصات
                _buildFeaturedBigCard(
                  title: 'ملخص مباراة القمة المثيرة: الهلال ٣ - ١ النصر | الأهداف الكاملة واللقطات الحماسية',
                  buttonText: 'شاهد الملخص',
                  isVideo: true,
                  duration: '14:25',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Icon(Icons.video_library, color: AppTheme.neonBlue, size: 14),
                      SizedBox(width: 6),
                      Text('قائمة الملخصات', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                _buildSmallListItem(title: 'أهداف وملخص مباراة الاتحاد والأهلي (٠ - ٢) بصوت المعلق الحماسي الدوري السعودي', buttonText: 'شاهد الملخص', isVideo: true, timeOrDuration: '08:40'),
                _buildSmallListItem(title: 'ملخص مواجهة الشباب والاتفاق النارية المليئة بالبطاقات الملونة والإثارة الكاملة', buttonText: 'شاهد الملخص', isVideo: true, timeOrDuration: '10:15'),
              ],
              const SizedBox(height: 100), // مساحة للشريط السفلي الموحد
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 المربع الكبير الفخم في أعلى الصفحة (لأهم خبر أو أقوى ملخص لليوم)
  Widget _buildFeaturedBigCard({required String title, required String buttonText, required bool isVideo, String? duration}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GlassCard(
        borderRadius: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x1A00B4FF)),
              ),
              child: Center(
                child: Icon(
                  isVideo ? Icons.play_circle_filled : Icons.image_outlined,
                  color: const Color(0x6600B4FF),
                  size: 54,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, height: 1.4, fontFamily: 'Cairo'),
                  ),
                ),
                if (isVideo && duration != null) ...[
                  const SizedBox(width: 10),
                  // 🌟 مربع التوقيت المضيء الفخم للملخص الكبير
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0x1A00B4FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x3300B4FF))),
                    child: Text(
                      duration,
                      style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Colors.white10, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 125,
                  child: NeonButton(
                    text: buttonText,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🌟 المربعات المصغرة المحدثة بتوقيت مضيء ومؤثرات البصر
  Widget _buildSmallListItem({required String title, required String buttonText, required bool isVideo, required String timeOrDuration}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // جهة الصورة مع وميض إطار نيون أزرق خفيف
            Container(
              width: 95,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0x05FFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x2600B4FF), width: 1.2),
              ),
              child: Center(
                child: Icon(
                  isVideo ? Icons.play_circle_outline : Icons.newspaper,
                  color: Colors.white24,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // جهة النصوص والبيانات والـ الأزرار المصغرة بالاتجاه المظبوط
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 12, fontWeight: FontWeight.w600, height: 1.3, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        child: NeonButton(
                          text: buttonText,
                          onPressed: () {},
                        ),
                      ),
                      // 🌟 مربع التوقيت الصغير المضيء للفخامة (نفس طلبك بالملي)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x1A00B4FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0x2600B4FF)),
                        ),
                        child: Row(
                          children: [
                            Icon(isVideo ? Icons.access_time : Icons.access_time_filled, color: AppTheme.neonBlue, size: 11),
                            const SizedBox(width: 4),
                            Text(
                              timeOrDuration,
                              style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
