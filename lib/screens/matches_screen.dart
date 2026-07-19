import "match_detail_screen.dart";
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
                              color: !_isResultsTab ? AppTheme.neonBlue.withValues(alpha: 0.2) : AppTheme.surfaceColor.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: !_isResultsTab ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                              boxShadow: !_isResultsTab ? [BoxShadow(color: AppTheme.neonBlue.withValues(alpha: 0.15), blurRadius: 10)] : null,
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
                              color: _isResultsTab ? AppTheme.neonBlue.withValues(alpha: 0.2) : AppTheme.surfaceColor.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _isResultsTab ? AppTheme.neonBlue : Colors.white10, width: 1.5),
                              boxShadow: _isResultsTab ? [BoxShadow(color: AppTheme.neonBlue.withValues(alpha: 0.15), blurRadius: 10)] : null,
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
              
              SizedBox(
                height: 75,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    bool isSelected = index == 2;
                    return Container(
                      width: 65,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.neonBlue.withValues(alpha: 0.15) : AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? AppTheme.neonBlue : Colors.white10, width: 1.2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month, color: isSelected ? AppTheme.neonBlue : Colors.white38, size: 20),
                          const SizedBox(height: 4),
                          Container(
                            width: 16,
                            height: 3,
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.neonBlue : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: Colors.white.withValues(alpha: 0.05), child: const Icon(Icons.emoji_events, color: Colors.white70, size: 12)),
                    const SizedBox(width: 8),
                    const Text('الدوري السعودي للمحترفين', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // 🏆 عرض الكروت الفردية الصغيرة والمستقلة بناءً على التبويب المختار
              if (!_isResultsTab) ...[
                _buildIndependentLiveMatchCard('الهلال', 'النصر', '21:45', 'المركز: 1', 'المركز: 2', 'W W W', 'W D L', 'باقي 4 ساعات'),
                _buildIndependentLiveMatchCard('الاتحاد', 'الأهلي', '19:30', 'المركز: 3', 'المركز: 5', 'W L W', 'D W L', 'باقي ساعتان'),
              ] else ...[
                _buildIndependentResultMatchCard('الهلال', 'النصر', '3 - 1', 'المركز: 1', 'المركز: 2', 'W W W', 'W D L'),
                _buildIndependentResultMatchCard('الاتحاد', 'الأهلي', '0 - 2', 'المركز: 3', 'المركز: 5', 'W L W', 'D W L'),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 كارد مباراة فردي وصغير مستقل لجدول المباريات (نفس تصميمك بالملي)
  Widget _buildIndependentLiveMatchCard(
    String team1, String team2, String time, 
    String rank1, String rank2, String form1, String form2, String countdown
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الفريق الأول وإحصاءاته
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.white.withValues(alpha: 0.04), child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20)),
                      const SizedBox(height: 6),
                      Text(team1, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(rank1, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                      Text(form1, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
                // التوقيت والعداد التنازلي الذكي في المنتصف
                Column(
                  children: [
                    Text(time, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(countdown, style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    const Text('لم تبدأ', style: TextStyle(color: Colors.white30, fontSize: 10)),
                  ],
                ),
                // الفريق الثاني وإحصاءاته
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.white.withValues(alpha: 0.04), child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20)),
                      const SizedBox(height: 6),
                      Text(team2, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(rank2, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                      Text(form2, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Colors.white10, height: 1),
            ),
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

  // 🌟 كارد مباراة فردي وصغير مستقل لصفحة النتائج (نفس تصميمك بالملي)
  Widget _buildIndependentResultMatchCard(
    String team1, String team2, String score, 
    String rank1, String rank2, String form1, String form2
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.white.withValues(alpha: 0.04), child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20)),
                      const SizedBox(height: 6),
                      Text(team1, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(rank1, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                      Text(form1, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(score, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('انتهت', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: Colors.white.withValues(alpha: 0.04), child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20)),
                      const SizedBox(height: 6),
                      Text(team2, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(rank2, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                      Text(form2, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Colors.white10, height: 1),
            ),
            NeonButton(
              text: 'شاهد الملخص',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
