import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_title.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
                            shadows: [Shadow(color: AppTheme.neonBlue.withValues(alpha: 0.8), blurRadius: 25)],
                          ),
                        ),
                        const Text(
                          'SPORTS',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 4),
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
              
              SizedBox(
                height: 355,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    String team1 = index == 0 ? 'الهلال' : (index == 1 ? 'الاتحاد' : 'الشباب');
                    String team2 = index == 0 ? 'النصر' : (index == 1 ? 'الأهلي' : 'القادسية');
                    String status = index == 0 ? 'قمة الكلاسيكو المرتقبة' : (index == 1 ? 'ديربي الغربية الناري' : 'لقاء العاصمة الحاسم');
                    String time = index == 0 ? '09:45 PM' : (index == 1 ? '07:30 PM' : '06:00 PM');
                    String p1 = index == 0 ? '55%' : (index == 1 ? '45%' : '40%');
                    String p2 = index == 0 ? '30%' : (index == 1 ? '35%' : '30%');
                    String h1 = index == 0 ? 'ميتروفيتش (18 هدف)' : (index == 1 ? 'بنزيما (12 هدف)' : 'حمدالله (10 أهداف)');
                    String h2 = index == 0 ? 'رونالدو (20 goal)' : (index == 1 ? 'محرز (9 أهداف)' : 'أوباميانغ (8 أهداف)');
                    String f1_str = index == 0 ? 'W W W' : (index == 1 ? 'W L W' : 'D W W');
                    String f2_str = index == 0 ? 'W D L' : (index == 1 ? 'D W L' : 'W L D');

                    return Container(
                      width: 325,
                      margin: const EdgeInsets.only(right: 16),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        borderRadius: 24,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0x1A00B4FF),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.4), width: 1),
                              ),
                              child: Text(status, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1)),
                                        child: const Icon(Icons.shield, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(team1, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                                        child: const Text('المركز: 1', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(time, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: const Color(0x4D00B4FF), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.neonBlue, width: 1)),
                                      child: Text('03:59:59', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('لم تبدأ', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1)),
                                        child: const Icon(Icons.shield, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(team2, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                                        child: Text('المركز: 2', style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('فوز الهلال: $p1', style: const TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Text('فوز النصر: $p2', style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 5,
                                width: double.infinity,
                                color: Colors.white10,
                                child: Row(
                                  children: [
                                    Expanded(flex: int.parse(p1.replaceAll('%', '')), child: Container(color: AppTheme.neonBlue)), 
                                    Expanded(flex: 15, child: Container(color: Colors.white30)),   
                                    Expanded(flex: int.parse(p2.replaceAll('%', '')), child: Container(color: Colors.redAccent)), 
                                  ],
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(h1, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                                const SizedBox(width: 8),
                                Expanded(child: Text(h2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(f1_str, style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                Text('النتائج الأخيرة ومؤشرات الأداء', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Text(f2_str, style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Divider(color: Colors.white10, height: 1)),
                            NeonButton(
                              text: 'تفاصيل المباراة',
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: team1, team2: team2)));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                  Center(child: Icon(isNews ? Icons.newspaper : Icons.play_circle_outline, color: Colors.white24, size: isNews ? 32 : 42)),
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
