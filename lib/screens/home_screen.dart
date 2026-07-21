import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_title.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';

// 🧱 نموذج بروفيسور حر وخالٍ تماماً من أي نصوص ثابتة ومستعد لاستقبال بيانات السيرفر
class HomeMatchModel {
  final String team1;
  final String team2;
  final String status;
  final String time;
  final String p1;
  final String p2;
  final String h1;
  final String h2;
  final String f1;
  final String f2;

  const HomeMatchModel({
    required this.team1, required this.team2, required this.status,
    required this.time, required this.p1, required this.p2,
    required this.h1, required this.h2, required this.f1, required this.f2,
  });
}

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
              
              // 🏟️ شريط المباريات التمريري الأفقي (Horizontal Carousel) المطور والمفرغ تماماً من نصوص التجارب لربط الروابط الحية
              SizedBox(
                height: 355, // تحديد ارتفاع مثالي ملموم ونحيف لمنع أي منظر سلبي
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3, // مجهز ليعرض قمم اليوم جنب بعضها أفقياً تلقائياً من الروابط
                  itemBuilder: (context, index) {
                    // 🔄 خلايا انتظار وتمرير ذكية وحرة ومفرغة كلياً من النصوص الثابتة القديمة لطلب نواف
                    final match = HomeMatchModel(
                      team1: index == 0 ? '' : (index == 1 ? '' : ''),
                      team2: index == 0 ? '' : (index == 1 ? '' : ''),
                      status: index == 0 ? '' : (index == 1 ? '' : ''),
                      time: index == 0 ? '' : (index == 1 ? '' : ''),
                      p1: index == 0 ? '0%' : (index == 1 ? '0%' : '0%'),
                      p2: index == 0 ? '0%' : (index == 1 ? '0%' : '0%'),
                      h1: index == 0 ? '' : (index == 1 ? '' : ''),
                      h2: index == 0 ? '' : (index == 1 ? '' : ''),
                      f1: index == 0 ? '' : (index == 1 ? '' : ''),
                      f2: index == 0 ? '' : (index == 1 ? '' : ''),
                    );

                    return Container(
                      width: 325, // رشق وتصغير العرض بالملي لكي يظهر طرف المربع الثاني جنبه ويسحبه المستخدم فورا
                      margin: const EdgeInsets.only(right: 16),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // تقليص وحلق المسافات الداخلية ليكون ملموماً ونحيفاً
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
                              child: Text(match.status, style: TextStyle(color: AppTheme.neonBlue, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8), // تصغير وتلميم الأيقونات
                                        decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1)),
                                        child: Icon(Icons.shield, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(match.team1, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                                        child: Text('', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(match.time, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: const Color(0x4D00B4FF), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.neonBlue, width: 1)),
                                      child: Text(match.time, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1)),
                                        child: Icon(Icons.shield, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(match.team2, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                                        child: Text('', style: TextStyle(color: Color(0xFF00B4FF), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
                                Text(match.p1, style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Text(match.p2, style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
                                    Expanded(flex: int.parse(match.p1.replaceAll('%', '')) > 0 ? int.parse(match.p1.replaceAll('%', '')) : 1, child: Container(color: AppTheme.neonBlue)), 
                                    Expanded(flex: 15, child: Container(color: Colors.white30)),   
                                    Expanded(flex: int.parse(match.p2.replaceAll('%', '')) > 0 ? int.parse(match.p2.replaceAll('%', '')) : 1, child: Container(color: Colors.redAccent)), 
                                  ],
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(match.h1, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                                const SizedBox(width: 8),
                                Expanded(child: Text(match.h2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(match.f1, style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                Text('', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Text(match.f2, style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Divider(color: Colors.white10, height: 1)),
                            NeonButton(
                              text: 'تفاصيل المباراة',
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2)));
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
                      '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
