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

            // 📊 2. المستطيل الضخم المنقسم هندسياً إلى قسمين (اليمين للهلال واليسار للنصر)
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 24,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👉 الجانب الأيمن (أحداث الهلال منظم تصاعدياً من الأسفل للأعلى بالأرقام الإنجليزية الموحدة)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(child: Text('الهلال', style: TextStyle(color: AppTheme.neonBlue, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                          const Divider(color: Colors.white10, height: 16),
                          
                          // الحدث الأخير بالأعلى (الدقيقة 81)
                          _buildEventItem('مالكوم', '81\'', Icons.style, Colors.amber, hasAssist: false, assistName: ''),
                          const SizedBox(height: 14),
                          // الحدث الأوسط (الدقيقة 68)
                          _buildEventItem('سالم الدوسري', '68\'', Icons.sports_soccer, Colors.green, hasAssist: true, assistName: 'مالكوم'),
                          const SizedBox(height: 14),
                          // الحدث الأول بالأسفل (الدقيقة 42)
                          _buildEventItem('ميتروفيتش', '42\'', Icons.sports_soccer, Colors.green, hasAssist: true, assistName: 'نيفيز'),
                        ],
                      ),
                    ),
                    
                    // 🛑 خط الفصل الهندسي المضيء بالمنتصف
                    const VerticalDivider(color: Colors.white10, width: 20, thickness: 1.2),
                    // 👈 الجانب الأيسر (أحداث النصر منظم تصاعدياً من الأسفل للأعلى بالأرقام الإنجليزية الموحدة)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Center(child: Text('النصر', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                          const Divider(color: Colors.white10, height: 16),
                          
                          // الحدث الأخير بالأعلى (الدقيقة 89 كرت أحمر متوهج)
                          _buildEventItem('لابورت', '89\'', Icons.style, Colors.red, hasAssist: false, assistName: '', isRedCard: true),
                          const SizedBox(height: 14),
                          // الحدث الأوسط (الدقيقة 55 هدف الدون رونالدو)
                          _buildEventItem('رونالدو', '55\'', Icons.sports_soccer, Colors.green, hasAssist: true, assistName: 'ماني'),
                          const SizedBox(height: 14),
                          // الحدث الأول بالأسفل (الدقيقة 30 كرت أصفر نيون)
                          _buildEventItem('أوتافيو', '30\'', Icons.style, Colors.amber, hasAssist: false, assistName: ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🎨 دالة بناء مجريات المباراة المنقسمة الملكية بأيقونات الكرة والجزمة والبطاقات الملوّنة المضيئة
  Widget _buildEventItem(String playerName, String time, IconData icon, Color glowColor, {required bool hasAssist, required String assistName, bool isRedCard = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🟨 🟥 إذا كان الحدث بطاقة ملونة، يرسم مربع نيون مستطيل متوهج وصغير بدلاً من الأيقونة العادية
            if (icon == Icons.style) ...[
              Container(
                width: 12,
                height: 16,
                decoration: BoxDecoration(
                  color: isRedCard ? Colors.red : Colors.amber,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: isRedCard ? Colors.red.withValues(alpha: 0.6) : Colors.amber.withValues(alpha: 0.6),
                      blurRadius: 8,
                    )
                  ],
                ),
              ),
            ] else ...[
              // ⚽ إذا كان هدفاً، يحقن أيقونة كرة القدم النيون الخضراء المتوهجة حية الحين
              Icon(icon, color: glowColor, size: 16, shadows: [Shadow(color: glowColor.withValues(alpha: 0.4), blurRadius: 6)]),
            ],
            const SizedBox(width: 8),
            // اسم اللاعب الأساسي للحدث بخط Cairo الضخم العريض الواضح
            Text(
              playerName,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(width: 6),
            // توثيق وقت الدقيقة بنيون أزرق مشع وأرقام إنجليزية موحدة
            Text(
              time,
              style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // 👟 إذا كان الهدف يحمل أسيست وصناعة، يحقن فوراً أيقونة الحذاء/الجزمة النيون المشع بالأسفل لتوثيق الصانع
        if (hasAssist) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.ice_skating, color: Color(0xFF00B4FF), size: 12), // أيقونة الجزمة/الحذاء الرياضي المضيء بالأزرق النيون للأسيست
                const SizedBox(width: 5),
                Text(
                  'صناعة: $assistName',
                  style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
