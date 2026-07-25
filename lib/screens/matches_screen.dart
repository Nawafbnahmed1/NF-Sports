import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';

class MatchModel {
  final String leagueName;
  final String team1;
  final String team2;
  final String time;
  final String score;
  final bool isEnded;
  final DateTime matchDate;

  const MatchModel({
    required this.leagueName,
    required this.team1,
    required this.team2,
    required this.time,
    required this.score,
    required this.isEnded,
    required this.matchDate,
  });

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    final rawDate = (map['match_date'] ?? '').toString();
    final dt = DateTime.tryParse(rawDate)?.toLocal() ?? DateTime.now();
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final status = (map['status'] ?? '').toString().toLowerCase();

    return MatchModel(
      leagueName: (map['league_name'] ?? '').toString(),
      team1: (map['home_team_name'] ?? '').toString(),
      team2: (map['away_team_name'] ?? '').toString(),
      time: '$hh:$mm',
      score: '${map['home_score'] ?? ''} - ${map['away_score'] ?? ''}',
      isEnded: status == 'finished' || status == 'ended' || status == 'final',
      matchDate: dt,
    );
  }
}
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final supabase = Supabase.instance.client;
  bool _isResultsTab = false;
  int _selectedDateIndex = 2;
  late List<DateTime> _days;
  late Future<List<Map<String, dynamic>>> matchesFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _days = List.generate(5, (i) => today.add(Duration(days: i - 2)));
    matchesFuture = fetchMatchesForDay(_days[_selectedDateIndex]);
  }

  // الدالة الفاحصة التي طلبها المطور بدون قيود زمنية لاختبار جلب البيانات بنجاح
  Future<List<Map<String, dynamic>>> fetchMatchesForDay(DateTime day) async {
    final data = await supabase.from('matches').select();
    debugPrint('Matches count: ${data.length}');
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
                              color: !_isResultsTab
                                  ? const Color(0x3300B4FF)
                                  : const Color(0xCC0A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: !_isResultsTab
                                    ? AppTheme.neonBlue
                                    : Colors.white10,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: !_isResultsTab
                                      ? AppTheme.neonBlue
                                      : Colors.white38,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'المباريات',
                                  style: TextStyle(
                                    color: !_isResultsTab
                                        ? AppTheme.neonBlue
                                        : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
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
                              color: _isResultsTab
                                  ? const Color(0x3300B4FF)
                                  : const Color(0xCC0A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isResultsTab
                                    ? AppTheme.neonBlue
                                    : Colors.white10,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: _isResultsTab
                                      ? AppTheme.neonBlue
                                      : Colors.white38,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'النتائج',
                                  style: TextStyle(
                                    color: _isResultsTab
                                        ? AppTheme.neonBlue
                                        : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
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
                          color: isSelected
                              ? const Color(0x2600B4FF)
                              : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.neonBlue
                                : Colors.white10,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: isSelected
                                  ? AppTheme.neonBlue
                                  : Colors.white38,
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${d.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.neonBlue
                                    : Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
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
                  final matches = matchesData.map((e) => MatchModel.fromMap(e)).toList();

                  if (matches.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'No matches found',
                          style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
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
                                  'مباريات اليوم',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          _isResultsTab
                              ? buildCustomResultCard(context, match)
                              : buildLiveCard(context, match),
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
                      const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        match.team1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      match.time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        match.team2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Colors.white10),
            ),
            NeonButton(
              text: 'تفاصيل المباراة',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatchDetailScreen(
                      team1: match.team1,
                      team2: match.team2,
                    ),
                  ),
                );
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
                      const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        match.team1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      match.score,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(
                        match.team2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(color: Colors.white10),
            ),
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    text: 'تفاصيل المباراة',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchDetailScreen(
                            team1: match.team1,
                            team2: match.team2,
                          ),
                        ),
                      );
                    },
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
