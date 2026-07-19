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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                            child: const Icon(Icons.emoji_events, color: Colors.white70, size: 14),
                          ),
                          const SizedBox(width: 10),
                          const Text('الدوري السعودي للمحترفين', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: Colors.white10, height: 1),
                      ),
                      if (!_isResultsTab) ...[
                        _buildLiveMatchRow('الهلال', 'النصر', '21:45'),
                        const SizedBox(height: 15),
                        _buildLiveMatchRow('الاتحاد', 'الأهلي', '19:30'),
                      ] else ...[
                        _buildResultMatchRow('الهلال', 'النصر', '3 - 1'),
                        const SizedBox(height: 15),
                        _buildResultMatchRow('الاتحاد', 'الأهلي', '0 - 2'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveMatchRow(String team1, String team2, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.white.withValues(alpha: 0.05), child: const Icon(Icons.sports_soccer, color: Colors.white70, size: 16)),
            const SizedBox(width: 8),
            Text(team1, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
        Column(
          children: [
            Text(time, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('لم تبدأ', style: TextStyle(color: Colors.white30, fontSize: 10)),
          ],
        ),
        Row(
          children: [
            Text(team2, style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(width: 8),
            CircleAvatar(radius: 16, backgroundColor: Colors.white.withValues(alpha: 0.05), child: const Icon(Icons.sports_soccer, color: Colors.white70, size: 16)),
          ],
        ),
        const SizedBox(width: 5),
        SizedBox(width: 95, child: NeonButton(text: 'تفاصيل', onPressed: () {})),
      ],
    );
  }

  Widget _buildResultMatchRow(String team1, String team2, String score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.white.withValues(alpha: 0.05), child: const Icon(Icons.sports_soccer, color: Colors.white70, size: 16)),
            const SizedBox(width: 8),
            Text(team1, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
        Column(
          children: [
            Text(score, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('انتهت', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            Text(team2, style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(width: 8),
            CircleAvatar(radius: 16, backgroundColor: Colors.white.withValues(alpha: 0.05), child: const Icon(Icons.sports_soccer, color: Colors.white70, size: 16)),
          ],
        ),
        const SizedBox(width: 5),
        SizedBox(width: 95, child: NeonButton(text: 'الملخص', onPressed: () {})),
      ],
    );
  }
}
