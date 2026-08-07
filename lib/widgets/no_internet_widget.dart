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
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF070D14),
        body: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController, _glowController]),
          builder: (context, child) {
            return Stack(
              children: [
                // ✨ الهالة المحيطية
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                        colors: [
                          Color(0x0500A3FF),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 🏷️ علامة NF SPORTS النيونية (إضافة جديدة)
                Positioned(
                  top: 60,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black26,
                    ),
                    child: const Text(
                      'NF SPORTS',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [Shadow(color: Colors.cyan, blurRadius: 6)],
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
                        // 🔮 الهولوغرام الكروي (مع إصلاح الخطأ الرئيسي وتأثير Hero للانتقال السلس)
                        Hero(
                          tag: 'internet_globe',
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
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
                              // ✅ إصلاح الخطأ: استخدام Color.lerp الصحيح
                              Icon(
                                Icons.sports_soccer_rounded,
                                size: 75,
                                color: Color.lerp(Colors.blue, Colors.cyan, _pulseController.value)?.withOpacity(0.85),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        const Text(
                          '⚠️ تعذر الاتصال',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                            shadows: [
                              Shadow(color: Colors.blue, blurRadius: 12, offset: Offset(0, 0)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        
                        const Text(
                          'تأكد من اتصالك بالإنترنت وحاول مره أخرى',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFC0C6CD),
                            height: 1.5,
                            fontFamily: 'Tajawal',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 45),
                        
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
                            transform: Matrix4.identity()..scale(_isHovered ? 0.96 : 1.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0E5CAD),
                                  Color(0xFF00A3FF),
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
      ),
    );
  }
}
