import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'match_detail_screen.dart';

class MatchModel {
  final String id;
  final String leagueName;
  final String team1;
  final String team2;
  final String team1Logo;
  final String team2Logo;
  final String time12Hour;
  final String score;
  final bool isLive;
  final bool isEnded;
  final DateTime matchDate;

  const MatchModel({
    required this.id,
    required this.leagueName,
    required this.team1,
    required this.team2,
    required this.team1Logo,
    required this.team2Logo,
    required this.time12Hour,
    required this.score,
    required this.isLive,
    required this.isEnded,
    required this.matchDate,
  });

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    final rawDate = (map['match_date'] ?? '').toString();
    final dt = DateTime.tryParse(rawDate)?.toLocal() ?? DateTime.now();

    final hour12 = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final mm = dt.minute.toString().padLeft(2, '0');
    final formattedTime = '$hour12:$mm $amPm';

    final status = (map['status'] ?? '').toString().toLowerCase();
    final isLiveMatch = status == 'live' || status == 'playing' || status == 'in_play';
    final isFinished = status == 'finished' || status == 'ended' || status == 'final';

    final leagueData = map['leagues'] as Map<String, dynamic>?;
    final homeTeamData = map['home_team'] as Map<String, dynamic>?;
    final awayTeamData = map['away_team'] as Map<String, dynamic>?;

    return MatchModel(
      id: (map['id'] ?? '').toString(),
      leagueName: (leagueData?['name_ar'] ?? leagueData?['name'] ?? map['league_name'] ?? 'مباراة ودية للأندية').toString(),
      team1: (homeTeamData?['name_ar'] ?? homeTeamData?['name'] ?? map['home_team_name'] ?? '').toString(),
      team2: (awayTeamData?['name_ar'] ?? awayTeamData?['name'] ?? map['away_team_name'] ?? '').toString(),
      team1Logo: (homeTeamData?['logo_url'] ?? map['home_logo_url'] ?? '').toString(),
      team2Logo: (awayTeamData?['logo_url'] ?? map['away_logo_url'] ?? '').toString(),
      time12Hour: formattedTime,
      score: '${map['home_score'] ?? '0'} - ${map['away_score'] ?? '0'}',
      isLive: isLiveMatch,
      isEnded: isFinished,
      matchDate: dt,
    );
  }
}
class _CyberFireBallPainter extends CustomPainter {
  final double angle;
  final Color glowColor;

  _CyberFireBallPainter({required this.angle, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;

    final ballPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, ballPaint);

    final flamePaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    for (int i = 0; i < 3; i++) {
      final currentAngle = angle + (i * math.pi / 1.5);
      final start = Offset(center.dx + math.cos(currentAngle) * radius, center.dy + math.sin(currentAngle) * radius);
      final end = Offset(center.dx + math.cos(currentAngle + 0.3) * (radius + 12), center.dy + math.sin(currentAngle + 0.3) * (radius + 12));
      path.moveTo(start.dx, start.dy);
      path.lineTo(end.dx, end.dy);
    }
    canvas.drawPath(path, flamePaint);
  }

  @override
  bool shouldRepaint(covariant _CyberFireBallPainter oldDelegate) => oldDelegate.angle != angle;
}

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  int _selectedDateIndex = 3; 
  late List<DateTime> _days;
  late Future<List<Map<String, dynamic>>> matchesFuture;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  late AnimationController _refreshBallController;
  late AnimationController _sparkController;
  late Animation<double> _sparkAnimation;
  late AnimationController _marqueeController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _days = List.generate(7, (i) => today.add(Duration(days: i - 3)));
    matchesFuture = fetchMatchesForDay(_days[_selectedDateIndex]);

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_blinkController);

    _refreshBallController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _sparkController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sparkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkController, curve: Curves.easeOut),
    );

    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _refreshBallController.dispose();
    _sparkController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }
  // دالة الاتصال الصافية والأمنة تماماً لجلب علاقات الدوريات والأندية من سحابتك
  Future<List<Map<String, dynamic>>> fetchMatchesForDay(DateTime day) async {
    final data = await supabase
        .from('matches')
        .select('''
          *,
          leagues ( name, name_ar, emblem ),
          home_team:teams!home_team_id ( name, name_ar, logo_url ),
          away_team:teams!away_team_id ( name, name_ar, logo_url )
        ''');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> _loadDay(int index) async {
    _sparkController.forward(from: 0.0);
    HapticFeedback.lightImpact(); // الاهتزاز اللطيف فائق النعومة لليوم النشط
    setState(() {
      _selectedDateIndex = index;
      matchesFuture = fetchMatchesForDay(_days[index]);
    });
  }

  // دالة حل مشكلة التجمد: تعيد تنشيط السحاب وتطلق كرة اللهب عند سحب المستخدم لأسفل الشاشة
  Future<void> _handleDayRefresh() async {
    HapticFeedback.mediumImpact();
    setState(() {
      matchesFuture = fetchMatchesForDay(_days[_selectedDateIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // 🛡️ الختم العلاماتي لـ NF SPORTS المائل والضخم بالخلفية بنسبة شفافة جداً 2% لمنح هيبة القنوات العالمية لـ واجهة التطبيق
            Positioned.fill(
              child: Opacity(
                opacity: 0.02,
                child: Transform.rotate(
                  angle: -math.pi / 6,
                  child: const Center(
                    child: Text(
                      'NF SPORTS',
                      style: TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.bold, letterSpacing: 10),
                    ),
                  ),
                ),
              ),
            ),

            RefreshIndicator(
              color: const Color(0xFF00FF66), // اللون الأخضر النيوني المعتم المعتمد لمنع تشوهات النظام
              backgroundColor: const Color(0xFF0A1220),
              strokeWidth: 3,
              onRefresh: _handleDayRefresh, // ربط سحب الشاشة لتحديث جدول السحاب ومنع التجمد كلياً
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // 📅 أولاً: شريط التقويم الأسبوعي المتكامل (7 مربعات كاملة أفقية لتقويم الأيام مع اللمعان والاهتزاز)
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _days.length, 
                        itemBuilder: (context, index) {
                          final isSelected = index == _selectedDateIndex;
                          final d = _days[index];
                          
                          final List<String> weekDaysAr = ['أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
                          final String dayName = weekDaysAr[d.weekday % 7];

                          return InkWell(
                            onTap: () => _loadDay(index),
                            borderRadius: BorderRadius.circular(18),
                            child: AnimatedBuilder(
                              animation: _sparkAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 68,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF161926).withOpacity(0.6) : AppTheme.surfaceColor,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected 
                                          ? const Color(0xFF00FF66).withOpacity(0.5 + (_sparkAnimation.value * 0.5)) 
                                          : Colors.white10, 
                                      width: isSelected ? 2.0 : 1.5
                                    ),
                                    boxShadow: isSelected ? [
                                      BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.15 * _sparkAnimation.value), blurRadius: 10)
                                    ] : null,
                                  ),
                                  child: child,
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(dayName, style: TextStyle(color: isSelected ? const Color(0xFF00FF66) : Colors.white38, fontSize: 10, fontFamily: 'Cairo', fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                  const SizedBox(height: 4),
                                  Text('${d.day}', style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 🛸 ثانياً: مستطيل الإعلانات الخرافي المتموج والمتحرك سحابياً بالكامل يستقر مباشرة تحت الأيام
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.3), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF66).withOpacity(0.12),
                              blurRadius: 10,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedBuilder(
                            animation: _marqueeController,
                            builder: (context, child) {
                              return FractionalTranslation(
                                translation: Offset(-1.0 + (_marqueeController.value * 2.0), 0.0),
                                child: Center(
                                  child: Text(
                                    '⚽ NF SPORTS MATCHES 📊', // صياغة البراند الحركية الفخمة تحت تقويم اليوم بالملي
                                    maxLines: 1,
                                    style: GoogleFonts.cairo(
                                      color: const Color(0xFF00FF66),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(color: const Color(0xFF00FF66).withOpacity(0.6), blurRadius: 8)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: matchesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _refreshBallController,
                                builder: (context, _) {
                                  return CustomPaint(
                                    size: const Size(40, 40),
                                    painter: _CyberFireBallPainter(
                                      angle: _refreshBallController.value * math.pi * 2, 
                                      glowColor: const Color(0xFF00FF66),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: Text('', style: TextStyle(color: Colors.white24))),
                          );
                        }

                        final matchesData = snapshot.data ?? [];
                        var matches = matchesData.map((e) => MatchModel.fromMap(e)).toList();

                        // 🔍 تصفية هندسية صافية وحصرية للمباريات الجارية والمستقبلية لهذا اليوم (استئصال جينات النتائج كلياً)
                        final selectedDate = _days[_selectedDateIndex];
                        matches = matches.where((m) {
                          final isSameDay = m.matchDate.year == selectedDate.year &&
                              m.matchDate.month == selectedDate.month &&
                              m.matchDate.day == selectedDate.day;
                          if (!isSameDay) return false;
                          return !m.isEnded; // جلب فقط اللقاءات التي لم تنتهِ لتنقية جدول المباريات
                        }).toList();

                        matches.sort((a, b) {
                          if (a.isLive && !b.isLive) return -1;
                          if (!a.isLive && b.isLive) return 1;
                          return a.matchDate.compareTo(b.matchDate);
                        });

                        // ⚽ شاشة الاستاد الهادئ البديلة والمطهرة بالكامل باللون النيوني المعتم عند خلو اللقاءات
                        if (matches.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                            child: Center(
                              child: Column(
                                children: [
                                  AnimatedBuilder(
                                    animation: _refreshBallController,
                                    builder: (context, _) {
                                      return CustomPaint(
                                        size: const Size(48, 48),
                                        painter: _CyberFireBallPainter(
                                          angle: _refreshBallController.value * math.pi * 0.5, 
                                          glowColor: const Color(0xFF00FF66).withOpacity(0.3),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا توجد مباريات متاحة لهذا اليوم',
                                    style: GoogleFonts.cairo(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: _handleDayRefresh,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00FF66).withOpacity(0.08), 
                                        borderRadius: BorderRadius.circular(12), 
                                        border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.2)),
                                      ),
                                      child: Text('تحديث جدول السحاب', style: GoogleFonts.cairo(color: const Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: matches.length,
                          itemBuilder: (context, index) {
                            final match = matches[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        match.leagueName,
                                        style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                buildLiveCard(context, match), // استدعاء حصرى ومباشر لكرت المباريات الرشيق
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // 👑 كرت المباريات الرشيق والمضغوط هندسياً لحماية الواجهة من الثقل وتوضيح لوغوهات الفرق بالملي
  Widget buildLiveCard(BuildContext context, MatchModel match) {
    final bool isHotMatch = match.leagueName.contains('كأس') || match.leagueName.contains('دوري أبطال') || match.isLive;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // هالة الأدرينالين النبّاضة المرتعشة في الخلفية باللون الأخضر النيوني المعتم للمباريات الحية
          boxShadow: (isHotMatch && match.isLive) ? [
            BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.12), blurRadius: 12, spreadRadius: 1),
            BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.06), blurRadius: 6, spreadRadius: 0)
          ] : null,
        ),
        child: GlassCard(
          backgroundColor: const Color(0xFF161926).withOpacity(0.6),
          borderColor: const Color(0xFF00FF66).withOpacity(0.15),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          borderRadius: 20,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الفريق الأول: لوغو ناصع وواضح جداً واسم رشييق وموزون
                  Expanded(
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: match.team1Logo.isNotEmpty && match.team1Logo.startsWith('http')
                              ? Image.network(match.team1Logo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white24, size: 24))
                              : const Icon(Icons.shield, color: Colors.white24, size: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(match.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),

                  // العمود المركزي المفرغ: يحمل النتيجة الكبيرة العريضة أو التوقيت الفعلي فقط
                  Column(
                    children: [
                      if (match.isLive)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeTransition(
                              opacity: _blinkAnimation,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(match.score, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                          ],
                        )
                      else
                        Text(match.time12Hour, style: GoogleFonts.cairo(color: const Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // الفريق الثاني: لوغو ناصع وواضح جداً واسم رشييق وموزون
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: match.team2Logo.isNotEmpty && match.team2Logo.startsWith('http')
                              ? Image.network(match.team2Logo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white24, size: 24))
                              : const Icon(Icons.shield, color: Colors.white24, size: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(match.team2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Padding(padding: EdgeInsets.symmetric(vertical: 6.0), child: Divider(color: Colors.white10, height: 1)),
              
              // 📱 شريط المؤشرات التحتية الزجاجي الفخم المطعم بكبسولة حقوقك وتوقيع البراند NF بالملي كصورتك
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black45, 
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.2), width: 0.5),
                        ),
                        child: Text("NF", style: GoogleFonts.cairo(color: const Color(0xFF00FF66).withOpacity(0.7), fontSize: 8, fontWeight: FontWeight.w900)),
                      ),
                      if (match.isLive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.black87, 
                            borderRadius: BorderRadius.circular(4), 
                            border: Border.all(color: const Color(0xFF00FF66), width: 0.8),
                          ),
                          child: Text("LIVE HD", style: GoogleFonts.cairo(color: const Color(0xFF00FF66), fontSize: 7, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ],
                  ),
                  
                  // زر نيونى ناعم ومطعم بالأخضر المعتم للانتقال الفوري لشاشة تفاصيل اللقاء الإحصائية
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2)));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF66).withOpacity(0.08), 
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.25), width: 1),
                      ),
                      child: Text('تفاصيل اللقاء', style: GoogleFonts.cairo(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
