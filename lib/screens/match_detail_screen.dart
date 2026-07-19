import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MatchDetailScreen extends StatelessWidget {
  final String team1;
  final String team2;

  const MatchDetailScreen({
    super.key,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: Text('تفاصيل مباراة $team1 ضد $team2', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.neonBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // كارد الإحصاءات الضخم والتشكيلة المتوقعة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  child: Column(
                    children: [
                      const Text('إحصائيات المباراة الضخمة', style: TextStyle(color: AppTheme.neonBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(color: Colors.white10, height: 30),
                      _buildStatRow('الاستحواذ', '60%', '40%'),
                      _buildStatRow('التسديدات', '14', '8'),
                      _buildStatRow('الأخطاء', '5', '11'),
                      const Divider(color: Colors.white10, height: 30),
                      const Text('التشكيلة المتوقعة للفريقين (4-3-3)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String stat1, String stat2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(stat1, style: const TextStyle(color: AppTheme.neonBlue, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(stat2, style: const TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
}
