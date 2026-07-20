import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';

class DetailsTab extends StatelessWidget {
  const DetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 1. شريط وقت اللعب الفعلي المضيء بالمؤثرات البصرية
            const Text(
              'وقت اللعب الفعلي',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 16,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                        child: const Text('لُعب بالفعل 73:30', style: TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                      const Text('الوقت الإجمالي 136:21', style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // شريط التقدم النيوني المتوهج
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 65, // النسبة المئوية الملعوبة
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.neonBlue,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonBlue.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(flex: 35, child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 🌟 2. خط أحداث ومجريات اللقاء الرأسي بالدقائق والأشواط
            const Text(
              'مجريات المباراة',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 10),
            
            _buildTimelineEvent('تمديد 1 - 0', '106\'', 'فيّران توريس\nنيكولاس ويليامز', Icons.sports_soccer, Colors.green),
            _buildTimelineEvent('نهاية الـ 90 دقيقة 0 - 0', '90\'+3\'', 'انتهاء الوقت الأصلي بالتعادل', Icons.timer, Colors.amber),
            _buildTimelineEvent('شوط 0 - 0', '45\'', 'نهاية الشوط الأول والدخول للاستراحة', Icons.pause_circle_outline, Colors.white38),
          ],
        ),
      ),
    );
  }

  // ودجيت بناء الحدث الزمني المنساب عمودياً مع خط التوهج النيوني
  Widget _buildTimelineEvent(String title, String time, String desc, IconData icon, Color glowColor) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الدقيقة والأيقونة المضيئة بنبض النيون
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: glowColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: glowColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(color: glowColor.withValues(alpha: 0.3), blurRadius: 8),
                  ],
                ),
                child: Icon(icon, color: glowColor, size: 16),
              ),
              // خط الربط العمودي النيوني الهادئ
              Container(width: 1.5, height: 50, color: Colors.white10),
            ],
          ),
          const SizedBox(width: 15),
          // كارد تفاصيل الحدث الرياضي الفخم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const SizedBox(width: 8),
                    Text(time, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11, height: 1.3, fontFamily: 'Cairo')),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
