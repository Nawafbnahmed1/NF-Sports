import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// 🧱 كلاس ديناميكي مجهز ومفتوح لاستقبال تشكيلات اللاعبين الحية تلقائياً من روابط السيرفر (API Lineup Model)
class MatchLineupModel {
  final List<String> starters1;
  final List<String> starters2;

  const MatchLineupModel({
    required this.starters1,
    required this.starters2,
  });
}

class LineupTab extends StatelessWidget {
  const LineupTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔄 خلايا انتظار مفرغة وجاهزة لاستقبال ضخ تشكيلات الروابط الحقيقية فوراً بدون أسماء تجريبية ثابتة
    const lineup = MatchLineupModel(
      starters1: [],
      starters2: [],
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // 🏟️ رسم لوحة عشب الملعب التفاعلية الفخمة والمنسقة بالملي
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              height: 420,
              decoration: BoxDecoration(
                color: const Color(0xFF0F2618),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // خطوط تقسيم العشب الهندسية والمستقيمة للملعب النيوني
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
                  // خلايا تموضع أزرار التشكيلة المفرغة والمستعدة لاستقبال الروابط الخارجية حية
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        lineup.starters1.isEmpty ? 'في انتظار التشكيلة الحية للـ API...' : 'تم تحميل التشكيلة',
                        style: const TextStyle(color: Colors.white38, fontSize: 13, fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        lineup.starters2.isEmpty ? 'في انتظار التشكيلة الحية للـ API...' : 'تم تحميل التشكيلة',
                        style: const TextStyle(color: Colors.white38, fontSize: 13, fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
