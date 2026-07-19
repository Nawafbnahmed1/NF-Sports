import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  bool _isResultsTab = false;

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
                          onTap: () { setState(() { _isResultsTab = false; }); },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isResultsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: !_isResultsTab ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today_outlined, color: !_isResultsTab ? AppTheme.neonBlue : Colors.white54, size: 18),
                                const SizedBox(width: 8),
                                Text('المباريات', style: TextStyle(color: !_isResultsTab ? AppTheme.neonBlue : Colors.white54, fontWeight: FontWeight.bold)),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isResultsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _isResultsTab ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, color: _isResultsTab ? AppTheme.neonBlue : Colors.white54, size: 18),
                                const SizedBox(width: 8),
                                Text('النتائج', style: TextStyle(color: _isResultsTab ? AppTheme.neonBlue : Colors.white54, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isResultsTab) ...[
                _buildLiveCard('الهلال', 'النصر', '21:45', 'باقي 4 ساعات'),
                _buildLiveCard('الاتحاد', 'الأهلي', '19:30', 'باقي ساعتان'),
              ] else ...[
                _buildResultCard('الهلال', 'النصر', '3 - 1'),
                _buildResultCard('الاتحاد', 'الأهلي', '0 - 2'),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveCard(String team1, String team2, String time, String countdown) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(team1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Column(
                  children: [
                    Text(time, style: const TextStyle(color: AppTheme.neonBlue, fontWeight: FontWeight.bold)),
                    Text(countdown, style: const TextStyle(color: Colors.amber, fontSize: 10)),
                  ],
                ),
                Text(team2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            NeonButton(text: 'تفاصيل المباراة', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String team1, String team2, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(team1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(score, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(team2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            NeonButton(text: 'شاهد الملخص', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
