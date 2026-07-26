import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class MatchDetailModel {
  final String possession1;
  final String possession2;
  final String shots1;
  final String shots2;
  final String fouls1;
  final String fouls2;
  final List<String> injuries1;
  final List<String> injuries2;
  final double progress1;
  final double progress2;

  const MatchDetailModel({
    required this.possession1,
    required this.possession2,
    required this.shots1,
    required this.shots2,
    required this.fouls1,
    required this.fouls2,
    required this.injuries1,
    required this.injuries2,
    required this.progress1,
    required this.progress2,
  });
}

class DetailsTab extends StatelessWidget {
  const DetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Supabase.instance.client.from('match_details').select(),
      builder: (context, snapshot) {
        var possession1 = '50%';
        var possession2 = '50%';
        var shots1 = '0';
        var shots2 = '0';
        var fouls1 = '0';
        var fouls2 = '0';
        var injuries1 = <String>[];
        var injuries2 = <String>[];
        var prog1 = 0.5;
        var prog2 = 0.5;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final map = snapshot.data!.first;
          possession1 = '${map['home_possession'] ?? '50'}%';
          possession2 = '${map['away_possession'] ?? '50'}%';
          shots1 = (map['home_shots'] ?? '0').toString();
          shots2 = (map['away_shots'] ?? '0').toString();
          fouls1 = (map['home_fouls'] ?? '0').toString();
          fouls2 = (map['away_fouls'] ?? '0').toString();
          injuries1 = List<String>.from(map['home_injuries'] ?? []);
          injuries2 = List<String>.from(map['away_injuries'] ?? []);

          final p1 = double.tryParse(map['home_possession'].toString()) ?? 50.0;
          final p2 = double.tryParse(map['away_possession'].toString()) ?? 50.0;
          final total = p1 + p2;
          if (total > 0) {
            prog1 = p1 / total;
            prog2 = p2 / total;
          }
        }

        final details = MatchDetailModel(
          possession1: possession1,
          possession2: possession2,
          shots1: shots1,
          shots2: shots2,
          fouls1: fouls1,
          fouls2: fouls2,
          injuries1: injuries1,
          injuries2: injuries2,
          progress1: prog1,
          progress2: prog2,
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
                      _buildStatRow('الاستحواذ', details.possession1, details.possession2, details.progress1, details.progress2),
                      const SizedBox(height: 15),
                      _buildStatRow('التسديدات', details.shots1, details.shots2, details.progress1, details.progress2),
                      const SizedBox(height: 15),
                      _buildStatRow('الأخطاء', details.fouls1, details.fouls2, details.progress1, details.progress2),
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
      },
    );
  }

  Widget _buildStatRow(String label, String val1, String val2, double flex1, double flex2) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(val1, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            Text(val2, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
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
                Expanded(flex: (flex1 * 100).toInt() > 0 ? (flex1 * 100).toInt() : 1, child: Container(color: AppTheme.neonBlue)),
                Expanded(flex: (flex2 * 100).toInt() > 0 ? (flex2 * 100).toInt() : 1, child: Container(color: Colors.redAccent)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
