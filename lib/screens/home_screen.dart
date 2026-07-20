import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_title.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              // الهيدر العلوي الاحترافي المضيء لـ NF SPORTS بحروف ضخمة وحادة جداً
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NF',
                          style: TextStyle(
                            color: AppTheme.neonBlue,
                            fontSize: 42, 
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: AppTheme.neonBlue.withValues(alpha: 0.8),
                                blurRadius: 25,
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'SPORTS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SectionTitle(title: 'مباريات اليوم'),
              // 👑 كارد الواجهة الخارق: مشحون بكثافة معلومات ونسب الفوز وهدافي القمة وحروف ضخمة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GlassCard(
                  borderRadius: 28,
                  child: Column(
                    children: [
                      // 🌟 مربع الحالة الذهبية المضيء المستقل لتوضيح تصنيف وقوة اللقاء برمجياً
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0x1A00B4FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.5), width: 1),
                        ),
                        child: const Text(
                          'قمة الكلاسيكو المرتقبة',
                          style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1.5)),
                                  child: const Icon(Icons.shield, color: Colors.white, size: 36),
                                ),
                                const SizedBox(height: 10),
                                const Text('الهلال', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue, width: 1)),
                                  child: const Text('المركز: 1', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Text('09:45 PM', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              const SizedBox(height: 8),
                              // العداد التنازلي المصغر والناعم جداً والمتناسق هندسياً لطلب نواف
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0x4D00B4FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.neonBlue, width: 1.2),
                                ),
                                child: const Text('03:59:59', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ),
                              const SizedBox(height: 6),
                              const Text('لم تبدأ', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1.5)),
                                  child: const Icon(Icons.shield, color: Colors.white, size: 36),
                                ),
                                const SizedBox(height: 10),
                                const Text('النصر', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue, width: 1)),
                                  child: const Text('المركز: 2', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10, height: 1)),
                      // 📈 شريط نسبة الفوز التوقعية الذكي لطلب نواف (Win Probability Bar) بمؤشرات نيون مضيئة
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('فوز الهلال: 55%', style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          Text('فوز النصر: 30%', style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 6,
                          width: double.infinity,
                          color: Colors.white10,
                          child: Row(
                            children: [
                              Expanded(flex: 55, child: Container(color: AppTheme.neonBlue)), // نسبة فوز الهلال نيون أزرق
                              Expanded(flex: 15, child: Container(color: Colors.white30)),   // نسبة التعادل رمادي
                              Expanded(flex: 30, child: Container(color: Colors.redAccent)), // نسبة فوز النصر نيون أحمر
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Colors.white10, height: 1)),
                      
                      // ⚽ خانة هدافي القمة بالتفصيل الفخم والأرقام الإنجليزية الموحدة
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('هداف الفريق: ميتروفيتش (18 هدف)', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          Text('هداف الفريق: رونالدو (20 goal)', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10, height: 1)),
                      
                      // صف الدوائر الملونة المضيئة لآخر مباريات
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('W W W', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          Text('النتائج الأخيرة ومؤشرات الأداء', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          Text('W D L', style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10, height: 1)),
                      
                      // زر تفاصيل المباراة الفخم والضخم والمضيء
                      NeonButton(
                        text: 'تفاصيل المباراة',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchDetailScreen(team1: 'الهلال', team2: 'النصر')));
                        },
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const SectionTitle(title: 'آخر الأخبار'),
              _buildHorizontalList(isNews: true),
              const SizedBox(height: 20),
              const SectionTitle(title: 'أبرز اللقطات'),
              _buildHorizontalList(isNews: false),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalList({required bool isNews}) {
    return SizedBox(
      height: isNews ? 140 : 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: isNews ? 150 : 220,
            margin: const EdgeInsets.only(right: 15),
            child: GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 20,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      isNews ? Icons.newspaper : Icons.play_circle_outline,
                      color: Colors.white24,
                      size: isNews ? 32 : 42,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    left: 12,
                    child: Text(
                      isNews ? 'أهم خبر لليوم...' : 'أقوى ملخص كروي...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
