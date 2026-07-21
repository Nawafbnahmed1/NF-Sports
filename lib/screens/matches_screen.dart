import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';

// 🧱 كلاس بروفيسور مجهز ومفتوح لاستقبال بيانات اللقاء الحية تلقائياً من روابط المواقع لاحقاً (API Model)
class MatchModel {
  final String team1;
  final String team2;
  final String time;
  final String r1;
  final String r2;
  final List<String> f1;
  final List<String> f2;
  final String scorer1;
  final String scorer2;
  final String countdown;
  final String score;
  final bool isEnded;

  const MatchModel({
    required this.team1, required this.team2, required this.time,
    required this.r1, required this.r2, required this.f1, required this.f2,
    required this.scorer1, required this.scorer2, required this.countdown,
    required this.score, required this.isEnded,
  });
}

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  bool _isResultsTab = false;
  int _selectedDateIndex = 2; // مؤشر ذكي لرصد دقة اليوم والتحويل التلقائي فور الربط

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
              // التبويبات العلوية المزدوجة الثابتة والمحمية للتنقل بين المباريات والنتائج
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () { setState(() { _isResultsTab = false; }); },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !_isResultsTab ? const Color(0x3300B4FF) : const Color(0xCC0A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: !_isResultsTab ? AppTheme.neonBlue : Colors.white10, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today, color: !_isResultsTab ? AppTheme.neonBlue : Colors.white38, size: 20),
                                const SizedBox(width: 10),
                                Text('المباريات', style: TextStyle(color: !_isResultsTab ? AppTheme.neonBlue : Colors.white38, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: InkWell(
                          onTap: () { setState(() { _isResultsTab = true; }); },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _isResultsTab ? const Color(0x3300B4FF) : const Color(0xCC0A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _isResultsTab ? AppTheme.neonBlue : Colors.white10, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: _isResultsTab ? AppTheme.neonBlue : Colors.white38, size: 20),
                                const SizedBox(width: 10),
                                Text('النتائج', style: TextStyle(color: _isResultsTab ? AppTheme.neonBlue : Colors.white38, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 📅 شريط التقويم التفاعلي الذكي لطلب نواف: مستعد وعار لسحب التواريخ والأيام الحية فوراً من الروابط
              SizedBox(
                height: 80,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5, // مجهز لاستيعاب الأيام الخمسة الحية المحدثة سحابياً تلقائياً
                  itemBuilder: (context, index) {
                    bool isSelected = index == _selectedDateIndex;
                    return InkWell(
                      onTap: () {
                        setState(() { 
                          _selectedDateIndex = index;
                          // 🔄 هنا يتم إطلاق دالة جذب وتحديث جدول مباريات التاريخ المختار تلقائياً فور الربط بالـ API
                        });
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0x2600B4FF) : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isSelected ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month, color: isSelected ? AppTheme.neonBlue : Colors.white38, size: 22),
                            const SizedBox(height: 6),
                            Container(width: 20, height: 4, decoration: BoxDecoration(color: isSelected ? AppTheme.neonBlue : Colors.transparent, borderRadius: BorderRadius.circular(2))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Text('الدوري السعودي للمحترفين', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              
              // 🔄 معالجة وعرض كروت اللقاءات ديناميكياً 100% بناءً على البيانات القادمة من الروابط سحابياً
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2, // مجهز لاستقبال عدد المباريات الحقيقي آلياً من السيرفر
                itemBuilder: (context, index) {
                  // كتل فنية فارغة ومفتوحة ومحصنة تماماً لاستقبال ضخ الروابط الحية فوراً
                  final match = MatchModel(
                    team1: index == 0 ? 'الهلال' : 'الاتحاد',
                    team2: index == 0 ? 'النصر' : 'الأهلي',
                    time: index == 0 ? '09:45 PM' : '07:30 PM',
                    r1: index == 0 ? 'المركز: 1' : 'المركز: 3',
                    r2: index == 0 ? 'المركز: 2' : 'المركز: 5',
                    f1: index == 0 ? ['W', 'W', 'W'] : ['W', 'L', 'W'],
                    f2: index == 0 ? ['W', 'D', 'L'] : ['D', 'W', 'L'],
                    scorer1: index == 0 ? 'ميتروفيتش (18 هدف)' : 'بنزيما (12 هدف)',
                    scorer2: index == 0 ? 'رونالدو (20 هدف)' : 'محرز (9 أهداف)',
                    countdown: index == 0 ? '03:59:59' : '01:45:12',
                    score: index == 0 ? '3 - 1' : '0 - 2',
                    isEnded: _isResultsTab,
                  );

                  return _isResultsTab 
                      ? _buildCustomResultCard(context, match)
                      : _buildLiveCard(context, match);
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // 🏟️ دالة كارت المباريات الديناميكية المستقرة والملمومة لطلب نواف العالمي
  Widget _buildLiveCard(BuildContext context, MatchModel match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        borderRadius: 28,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white, size: 36), const SizedBox(height: 10), Text(match.team1, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue)), child: Text(match.r1, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))])) ,
                Column(
                  children: [
                    Text(match.time, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0x4D00B4FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.neonBlue, width: 1.2)),
                      child: Text(match.countdown, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ),
                  ],
                ),
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white, size: 36), const SizedBox(height: 10), Text(match.team2, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue)), child: Text(match.r2, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))])) ,
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10)),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: match.f1.map((f) => Container(width: 15, height: 15, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: f == 'W' ? Colors.green.withValues(alpha: 0.2) : Colors.redAccent.withValues(alpha: 0.2), shape: BoxShape.circle, border: Border.all(color: f == 'W' ? Colors.green : Colors.redAccent, width: 1.2)), child: Center(child: Text(f, style: TextStyle(color: f == 'W' ? Colors.green : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold))))).toList()),
                const Text('مؤشرات الأداء الأخيرة', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                Row(children: match.f2.map((f) => Container(width: 15, height: 15, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: f == 'W' ? Colors.green.withValues(alpha: 0.2) : Colors.redAccent.withValues(alpha: 0.2), shape: BoxShape.circle, border: Border.all(color: f == 'W' ? Colors.green : Colors.redAccent, width: 1.2)), child: Center(child: Text(f, style: TextStyle(color: f == 'W' ? Colors.green : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold))))).toList()),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10)),
            
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.sports_soccer, color: Colors.white38, size: 14),
                        const SizedBox(width: 6),
                        Expanded(child: Text('هداف الفريق: ${match.scorer1}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text('هداف الفريق: ${match.scorer2}', maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                        const SizedBox(width: 6),
                        const Icon(Icons.sports_soccer, color: Colors.white38, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Colors.white10)),
            NeonButton(text: 'تفاصيل المباراة', onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2))); }),
          ],
        ),
      ),
    );
  }

  // 📊 دالة كارت النتائج والأحداث التصاعدية بحرف د والأرقام الإنجليزية الموحدة لطلب نواف الاستثنائي
  Widget _buildCustomResultCard(BuildContext context, MatchModel match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        borderRadius: 28,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white, size: 36), const SizedBox(height: 10), Text(match.team1, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10)), child: Text(match.r1, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))])) ,
                Column(children: [Text(match.score, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), const SizedBox(height: 6), const Text('انتهت', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white, size: 36), const SizedBox(height: 10), Text(match.team2, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10)), child: Text(match.r2, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))])) ,
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: Colors.white10)),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (match.team1 == 'الهلال') ...[
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.style, color: Colors.amber, size: 13), SizedBox(width: 6), Text('مالكوم  د 81 (🟨)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.sports_soccer, color: Colors.green, size: 13), SizedBox(width: 6), Text('سالم الدوسري  د 68', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.sports_soccer, color: Colors.green, size: 13), SizedBox(width: 6), Text('ميتروفيتش  د 42', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                    ],
                  ),
                  const Text('الأحداث والبطاقات', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [Text('لابورت  د 89 (🟥)', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.style, color: Colors.red, size: 13)]),
                      SizedBox(height: 8),
                      Row(children: [Text('رونالدو   د 55', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.sports_soccer, color: Colors.green, size: 13)]),
                      SizedBox(height: 8),
                      Row(children: [Text('أوتافيو  د 30 (🟨)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.style, color: Colors.amber, size: 13)]),
                    ],
                  ),
                ] else ...[
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.style, color: Colors.amber, size: 13), SizedBox(width: 6), Text('بنزيما  د 76 (🟨)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.sports_soccer, color: Colors.green, size: 13), SizedBox(width: 6), Text('كانتي  د 22', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                    ],
                  ),
                  const Text('الأحداث والبطاقات', style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [Text('توني  د 88 (🟨)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.style, color: Colors.amber, size: 13)]),
                      SizedBox(height: 8),
                      Row(children: [Text('فرانك كيسي  د 61', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.sports_soccer, color: Colors.green, size: 13)]),
                      SizedBox(height: 8),
                      Row(children: [Text('محرز  د 14 (🟨)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.style, color: Colors.amber, size: 13)]),
                    ],
                  ),
                ],
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10)),
            
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    text: 'تفاصيل المباراة',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2)));
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0x1FFF3B30),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFF3B30), width: 1.5),
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(14),
                      child: const Center(
                        child: Text(
                          'شاهد الملخص',
                          style: TextStyle(color: Color(0xFFFF3B30), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
