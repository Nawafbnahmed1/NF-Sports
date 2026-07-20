import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class LineupTab extends StatelessWidget {
  const LineupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 15),
          // ⚽ أرضية عشب الملعب الفخمة والملكية المتناسقة مع تصميمك
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 380,
            decoration: BoxDecoration(
              color: const Color(0x1F00B4FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Stack(
              children: [
                // رسم خطوط وعشب الملعب الهندسي بالخلفية
                Positioned.fill(
                  child: CustomPaint(
                    painter: SoccerFieldPainter(),
                  ),
                ),
                // 🌟 شعار تطبيقك المضيء بالنيون في منتصف دائرة الملعب بالملي (مكان دائرتك البرتقالية)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.neonBlue, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonBlue.withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'NF',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
                // توزيع اللاعبين والتقييمات المضيئة (مثال مهاجم صريح)
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: _buildPlayerNode('أويارزابال', '6.8', true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPlayerNode(String name, String rating, bool isTop) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: Colors.white70, size: 20),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.amber, width: 0.8)),
          child: Text(rating, style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// كلاس الرسم الهندسي لخطوط الملعب والعشب بالكامل
class SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // الخطوط الخارجية والمنتصف
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);
    
    // منطقة الجزاء العلوية والسفلية
    canvas.drawRect(Rect.fromLTRB(size.width * 0.2, 0, size.width * 0.8, size.height * 0.18), paint);
    canvas.drawRect(Rect.fromLTRB(size.width * 0.2, size.height * 0.82, size.width * 0.8, size.height), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
