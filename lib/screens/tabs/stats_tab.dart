import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // 📊 كارد إحصائيات الهجوم والتسديدات المضيء
            _buildStatGroupCard(
              title: 'أبرز الإحصائيات الهجومية',
              stats: [
                _buildStatRow('الاستحواذ', '65%', '35%', true, false),
                _buildStatRow('إجمالي التسديدات', '18', '9', true, false),
                _buildStatRow('تسديدات على المرمى', '7', '2', true, false),
              ],
            ),
            const SizedBox(height: 15),
            
            // 🛡️ كارد إحصائيات التمرير والدفاع
            _buildStatGroupCard(
              title: 'التمريرات والدفاع',
              stats: [
                _buildStatRow('دقة التمرير', '89%', '76%', true, false),
                _buildStatRow('الكرات الركنية', '6', '4', true, false),
                _buildStatRow('التصديات للحارس', '2', '6', false, true),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGroupCard({required String title, required List<Widget> stats}) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white10, height: 1),
          ),
          ...stats,
        ],
      ),
    );
  }

  // ودجيت بناء صف المقارنة الرقمية مع حقن مؤشر التفوق النيوني المتوهج حول الرقم الأعلى
  Widget _buildStatRow(String label, String homeStat, String awayStat, bool isHomeWinner, bool isAwayWinner) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // رقم الفريق الأول مع وميض نيون أزرق دافئ إذا كان متفوقاً
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHomeWinner ? const Color(0x2600B4FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isHomeWinner ? AppTheme.neonBlue : Colors.transparent, width: 1),
            ),
            child: Text(
              homeStat,
              style: TextStyle(
                color: isHomeWinner ? AppTheme.neonBlue : Colors.white70,
                fontSize: 13,
                fontWeight: isHomeWinner ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          // اسم الإحصائية بالمنتصف
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo'),
          ),
          // رقم الفريق الثاني مع وميض نيون أحمر متوهج إذا كان متفوقاً
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAwayWinner ? const Color(0x26FF3B30) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isAwayWinner ? const Color(0xFFFF3B30) : Colors.transparent, width: 1),
            ),
            child: Text(
              awayStat,
              style: TextStyle(
                color: isAwayWinner ? const Color(0xFFFF3B30) : Colors.white70,
                fontSize: 13,
                fontWeight: isAwayWinner ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
