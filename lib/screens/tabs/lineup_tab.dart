import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';

class LineupTab extends StatelessWidget {
  const LineupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xCC0D1B2A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10, width: 1.5),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _SoccerFieldPainter(),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0x3300B4FF),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.neonBlue, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonBlue.withValues(alpha: 0.6),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'NF',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ),
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
              ),
            ),
            const SizedBox(height: 20),
            GlassCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 18,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('المدرب: خيسوس', style: TextStyle(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  Text('طاقم التدريب الفني', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  Text('المدرب: بيولي', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.topRight,
              child: Text('دكة البدلاء والاحتياط', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              child: Column(
                children: [
                  _buildSubRow('الحمدان (14)', 'غريب (29)'),
                  const SizedBox(height: 10),
                  _buildSubRow('كنعاني (7)', 'الخيبري (17)'),
                  const SizedBox(height: 10),
                  _buildSubRow('البريك (2)', 'العقيدي (33)'),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

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
            Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: const Color(0x33FFD700), borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFFFFD700), width: 0.8)),
              child: Text(rating, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubRow(String homeSub, String awaySub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(homeSub, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        const Icon(Icons.sync, color: Colors.white24, size: 16),
        Text(awaySub, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ],
    );
  }
}

class _SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), paint);
    canvas.drawLine(Offset(10, size.height / 2), Offset(size.width - 10, size.height / 2), paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 55, paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, 10, size.width * 0.6, 60), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, size.height - 70, size.width * 0.6, 60), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
