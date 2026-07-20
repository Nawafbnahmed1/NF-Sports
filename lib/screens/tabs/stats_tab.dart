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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المقارنة الرقمية المتقدمة',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 15),
            
            // 🌟 كارد الإحصائيات الضخم المشحون بمؤشرات التفوق النبضي التلقائي والأرقام الإنجليزية الموحدة
            GlassCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 24,
              child: Column(
                children: [
                  _buildStatItem('الاستحواذ على الكرة', '58%', '42%', true),
                  _buildStatItem('إجمالي التسديدات', '16', '9', true),
                  _buildStatItem('التسديدات على المرمى', '7', '3', true),
                  _buildStatItem('التمريرات المفتاحية', '12', '5', true),
                  _buildStatItem('التدخلات الناجحة', '14', '18', false), // النصر أعلى (أحمر نيون)
                  _buildStatItem('حالات التسلل', '1', '4', false), // النصر أعلى في التسلل
                  _buildStatItem('الأخطاء المرتكبة', '9', '15', false),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🎨 دالة بناء الإحصاءات بمؤشرات التفوق النيوني والخطوط الكبيرة الواضحة
  Widget _buildStatItem(String label, String homeValue, String awayValue, bool isHomeBetter) {
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
          // شريط النيون التوضيحي المنقسم المضيء بالخلفية
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 5,
              width: double.infinity,
              color: Colors.white10,
              child: Row(
                children: [
                  Expanded(
                    flex: int.parse(homeValue.replaceAll('%', '')),
                    child: Container(color: AppTheme.neonBlue),
                  ),
                  Expanded(
                    flex: int.parse(awayValue.replaceAll('%', '')),
                    child: Container(color: Colors.redAccent.withValues(alpha: 0.5)),
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
