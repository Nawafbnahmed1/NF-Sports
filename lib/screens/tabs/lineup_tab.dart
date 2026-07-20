import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';

class LineupTab extends StatefulWidget {
  const LineupTab({super.key});

  @override
  State<LineupTab> createState() => _LineupTabState();
}

class _LineupTabState extends State<LineupTab> {
  bool _isHomeTeamSelected = true; // true يعرض الهلال، false يعرض النصر

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // 📊 1. أزرار التحكم العلوية الفخمة بالهوية المضيئة للتنقل بين الفريقين (RTL)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () { setState(() { _isHomeTeamSelected = true; }); },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isHomeTeamSelected ? const Color(0x3300B4FF) : const Color(0x990A1220),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _isHomeTeamSelected ? AppTheme.neonBlue : Colors.white10, width: 2),
                          boxShadow: _isHomeTeamSelected ? [const BoxShadow(color: Color(0x4D00B4FF), blurRadius: 10)] : null,
                        ),
                        child: const Center(
                          child: Text('نادي الهلال', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: () { setState(() { _isHomeTeamSelected = false; }); },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isHomeTeamSelected ? const Color(0x33FF3B30) : const Color(0x990A1220),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: !_isHomeTeamSelected ? Colors.redAccent : Colors.white10, width: 2),
                          boxShadow: !_isHomeTeamSelected ? [const BoxShadow(color: Color(0x4DFF3B30), blurRadius: 10)] : null,
                        ),
                        child: const Center(
                          child: Text('نادي النصر', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🏟️ 2. أرضية ملعب عشبية ملكية فخمة مع شعار تطبيقك المضيء النابض بالمنتصف وتغيير اللاعبين تلقائياً
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xCC0D1B2A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _isHomeTeamSelected ? AppTheme.neonBlue.withValues(alpha: 0.3) : Colors.redAccent.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _SoccerFieldPainter(isBlue: _isHomeTeamSelected),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: _isHomeTeamSelected ? const Color(0x3300B4FF) : const Color(0x33FF3B30),
                        shape: BoxShape.circle,
                        border: Border.all(color: _isHomeTeamSelected ? AppTheme.neonBlue : Colors.redAccent, width: 2),
                        boxShadow: [
                          BoxShadow(color: _isHomeTeamSelected ? AppTheme.neonBlue.withValues(alpha: 0.6) : Colors.redAccent.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 2),
                        ],
                      ),
                      child: const Center(child: Text('NF', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ),

                  // عرض لاعبي الفريق المختار بالدقة الحية الحين بالأرقام الإنجليزية الموحدة
                  if (_isHomeTeamSelected) ...[
                    _positionPlayer('ميتروفيتش', '8.5', 0.5, 0.12),
                    _positionPlayer('سالم الدوسري', '7.9', 0.15, 0.35),
                    _positionPlayer('مالكوم', '8.2', 0.5, 0.35),
                    _positionPlayer('نيفيز', '7.4', 0.85, 0.35),
                    _positionPlayer('ساكا', '6.9', 0.3, 0.55),
                    _positionPlayer('كنو', '7.1', 0.7, 0.55),
                    _positionPlayer('الشهراني', '6.8', 0.12, 0.75),
                    _positionPlayer('البليحي', '7.5', 0.38, 0.75),
                    _positionPlayer('كوليبالي', '8.0', 0.62, 0.75),
                    _positionPlayer('سعود', '7.8', 0.88, 0.75),
                    _positionPlayer('بونو', '8.3', 0.5, 0.9),
                  ],
                  if (!_isHomeTeamSelected) ...[
                    _positionPlayer('رونالدو', '9.1', 0.5, 0.12),
                    _positionPlayer('ماني', '7.8', 0.15, 0.35),
                    _positionPlayer('تاليسكا', '8.4', 0.5, 0.35),
                    _positionPlayer('غريب', '7.2', 0.85, 0.35),
                    _positionPlayer('أوتافيو', '8.0', 0.3, 0.55),
                    _positionPlayer('الخيبري', '7.0', 0.7, 0.55),
                    _positionPlayer('تيلليس', '7.3', 0.12, 0.75),
                    _positionPlayer('لابورت', '8.2', 0.38, 0.75),
                    _positionPlayer('لاجامي', '6.9', 0.62, 0.75),
                    _positionPlayer('الغنام', '7.6', 0.88, 0.75),
                    _positionPlayer('العقيدي', '7.5', 0.5, 0.9),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🪑 3. كارد دكة البدلاء والاحتياط المتكاملة الفاخرة والمنفصلة لكل فريق تلقائياً
            Align(
              alignment: Alignment.topRight,
              child: Text(
                _isHomeTeamSelected ? 'بدلاء نادي الهلال' : 'بدلاء نادي النصر',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              child: Column(
                children: _isHomeTeamSelected ? [
                  _buildSubRow('الحمدان (14)', 'كنعاني (7)'),
                  const SizedBox(height: 10),
                  _buildSubRow('البريك (2)', 'الشهري (11)'),
                  const SizedBox(height: 10),
                  _buildSubRow('الفرج (7)', 'العويس (21)'),
                ] : [
                  _buildSubRow('غريب (29)', 'الخيبري (17)'),
                  const SizedBox(height: 10),
                  _buildSubRow('العقيدي (33)', 'الحسن (19)'),
                  const SizedBox(height: 10),
                  _buildSubRow('فتيل (4)', 'مادو (78)'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 👔 4. كارد طاقم التدريب الفني والمدربين مستقل لكل فريق وبحروف ضخمة عريضة
            GlassCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isHomeTeamSelected ? 'المدرب: جورجي خيسوس' : 'المدرب: ستيفانو بيولي',
                    style: TextStyle(
                      color: _isHomeTeamSelected ? AppTheme.neonBlue : Colors.redAccent, 
                      fontSize: 13, 
                      fontWeight: FontWeight.bold, 
                      fontFamily: 'Cairo'
                    ),
                  ),
                  const Text('طاقم التدريب الفني', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ودجيت بناء وتوزيع اللاعبين بالخط العريض ومربعات التقييم الذهبية المضيئة بالملي
  Widget _positionPlayer(String name, String rating, double xRatio, double yRatio) {
    return Positioned(
      left: 0,
      right: 0,
      top: 380 * yRatio - 25,
      child: Align(
        alignment: Alignment(xRatio * 2 - 1, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 2),
            // مربع التقييم الذهبي المتوهج المستقل تحت اسم كل لاعب
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0x33FFD700),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFFFFD700), width: 0.8),
              ),
              child: Text(
                rating,
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubRow(String player1, String player2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(player1, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        const Icon(Icons.sync, color: Colors.white24, size: 16),
        Text(player2, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ],
    );
  }
}

// الرسام الهندسي لخطوط عشب الملعب بدقة فائقة بالخلفية مع توهج نيون تفاعلي حسب اختيار نواف
class _SoccerFieldPainter extends CustomPainter {
  final bool isBlue;
  _SoccerFieldPainter({required this.isBlue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isBlue ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // الخط الخارجي للملعب
    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), paint);
    // خط المنتصف
    canvas.drawLine(Offset(10, size.height / 2), Offset(size.width - 10, size.height / 2), paint);
    // دائرة المنتصف
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 55, paint);
    // منطقة الجزاء العلوية
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, 10, size.width * 0.6, 60), paint);
    // منطقة الجزاء السفلية
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, size.height - 70, size.width * 0.6, 60), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
