import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';

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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !_isResultsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
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
                              color: _isResultsTab ? const Color(0x3300B4FF) : const Color(0x990A1220),
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
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    bool isSelected = index == 2;
                    return Container(
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              if (!_isResultsTab) ...[
                _buildLiveCard('الهلال', 'النصر', '09:45 م', 'المركز: 1', 'المركز: 2', ['W', 'W', 'W'], ['W', 'D', 'L'], 'ميتروفيتش (١٨)', 'رونالدو (٢٠)', '03:59:59'),
                _buildLiveCard('الاتحاد', 'الأهلي', '07:30 م', 'المركز: 3', 'المركز: 5', ['W', 'L', 'W'], ['D', 'W', 'L'], 'بنزيما (١٢)', 'محرز (٩)', '01:45:12'),
              ] else ...[
                _buildResultCard('الهلال', 'النصر', '3 - 1', 'المركز: 1', 'المركز: 2', ['W', 'W', 'W'], ['W', 'D', 'L'], 'ميتروفيتش (٢)', 'رونالدو (١)'),
                _buildResultCard('الاتحاد', 'الأهلي', '0 - 2', 'المركز: 3', 'المركز: 5', ['W', 'L', 'W'], ['D', 'W', 'L'], 'توني (٢)', '--'),
              ],
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveCard(String team1, String team2, String time, String r1, String r2, List<String> f1, List<String> f2, String s1, String s2, String countdown) {
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
                      Text(team1, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue)),
                        child: Text(r1, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(time, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0x4D00B4FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.neonBlue, width: 1.8)),
                      child: Text(countdown, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.shield, color: Colors.white, size: 36),
                      const SizedBox(height: 10),
                      Text(team2, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue)),
                        child: Text(r2, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10)),
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
  }

  Widget _buildResultCard(String team1, String team2, String score, String r1, String r2, List<String> f1, List<String> f2, String s1, String s2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GlassCard(
        borderRadius: 28,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white, size: 36), const SizedBox(height: 10), Text(team1, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
                Column(children: [Text(score, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), const Text('انتهت', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold))]),
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white, size: 36), const SizedBox(height: 10), Text(team2, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: Colors.white10)),
            
            // 🌟 الإضافة الخرافية المزدوجة لنواف: فصل الأزرار إلى مربعين نيون مستقلين ومتجاورين بالملي
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    text: 'تفاصيل المباراة',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: team1, team2: team2)));
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
