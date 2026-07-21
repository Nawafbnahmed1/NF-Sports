import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

// 🧱 كلاس ديناميكي مجهز ومفتوح لاستقبال إحصائيات وغيابات اللقاء الحية تلقائياً من روابط السيرفر
class MatchDetailModel {
  final String possession1;
  final String possession2;
  final String shots1;
  final String shots2;
  final String fouls1;
  final String fouls2;
  final List<String> injuries1;
  final List<String> injuries2;

  const MatchDetailModel({
    required this.possession1, required this.possession2,
    required this.shots1, required this.shots2,
    required this.fouls1, required this.fouls2,
    required this.injuries1, required this.injuries2,
  });
}

class DetailsTab extends StatelessWidget {
  const DetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔄 خلايا انتظار مفرغة وجاهزة لاستقبال ضخ الروابط الحقيقية فوراً بدون نصوص تجريبية ثابتة
    const details = MatchDetailModel(
      possession1: '0%',
      possession2: '0%',
      shots1: '0',
      shots2: '0',
      fouls1: '0',
      fouls2: '0',
      injuries1: [],
      injuries2: [],
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20, top: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('إحصائيات المباراة', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 22,
              child: Column(
                children: [
                  _buildStatRow('الاستحواذ', details.possession1, details.possession2, 0.5, 0.5),
                  const SizedBox(height: 15),
                  _buildStatRow('التسديدات', details.shots1, details.shots2, 0.5, 0.5),
                  const SizedBox(height: 15),
                  _buildStatRow('الأخطاء', details.fouls1, details.fouls2, 0.5, 0.5),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(right: 20, top: 25, bottom: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('العيادة الطبية والغيابات', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 22,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // غيابات الفريق الأول مفرغة تماماً لطلب نواف
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (details.injuries1.isEmpty)
                            const Text('لا توجد غيابات حية', style: TextStyle(color: Colors.white24, fontSize: 12, fontFamily: 'Cairo'))
                          else
                            ...details.injuries1.map((player) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text('• $player', style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
                            )),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 80, color: Colors.white10),
                    const SizedBox(width: 15),
                    // غيابات الفريق الثاني مفرغة وجاهزة لاستقبال الـ API
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (details.injuries2.isEmpty)
                            const Text('لا توجد غيابات حية', style: TextStyle(color: Colors.white24, fontSize: 12, fontFamily: 'Cairo'))
                          else
                            ...details.injuries2.map((player) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text('• $player', style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String val1, String label2, double flex1, double flex2) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(val1, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            Text(label2, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 4,
            width: double.infinity,
            color: Colors.white10,
            child: Row(
              children: [
                Expanded(flex: (flex1 * 100).toInt(), child: Container(color: AppTheme.neonBlue)),
                Expanded(flex: (flex2 * 100).toInt(), child: Container(color: Colors.redAccent)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
