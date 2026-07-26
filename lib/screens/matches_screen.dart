import 'dart:async';
import 'package:flutter/material.dart';
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
  final String team1Scorer;
  final String team2Scorer;

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
    required this.team1Scorer,
    required this.team2Scorer,
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
      team1Scorer: (map['home_scorer'] ?? 'لا يوجد هداف حالي').toString(),
      team2Scorer: (map['away_scorer'] ?? 'لا يوجد هداف حالي').toString(),
    );
  }
}
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  bool _isResultsTab = false;
  int _selectedDateIndex = 2;
  late List<DateTime> _days;
  late Future<List<Map<String, dynamic>>> matchesFuture;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _days = List.generate(6, (i) => today.add(Duration(days: i - 2)));
    matchesFuture = fetchMatchesForDay(_days[_selectedDateIndex]);

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_blinkController);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchMatchesForDay(DateTime day) async {
    final data = await supabase
        .from('matches')
        .select('''
          *,
          leagues ( name, name_ar, emblem ),
          home_team:teams!home_team_id ( name, name_ar, logo_url ),
          away_team:teams!away_team_id ( name, name_ar, logo_url )
        ''');
    debugPrint('Live Matches fetched from cloud: ${data.length}');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> _loadDay(int index) async {
    setState(() {
      _selectedDateIndex = index;
      matchesFuture = fetchMatchesForDay(_days[index]);
    });
  }
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
                    return InkWell(
                      onTap: () => _loadDay(index),
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
                            Text('${d.day}', style: TextStyle(color: isSelected ? AppTheme.neonBlue : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
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
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(child: Text('Error: ${snapshot.error}')),
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

                  if (matches.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'لا توجد مباريات متاحة لهذا اليوم',
                          style: TextStyle(color: Colors.white70, fontSize: 15, fontFamily: 'Cairo'),
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
                                const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  match.leagueName,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
    );
  }
    Widget buildLiveCard(BuildContext context, MatchModel match) {
    return buildLiveCardActual(context, match);
  }

  Widget buildLiveCardActual(BuildContext context, MatchModel match) {
    final diff = match.matchDate.difference(DateTime.now());
    String countdownText = "00:00:00";
    if (!diff.isNegative) {
      final hours = diff.inHours.toString().padLeft(2, '0');
      final mins = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final secs = (diff.inSeconds % 60).toString().padLeft(2, '0');
      countdownText = "$hours:$mins:$secs";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        borderRadius: 28,
        child: Column(
          children: [
            if (match.isLive)
              Align(
                alignment: Alignment.topLeft,
                child: FadeTransition(
                  opacity: _blinkAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    margin: const EdgeInsets.only(left: 14, top: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0033),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(color: Color(0xFFFF0033), blurRadius: 10, spreadRadius: 1)],
                    ),
                    child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      match.team1Logo.isNotEmpty && match.team1Logo.startsWith('http')
                          ? Image.network(match.team1Logo, width: 44, height: 44, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 36))
                          : const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(match.team1, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(match.time12Hour, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    if (!match.isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                        child: Text(countdownText, style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                                Expanded(
                  child: Column(
                    children: [
                      match.team2Logo.isNotEmpty && match.team2Logo.startsWith('http')
                          ? Image.network(match.team2Logo, width: 44, height: 44, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 36))
                          : const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(match.team2, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.white10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: match.team1Form.map((f) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: f == 'W' ? Colors.green.withOpacity(0.3) : (f == 'D' ? Colors.grey.withOpacity(0.3) : Colors.red.withOpacity(0.3)),
                        border: Border.all(color: f == 'W' ? Colors.green : (f == 'D' ? Colors.grey : Colors.red), width: 1),
                      ),
                      child: Center(child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                    )).toList(),
                  ),
                  const Text('مؤشرات الأداء الأخيرة', style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo')),
                  Row(
                    children: match.team2Form.map((f) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: f == 'W' ? Colors.green.withOpacity(0.3) : (f == 'D' ? Colors.grey.withOpacity(0.3) : Colors.red.withOpacity(0.3)),
                        border: Border.all(color: f == 'W' ? Colors.green : (f == 'D' ? Colors.grey : Colors.red), width: 1),
                      ),
                      child: Center(child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                    )).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(match.team1Scorer, style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Cairo')),
                  const Text('هداف الفريق', style: TextStyle(color: Colors.white24, fontSize: 11, fontFamily: 'Cairo')),
                  Text(match.team2Scorer, style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Cairo')),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
  }

  Widget buildCustomResultCard(BuildContext context, MatchModel match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        borderRadius: 28,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      match.team1Logo.isNotEmpty && match.team1Logo.startsWith('http')
                          ? Image.network(match.team1Logo, width: 44, height: 44, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 36))
                          : const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(match.team1, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(match.score, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const Text('انتهت', style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo')),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      match.team2Logo.isNotEmpty && match.team2Logo.startsWith('http')
                          ? Image.network(match.team2Logo, width: 44, height: 44, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 36))
                          : const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(match.team2, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.white10),
            ),
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
  }
}
