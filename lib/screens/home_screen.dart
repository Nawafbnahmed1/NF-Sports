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
              // 1️⃣ الهيدر العلوي الاحترافي المضيء لـ NF SPORTS
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
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: AppTheme.neonBlue.withValues(alpha: 0.6),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'SPORTS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SectionTitle(title: 'مباريات اليوم'),
              // 2️⃣ كارد مباراة اليوم الملكي الكبير والمضيء بالنيون والمؤثرات البصرية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  borderRadius: 24,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // الفريق الأول وإحصاءاته المضيئة
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x1A00B4FF))),
                                  child: const Icon(Icons.shield, color: Colors.white, size: 28),
                                ),
                                const SizedBox(height: 6),
                                const Text('الهلال', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0x1A00B4FF), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('المركز: 1', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ),
                              ],
                            ),
                          ),
                          // التوقيت والعداد التنازلي الرقمي في مربع نيون مستقل ومضيء بالمنتصف
                          Column(
                            children: [
                              const Text('09:45 م', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Cairo')),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0x3300B4FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.neonBlue, width: 1.2),
                                  boxShadow: [const BoxShadow(color: Color(0x2600B4FF), blurRadius: 6)],
                                ),
                                child: const Text(
                                  '03:59:59',
                                  style: TextStyle(color: AppTheme.neonBlue, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5, fontFamily: 'Cairo'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('لم تبدأ', style: TextStyle(color: Colors.white30, fontSize: 10, fontFamily: 'Cairo')),
                            ],
                          ),
                          // الفريق الثاني وإحصاءاته المضيئة
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x1A00B4FF))),
                                  child: const Icon(Icons.shield, color: Colors.white, size: 28),
                                ),
                                const SizedBox(height: 6),
                                const Text('النصر', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0x1A00B4FF), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('المركز: 2', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Colors.white10, height: 1)),
                      // صف الدوائر لآخر مباريات
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('W W W', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          Text('النتائج الأخيرة وفخامة الأداء', style: TextStyle(color: Colors.white24, fontSize: 9, fontFamily: 'Cairo')),
                          Text('W D L', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Divider(color: Colors.white10, height: 1)),
                      NeonButton(
                        text: 'تفاصيل المباراة',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchDetailScreen(team1: 'الهلال', team2: 'النصر')));
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 3️⃣ قسم آخر الأخبار المضيء
              const SectionTitle(title: 'آخر الأخبار'),
              _buildHorizontalList(isNews: true),

              const SizedBox(height: 15),

              // 4️⃣ قسم أبرز اللقطات المضيء
              const SectionTitle(title: 'أبرز اللقطات'),
              _buildHorizontalList(isNews: false),

              const SizedBox(height: 100), // مساحة للشريط السفلي الموحد
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
            width: isNews ? 140 : 200,
            margin: const EdgeInsets.only(right: 15),
            child: GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 16,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      isNews ? Icons.newspaper : Icons.play_circle_outline,
                      color: Colors.white24,
                      size: isNews ? 28 : 36,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Text(
                      isNews ? 'أهم خبر رياضي لليوم...' : 'أقوى ملخص كروي حاسم...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Cairo'),
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
