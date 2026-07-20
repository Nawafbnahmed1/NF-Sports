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
            // ⏱️ 1. شريط وقت اللعب الفعلي المضيء بحروف ضخمة وأرقام إنجليزية
            const Text(
              'وقت اللعب الفعلي',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0x3300B4FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.neonBlue)),
                        child: const Text('لُعب بالفعل 73:30', style: TextStyle(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                      const Text('الوقت الإجمالي 136:21', style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 65,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.neonBlue,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: AppTheme.neonBlue.withValues(alpha: 0.6), blurRadius: 10)],
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
            
            const SizedBox(height: 25),
            const Text(
              'مجريات المباراة',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),

            // 📊 2. المستطيل الضخم المنقسم هندسياً إلى قسمين مع تفعيل حرف "د" والترتيب التصاعدي
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 24,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👉 الجانب الأيمن (أحداث الهلال منظم تصاعدياً من الأسفل للأعلى مع حرف "د")
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(child: Text('الهلال', style: TextStyle(color: AppTheme.neonBlue, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                          const Divider(color: Colors.white10, height: 16),
                          _buildEventItem('مالكوم', 'د 81', Icons.style, Colors.amber, hasAssist: false, assistName: ''),
                          const SizedBox(height: 14),
                          _buildEventItem('سالم الدوسري', 'د 68', Icons.sports_soccer, Colors.green, hasAssist: true, assistName: 'مالكوم'),
                          const SizedBox(height: 14),
                          _buildEventItem('ميتروفيتش', 'د 42', Icons.sports_soccer, Colors.green, hasAssist: true, assistName: 'نيفيز'),
                        ],
                      ),
                    ),
                    const VerticalDivider(color: Colors.white10, width: 20, thickness: 1.2),
                    // 👈 الجانب الأيسر (أحداث النصر منظم تصاعدياً من الأسفل للأعلى مع حرف "د")
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Center(child: Text('النصر', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                          const Divider(color: Colors.white10, height: 16),
                          _buildEventItem('لابورت', 'د 89', Icons.style, Colors.red, hasAssist: false, assistName: '', isRedCard: true),
                          const SizedBox(height: 14),
                          _buildEventItem('رونالدو', 'د 55', Icons.sports_soccer, Colors.green, hasAssist: true, assistName: 'ماني'),
                          const SizedBox(height: 14),
                          _buildEventItem('أوتافيو', 'د 30', Icons.style, Colors.amber, hasAssist: false, assistName: ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // 🌟 3. نقل ودمج مربع المقارنة الرقمية المتقدمة هنا بالأسفل لطلب نواف العبقري
            const Text(
              'المقارنة الرقمية المتقدمة',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 24,
              child: Column(
                children: [
                  _buildStatItem('الاستحواذ على الكرة', '58%', '42%', true),
                  _buildStatItem('إجمالي التسديدات', '16', '9', true),
                  _buildStatItem('التسديدات على المرمى', '7', '3', true),
                  _buildStatItem('التمريرات المفتاحية', '12', '5', true),
                  _buildStatItem('التدخلات الناجحة', '14', '18', false),
                  _buildStatItem('حالات التسلل', '1', '4', false),
                  _buildStatItem('الأخطاء المرتكبة', '9', '15', false),
                ],
              ),
            ),

            const SizedBox(height: 25),
            
            // 🏥 4. إضافة القسم الملكي الجديد (تقرير العيادة الطبية والغيابات) بأيقونة متوهجة لطلب نواف الشامل
            const Text(
              'تقرير العيادة الطبية والغيابات',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // غيابات الهلال
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.healing, color: AppTheme.neonBlue, size: 14), SizedBox(width: 6), Text('نيمار جونيور (رباط صليبي)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))]),
                      SizedBox(height: 6),
                      Row(children: [Icon(Icons.healing, color: AppTheme.neonBlue, size: 14), SizedBox(width: 6), Text('مالك العبدالمنعم (إصابة عضلة)', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo'))]),
                    ],
                  ),
                  // أيقونة نبض قلب طبي نيون متوهجة بالمنتصف
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0x1FFF3B30), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite, color: Color(0xFFFF3B30), size: 22, shadows: [Shadow(color: Color(0xFFFF3B30), blurRadius: 10)]),
                  ),
                  // غيابات النصر
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [Text('أندرسون تاليسكا (تمزق عضلي)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.healing, color: Colors.redAccent, size: 14)]),
                      SizedBox(height: 6),
                      Row(children: [Text('سامي النجعي (تأهيل طبي)', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo')), SizedBox(width: 6), Icon(Icons.healing, color: Colors.redAccent, size: 14)]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(String playerName, String time, IconData icon, Color glowColor, {required bool hasAssist, required String assistName, bool isRedCard = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon == Icons.style) ...[
              Container(
                width: 12,
                height: 16,
                decoration: BoxDecoration(
                  color: isRedCard ? Colors.red : Colors.amber,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [BoxShadow(color: isRedCard ? Colors.red.withValues(alpha: 0.6) : Colors.amber.withValues(alpha: 0.6), blurRadius: 8)],
                ),
              ),
            ] else ...[
              Icon(icon, color: glowColor, size: 16, shadows: [Shadow(color: glowColor.withValues(alpha: 0.4), blurRadius: 6)]),
            ],
            const SizedBox(width: 8),
            Text(playerName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(width: 6),
            Text(time, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        if (hasAssist) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.ice_skating, color: Color(0xFF00B4FF), size: 12),
                const SizedBox(width: 5),
                Text('صناعة: $assistName', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(String label, String homeValue, String awayValue, bool isHomeBetter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: isHomeBetter ? BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.neonBlue, width: 1.2)) : null,
                child: Text(homeValue, style: TextStyle(color: isHomeBetter ? AppTheme.neonBlue : Colors.white70, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: !isHomeBetter ? BoxDecoration(color: const Color(0x26FF3B30), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent, width: 1.2)) : null,
                child: Text(awayValue, style: TextStyle(color: !isHomeBetter ? Colors.redAccent : Colors.white70, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 5,
              width: double.infinity,
              color: Colors.white10,
              child: Row(
                children: [
                  Expanded(flex: int.parse(homeValue.replaceAll('%', '')), child: Container(color: AppTheme.neonBlue)),
                  Expanded(flex: int.parse(awayValue.replaceAll('%', '')), child: Container(color: Colors.redAccent.withValues(alpha: 0.5))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
