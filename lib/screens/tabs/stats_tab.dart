import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
 
class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      // جلب الإحصائيات الرقمية المتقدمة مباشرة من جدول السيرفر المفتوح
      future: Supabase.instance.client.from('match_details').select(),
      builder: (context, snapshot) {
        // قيم حماية افتراضية مطابقة لتصميمك الأصلي لحين اكتمال تدفق السيرفر كاملاً
        var possessionHome = '58%';
        var possessionAway = '42%';
        var shotsHome = '16';
        var shotsAway = '9';
        var shotsOnGoalHome = '7';
        var shotsOnGoalAway = '3';
        var keyPassesHome = '12';
        var keyPassesAway = '5';
        var tacklesHome = '14';
        var tacklesAway = '18';
        var offsidesHome = '1';
        var offsidesAway = '4';
        var foulsHome = '9';
        var foulsAway = '15';

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final map = snapshot.data!.first;
          possessionHome = '${map['home_possession'] ?? '58'}%';
          possessionAway = '${map['away_possession'] ?? '42'}%';
          shotsHome = (map['home_shots'] ?? '16').toString();
          awayShotsConvert: shotsAway = (map['away_shots'] ?? '9').toString();
          shotsOnGoalHome = (map['home_shots_on_target'] ?? '7').toString();
          shotsOnGoalAway = (map['away_shots_on_target'] ?? '3').toString();
          keyPassesHome = (map['home_key_passes'] ?? '12').toString();
          keyPassesAway = (map['away_key_passes'] ?? '5').toString();
          tacklesHome = (map['home_tackles'] ?? '14').toString();
          tacklesAway = (map['away_tackles'] ?? '18').toString();
          offsidesHome = (map['home_offsides'] ?? '1').toString();
          offsidesAway = (map['away_offsides'] ?? '4').toString();
          foulsHome = (map['home_fouls'] ?? '9').toString();
          foulsAway = (map['away_fouls'] ?? '15').toString();
        }

        // حساب بولياني ذكي لتحديد من هو الأعلى لتفعيل الدوائر النيون المشعة لتصميمك
        final int pHome = int.tryParse(possessionHome.replaceAll('%', '')) ?? 50;
        final int pAway = int.tryParse(possessionAway.replaceAll('%', '')) ?? 50;
        final int sHome = int.tryParse(shotsHome) ?? 0;
        final int sAway = int.tryParse(shotsAway) ?? 0;
        final int sogHome = int.tryParse(shotsOnGoalHome) ?? 0;
        final int sogAway = int.tryParse(shotsOnGoalAway) ?? 0;
        final int kpHome = int.tryParse(keyPassesHome) ?? 0;
        final int kpAway = int.tryParse(keyPassesAway) ?? 0;
        final int tHome = int.tryParse(tacklesHome) ?? 0;
        final int tAway = int.tryParse(tacklesAway) ?? 0;
        final int oHome = int.tryParse(offsidesHome) ?? 0;
        final int oAway = int.tryParse(offsidesAway) ?? 0;
        final int fHome = int.tryParse(foulsHome) ?? 0;
        final int fAway = int.tryParse(foulsAway) ?? 0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'المقارنة الرقمية المتقدمة',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 15),
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  borderRadius: 24,
                  child: Column(
                    children: [
                      _buildStatItem('الاستحواذ على الكرة', possessionHome, possessionAway, pHome >= pAway),
                      _buildStatItem('إجمالي التسديدات', shotsHome, shotsAway, sHome >= sAway),
                      _buildStatItem('التسديدات على المرمى', shotsOnGoalHome, shotsOnGoalAway, sogHome >= sogAway),
                      _buildStatItem('التمريرات المفتاحية', keyPassesHome, keyPassesAway, kpHome >= kpAway),
                      _buildStatItem('التدخلات الناجحة', tacklesHome, tacklesAway, tHome >= tAway),
                      _buildStatItem('حالات التسلل', offsidesHome, offsidesAway, oHome <= oAway), // الأقل تسللاً هو الأفضل
                      _buildStatItem('الأخطاء المرتكبة', foulsHome, foulsAway, fHome <= fAway), // الأقل أخطاءً هو الأفضل
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
  // 🎨 الحفاظ المطلق على دالة بناء الإحصاءات بمؤشرات التفوق النيوني والخطوط الكبيرة التفاعلية لطلبك
  Widget _buildStatItem(String label, String homeValue, String awayValue, bool isHomeBetter) {
    // معالجة وحساب قيم الـ flex التلقائية بأمان تام لمنع الأخطاء البرمجية أثناء القراءة الحية
    final int hVal = int.tryParse(homeValue.replaceAll('%', '')) ?? 50;
    final int aVal = int.tryParse(awayValue.replaceAll('%', '')) ?? 50;
    final int total = hVal + aVal;
    
    final int flex1 = total > 0 ? ((hVal / total) * 100).toInt() : 50;
    final int flex2 = total > 0 ? ((aVal / total) * 100).toInt() : 50;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // رقم فريقك الهلال (محاط بدائرة نيون زرقاء متوهجة إذا كان هو الأعلى)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: isHomeBetter 
                  ? BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.neonBlue, width: 1.2))
                  : null,
                child: Text(
                  homeValue,
                  style: TextStyle(color: isHomeBetter ? AppTheme.neonBlue : Colors.white70, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              
              // اسم الإحصائية بخط Cairo العريض الواضح جداً للمستخدم
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              
              // رقم الفريق المنافس النصر (محاط بدائرة نيون حمراء متوهجة إذا كان هو الأعلى)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: !isHomeBetter 
                  ? BoxDecoration(color: const Color(0x26FF3B30), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent, width: 1.2))
                  : null,
                child: Text(
                  awayValue,
                  style: TextStyle(color: !isHomeBetter ? Colors.redAccent : Colors.white70, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // شريط النيون التوضيحي المنقسم المضيء بالخلفية المربوط ديناميكياً بأرقام السيرفر
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 5,
              width: double.infinity,
              color: Colors.white10,
              child: Row(
                children: [
                  Expanded(
                    flex: flex1 > 0 ? flex1 : 1,
                    child: Container(color: AppTheme.neonBlue),
                  ),
                  Expanded(
                    flex: flex2 > 0 ? flex2 : 1,
                    child: Container(color: Colors.redAccent.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
