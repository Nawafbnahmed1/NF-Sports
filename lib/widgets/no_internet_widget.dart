import 'dart:math' as math;
import 'package:flutter/material.dart';

class NoInternetWidget extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    // 1️⃣ حركية الدوران السينمائي للهولوغرام الكروي
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // 2️⃣ حركية النبض الضوئي الموجي (تأثير انقطاع الإشارة الرياضية)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // 3️⃣ تأثير التنفس الزجاجي لحدود الكبسولة والزر
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070D14), // عمق كوني داكن وفخم جداً للتطبيق
      body: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _pulseController, _glowController]),
        builder: (context, child) {
          return Stack(
            children: [
              // ✨ تأثير هالة النيون المحيطية المخفية التي تتنفس على أطراف الشاشة
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    radialGradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        Colors.blue.withOpacity(0.02 * _pulseController.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🔮 الهولوغرام الكروي المطور (كرة مستقيمة ومحاطة بحلقات ليزر متقاطعة ودوارة)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // الحلقة الخارجية المتوهجة (حلقة الطاقة المكسورة)
                          Transform.rotate(
                            angle: _rotationController.value * 2 * math.pi,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3 * _pulseController.value),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          // الحلقة العمودية المتقاطعة لإعطاء عمق ثلاثي الأبعاد هندسي (3D Wireframe)
                          Transform.rotate(
                            angle: -_rotationController.value * 2 * math.pi,
                            child: Transform(
                              transform: Matrix4.identity()..setEntry(3, 2, 0.002)..rotateY(math.pi / 3),
                              alignment: Alignment.center,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.cyan.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // أيقونة الكرة المركزية المستقبلية النبضية
                          Icon(
                            Icons.sports_soccer_rounded,
                            size: 75,
                            color: Colors.blue.lerp(Colors.cyan, _pulseController.value)?.withOpacity(0.85),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      
                      // ⚠️ نص التنبيه الذي طلبته بحرفيته التامة ليلتزم به التطبيق
                      const Text(
                        '⚠️تعذر الاتصال',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'Tajawal', // يدعم فخامة الخطوط العربية المنسقة
                          shadows: [
                            Shadow(color: Colors.blue, blurRadius: 12, offset: Offset(0, 0)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      
                      // النص الإرشادي الثاني الذي طلبته ليرشد القارئ وينبهه
                      const Text(
                        'تأكد من اتصالك بالإنترنت وحاول مره أخرى',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFC0C6CD), // رمادي فضي أنيق جداً وسينمائي
                          height: 1.5,
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 45),
                      
                      // 🔘 المربع الفخم جداً المضيء (إعادة المحاولة) مع مؤثر ليزري مرن عند اللمس
                      GestureDetector(
                        onTapDown: (_) => setState(() => _isHovered = true),
                        onTapUp: (_) {
                          setState(() => _isHovered = false);
                          widget.onRetry();
                        },
                        onTapCancel: () => setState(() => _isHovered = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 56,
                          transform: Matrix4.identity()..scale(_isHovered ? 0.96 : 1.0), // انضغاط فيزيائي ممتع عند الضغط
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF0E5CAD).withOpacity(0.9), // أزرق النيون الفخم المتناسق مع كروتك
                                const Color(0xFF00A3FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00A3FF).withOpacity(_isHovered ? 0.3 : 0.5 * _glowController.value),
                                blurRadius: _isHovered ? 12 : 22,
                                spreadRadius: _isHovered ? 1 : 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.cyan.withOpacity(0.6),
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'إعادة المحاولة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
