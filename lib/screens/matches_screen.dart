import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
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
  final List<String> team1Form;
  final List<String> team2Form;

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
    required this.team1Form,
    required this.team2Form,
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

    final t1FormRaw = map['team1_form'];
    final t2FormRaw = map['team2_form'];

    final t1Form = t1FormRaw is List
        ? t1FormRaw.map((e) => e.toString()).toList()
        : <String>['W', 'D', 'W'];

    final t2Form = t2FormRaw is List
        ? t2FormRaw.map((e) => e.toString()).toList()
        : <String>['L', 'W', 'D'];

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
      team1Form: t1Form,
      team2Form: t2Form,
    );
  }
}

// 🎨 المحرك الحركي الخفيف: رسام كرات النيون المشتعلة بالتحديث التلقائي (Futuristic Fire-Ball) بوزن صفر كيلوبايت لراحة الهاتف
class _CyberFireBallPainter extends CustomPainter {
  final double angle;
  final Color glowColor;

  _CyberFireBallPainter({required this.angle, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;

    final ballPaint = Paint()
      ..color = Colors.white24
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
  bool _isResultsTab = false;
  int _selectedDateIndex = 3; // وضع مؤشر الاختيار في المنتصف تلقائياً للتقويم المحدث لـ 7 أيام
  late List<DateTime> _days;
  late Future<List<Map<String, dynamic>>> matchesFuture;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  late AnimationController _refreshBallController;
  late AnimationController _sparkController;
  late Animation<double> _sparkAnimation;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 📅 ترقية الـ 7 أيام الكاملة لتغطية الدورة الأسبوعية للمباريات والنتائج بشكل متكامل وبدون نقص
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
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _refreshBallController.dispose();
    _sparkController.dispose();
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
    HapticFeedback.lightImpact(); // اللمعان النيوني الخاطف والاهتزاز اللطيف فائق النعومة لليوم النشط
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
              color: AppTheme.neonBlue,
              backgroundColor: const Color(0xFF0A1220),
              strokeWidth: 3,
              onRefresh: _handleDayRefresh, // ربط سحب الشاشة لتحديث جدول السحاب ومنع التجمد كلياً
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
                                onTap: () => setState(() => _isResultsTab = false),
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
                                onTap: () => setState(() => _isResultsTab = true),
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

                    // 📅 التقويم الأسبوعي المتكامل (7 مربعات كاملة أفقية لـ تقويم الأيام مع اللمعان النيوني والاهتزاز)
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _days.length, // 7 عناصر كاملة
                        itemBuilder: (context, index) {
                          final isSelected = index == _selectedDateIndex;
                          final d = _days[index];
                          
                          // أسماء أيام أسبوعية مصغرة لجمالية العرض الحاد
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
                                    color: isSelected ? const Color(0x2600B4FF) : AppTheme.surfaceColor,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected 
                                          ? AppTheme.neonBlue.withOpacity(0.5 + (_sparkAnimation.value * 0.5)) 
                                          : Colors.white10, 
                                      width: isSelected ? 2.0 : 1.5
                                    ),
                                    boxShadow: isSelected ? [
                                      BoxShadow(color: AppTheme.glowBlue.withOpacity(0.15 * _sparkAnimation.value), blurRadius: 10)
                                    ] : null,
                                  ),
                                  child: child,
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(dayName, style: TextStyle(color: isSelected ? AppTheme.neonBlue : Colors.white38, fontSize: 10, fontFamily: 'Cairo')),
                                  const SizedBox(height: 4),
                                  Text('${d.day}', style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: matchesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              // تفاعل التحميل الداخلي: ظهور كرات النيون المشتعلة بالدوران عند جلب حزم السحاب حياً لراحة المشاهد
                              child: AnimatedBuilder(
                                animation: _refreshBallController,
                                builder: (context, _) {
                                  return CustomPaint(
                                    size: const Size(40, 40),
                                    painter: _CyberFireBallPainter(angle: _refreshBallController.value * math.pi * 2, glowColor: AppTheme.neonBlue),
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

                        final selectedDate = _days[_selectedDateIndex];
                        matches = matches.where((m) {
                          final isSameDay = m.matchDate.year == selectedDate.year &&
                              m.matchDate.month == selectedDate.month &&
                              m.matchDate.day == selectedDate.day;
                          if (!isSameDay) return false;
                          return _isResultsTab ? m.isEnded : !m.isEnded;
                        }).toList();

                        matches.sort((a, b) {
                          if (a.isLive && !b.isLive) return -1;
                          if (!a.isLive && b.isLive) return 1;
                          return a.matchDate.compareTo(b.matchDate);
                        });

                        // ⚽ شاشة الاستاد الهادئ البديلة (تحفة بصرية تفاعلية خفيفة جداً تظهر عند خلو جدول اليوم أو النتائج لمنع جفاف الواجهة)
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
                                        painter: _CyberFireBallPainter(angle: _refreshBallController.value * math.pi * 0.5, glowColor: AppTheme.neonBlue.withOpacity(0.3)),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _isResultsTab ? 'لا توجد نتائج مسجلة لهذا اليوم' : 'لا توجد مباريات متاحة لهذا اليوم',
                                    style: const TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                  ),
                                  const SizedBox(height: 20),
                                  // زر التحدي التفاعلي الممتد والناعم لإعادة إنعاش الجدول
                                  InkWell(
                                    onTap: _handleDayRefresh,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      decoration: BoxDecoration(color: const Color(0x1F00B4FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.neonBlue.withOpacity(0.2))),
                                      child: const Text('تحديث جدول السحاب', style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
                                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _isResultsTab ? buildCustomResultCard(context, match) : buildLiveCard(context, match),
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
    // مستشعر ذكي لقراءة المباريات الجماهيرية المشتعلة لإطلاق هالة الأدرينالين في الخلفية تلقائياً
    final bool isHotMatch = match.leagueName.contains('كأس') || match.leagueName.contains('دوري أبطال') || match.isLive;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), // تقليص الأبعاد والمسافات لراحة العين
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // هالة الأدرينالين النبّاضة المرتعشة في الخلفية للقمم الحية والمشتعلة
          boxShadow: (isHotMatch && match.isLive) ? [
            BoxShadow(color: AppTheme.neonBlue.withOpacity(0.12), blurRadius: 12, spreadRadius: 1),
            BoxShadow(color: AppTheme.glowBlue.withOpacity(0.08), blurRadius: 6, spreadRadius: 0)
          ] : null,
        ),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          borderRadius: 20,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الفريق الأول: لوغو ناصع وواضح جداً واسم رشييق
                  Expanded(
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          width: 38, // المقاس الهندسي الموزون للوغو ناصع وواضح
                          height: 38,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: match.team1Logo.isNotEmpty && match.team1Logo.startsWith('http')
                              ? Image.network(match.team1Logo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white24, size: 24))
                              : const Icon(Icons.shield, color: Colors.white24, size: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(match.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                      ],
                    ),
                  ),

                  // العمود المركزي: مفرغ وصغير يحمل النتيجة أو التوقيت الفعلي فقط
                  Column(
                    children: [
                      if (match.isLive)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // نقطة الليزر النيونية الحمراء النابضة للبث المباشر
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
                        Text(match.time12Hour, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // الفريق الثاني: لوغو ناصع وواضح جداً واسم رشييق
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
                        Expanded(child: Text(match.team2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Padding(padding: EdgeInsets.symmetric(vertical: 6.0), child: Divider(color: Colors.white10, height: 1)),
              
              // شريط المؤشرات التحتية الزجاجي: يحمل الحقوق المصغرة والـ HD وزر الانتقال الرشيق
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(4)),
                        child: const Text("NF", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                      if (match.isLive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFF00F0FF), width: 0.5)),
                          child: const Text("LIVE HD", style: TextStyle(color: Color(0xFF00F0FF), fontSize: 7, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2)));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0x1F00B4FF), borderRadius: BorderRadius.circular(8)),
                      child: const Text('تفاصيل اللقاء', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
  // 👑 كرت النتائج المكتملة والمضغوط هندسياً لتوحيد أبعاد وهوية أقسام الشاشة الرئيسية والجدول
  Widget buildCustomResultCard(BuildContext context, MatchModel match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الفريق الأول باللوغو الصافي الواضح
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
                      Expanded(child: Text(match.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                    ],
                  ),
                ),

                // النتيجة النهائية للألعاب المنتهية القادمة من السيرفر
                Column(
                  children: [
                    Text(match.score, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    const Text('انتهت', style: TextStyle(color: Colors.white38, fontSize: 9, fontFamily: 'Cairo')),
                  ],
                ),

                // الفريق الثاني باللوغو الصافي الواضح
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
                      Expanded(child: Text(match.team2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                    ],
                  ),
                ),
              ],
            ),
            
            const Padding(padding: EdgeInsets.symmetric(vertical: 6.0), child: Divider(color: Colors.white10, height: 1)),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // شارات الجودة وحالة اللقاء المنتهية FT بشكل مصغر وأنيق جداً
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(4)),
                      child: const Text("NF", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                      child: const Text("FT", style: TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // زر زجاجي ناعم للانتقال الفوري لشاشة تفاصيل اللقاء الإحصائية
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2)));
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    decoration: BoxDecoration(color: const Color(0x0AFFFFFF), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
                    child: const Text('تفاصيل اللقاء', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
