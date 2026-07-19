import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import 'matches_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

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
              // 📊 التبويب الثنائي العلوي (النتائج مضيئة بالنيون)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MatchesScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Colors.white54, size: 18),
                              SizedBox(width: 8),
                              Text('المباريات', style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.neonBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.neonBlue, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonBlue.withValues(alpha: 0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: AppTheme.neonBlue, size: 18),
                            SizedBox(width: 8),
                            Text('النتائج', style: TextStyle(color: AppTheme.neonBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 📅 شريط الأيام التفاعلي الأفقي
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

              // 🏆 كارد عرض النتائج المنتهية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 14, backgroundColor: Colors.white.withValues(alpha: 0.05), child: const Icon(Icons.emoji_events, color: Colors.white70, size: 14)),
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
                      _buildResultMatchRow('الهلال', 'النصر', '3 - 1'),
                      const SizedBox(height: 15),
                      _buildResultMatchRow('الاتحاد', 'الأهلي', '0 - 2'),
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
        SizedBox(
          width: 95,
          child: NeonButton(text: 'الملخص', onPressed: () {}),
        ),
      ],
    );
  }
}
