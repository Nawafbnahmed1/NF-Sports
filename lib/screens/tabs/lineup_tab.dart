import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';

class LineupPlayerModel {
  final String name;
  final String number;
  final bool isSubstitute;

  const LineupPlayerModel({
    required this.name,
    required this.number,
    required this.isSubstitute,
  });

  factory LineupPlayerModel.fromMap(Map<String, dynamic> map) {
    return LineupPlayerModel(
      name: (map['player_name'] ?? 'لاعب').toString(),
      number: (map['jersey_number'] ?? '10').toString(),
      isSubstitute: map['is_substitute'] == true,
    );
  }
}

class LineupTab extends StatelessWidget {
  const LineupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Supabase.instance.client.from('lineups').select(),
      builder: (context, snapshot) {
        final playersData = snapshot.data ?? [];
        final allPlayers = playersData.map((e) => LineupPlayerModel.fromMap(e)).toList();

        // تقسيم ذكي بين اللاعبين الأساسيين لضخهم في الملعب
        final team1Starters = allPlayers.where((p) => !p.isSubstitute).take(3).toList();
        final team2Starters = allPlayers.where((p) => !p.isSubstitute).skip(3).take(3).toList();
        final substitutes = allPlayers.where((p) => p.isSubstitute).toList();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 🏟️ الحفاظ المطلق على هيكل لوحة عشب ملعبك الفخمة والمنسقة بالملي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 420,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2618),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.05),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // خطوط تقسيم العشب الهندسية والمستقيمة لملعبك
                      Center(child: Container(width: double.infinity, height: 1.5, color: Colors.white10)),
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white10, width: 1.5),
                          ),
                        ),
                      ),

                      // 🌟 العودة التاريخية للشعار الدائري النيوني المضيء (NF) في سنتر الدائرة ليعود تصميمك التجريبي الخرافي!
                      Center(
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF0A1220),
                            border: Border.all(color: AppTheme.neonBlue, width: 2),
                            boxShadow: [
                              BoxShadow(color: AppTheme.neonBlue.withOpacity(0.5), blurRadius: 12, spreadRadius: 1)
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'NF',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ),
                      // توزيع لاعبي الفريق الأول (الأعلى) برمجياً من السيرفر
                      if (team1Starters.isEmpty)
                        const Positioned(
                          top: 40, left: 0, right: 0,
                          child: Center(child: Text('في انتظار التشكيلة الحية للـ API...', style: TextStyle(color: Colors.white24, fontSize: 12, fontFamily: 'Cairo'))),
                        )
                      else
                        ...List.generate(team1Starters.length, (i) {
                          final p = team1Starters[i];
                          final leftPos = (i == 0) ? 40.0 : ((i == 1) ? 0.0 : null);
                          final rightPos = (i == 2) ? 40.0 : ((i == 1) ? 0.0 : null);
                          return Positioned(
                            top: 50,
                            left: leftPos,
                            right: rightPos,
                            child: _buildFieldPlayerWidget(p.name, p.number, AppTheme.neonBlue),
                          );
                        }),

                      // توزيع لاعبي الفريق الثاني (الأسفل) برمجياً من السيرفر
                      if (team2Starters.isEmpty)
                        const Positioned(
                          bottom: 40, left: 0, right: 0,
                          child: Center(child: Text('في انتظار التشكيلة الحية للـ API...', style: TextStyle(color: Colors.white24, fontSize: 12, fontFamily: 'Cairo'))),
                        )
                      else
                        ...List.generate(team2Starters.length, (i) {
                          final p = team2Starters[i];
                          final leftPos = (i == 0) ? 40.0 : ((i == 1) ? 0.0 : null);
                          final rightPos = (i == 2) ? 40.0 : ((i == 1) ? 0.0 : null);
                          return Positioned(
                            bottom: 50,
                            left: leftPos,
                            right: rightPos,
                            child: _buildFieldPlayerWidget(p.name, p.number, Colors.redAccent),
                          );
                        }),
                    ],
                  ),
                ),
              ),

              // شريط دكة البدلاء والاحتياط المطور لعرض باقي اللاعبين القادمين من السيرفر
              if (substitutes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('مقاعد البدلاء والاحتياط', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: substitutes.map((p) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                              child: Text('${p.number} - ${p.name}', style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
                            )).toList(),
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
      },
    );
  }

  // دالة بناء الدائرة النيونيّة والأرقام للاعبين داخل لوحة الملعب
  Widget _buildFieldPlayerWidget(String name, String number, Color themeColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0A1220),
            border: Border.all(color: themeColor, width: 1.5),
            boxShadow: [BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 6)],
          ),
          child: Center(child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.blackDE, borderRadius: BorderRadius.circular(4)),
          child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
