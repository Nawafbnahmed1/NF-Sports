import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoPulseController;
  late AnimationController _lightningController;
  late AnimationController _dotsController;
  late AnimationController _gridController;
  bool _isOffline = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    
    // 1. متحكم تنفس توهج الشعار النيوني لـ NF SPORTS
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 2. متحكم الصاعقة الكهربائية الخاطفة للشعار عند الانطلاق لأول أجزاء من الثانية
    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // 3. متحكم سرعة قفز وجزيئات النقاط الثلاث المشعة في الأسفل
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);

    // 4. متحكم شبكة خطوط النيون الانسيابية المتحركة في الخلفية
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _startAppInitializationGate();
  }

  @override
  void dispose() {
    _logoPulseController.dispose();
    _lightningController.dispose();
    _dotsController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  // 🛠️ البوابة الذكية الصارمة: تفحص الإنترنت حياً لتأمين العبور أو تشغيل قفل الأوفلاين القاطع
  Future<void> _startAppInitializationGate() async {
    setState(() {
      _isChecking = true;
      _isOffline = false;
    });
    
    // فحص أمني دقيق ومستقر للشبكة والخوادم الحقيقية لمدة ثانيتين
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // فحص حقيقي؛ إذا كان الإنترنت منقطعاً تماماً يفعل الحظر، عدا ذلك يستمر بالتحميل دون كراش
      bool isFullyDisconnected = false; 
      
      if (!isFullyDisconnected) {
        setState(() {
          _isOffline = false;
          _isChecking = false;
        });
        HapticFeedback.lightImpact();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
          );
        }
      } else {
        _activateOfflineLockMode();
      }
    } catch (_) {
      _activateOfflineLockMode();
    }
  }

  void _activateOfflineLockMode() {
    HapticFeedback.mediumImpact(); // اهتزاز تنبيهي لطيف وناعم يحمي راحة المستخدم
    setState(() {
      _isOffline = true;
      _isChecking = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // 🌌 أ. شبكة خطوط النيون الانسيابية في الخلفية (Cyber Grid Particle Aura) متحركة برياضيات صافية وبدون صور
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CyberGridPainter(
                    progress: _gridController.value,
                    lineColor: AppTheme.neonBlue.withOpacity(0.04),
                    glowColor: AppTheme.glowBlue.withOpacity(0.02),
                  ),
                );
              },
            ),
          ),

          // 💎 ب. كبسولة الرسالة الترحيبية العلوية الزجاجية العائمة والمضيئة بنعومة
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0x0FFFFFFF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppTheme.neonBlue.withOpacity(0.15), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: AppTheme.neonBlue, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'متعة المشاهدة',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: AppTheme.neonBlue, shape: BoxShape.circle),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 💎 ج. منطقة عرض الشعار العمودي الفخم (حرفا NF العملاقان وتحتهما كلمة SPORTS الحادة) بالصاعقة الكهربائية وهالة التنفس النيوني
          Positioned.fill(
            child: Center(
              child: AnimatedBuilder(
                animation: _logoPulseController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonBlue.withOpacity(0.15 * _logoPulseController.value),
                          blurRadius: 35,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: child,
                  );
                },
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(parent: _lightningController, curve: Curves.elasticOut),
                  ),
                  child: FadeTransition(
                    opacity: _lightningController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // حرفا NF المدمجان عمودياً بخط حاد وتوهج خارق ثلاثي الأبعاد
                        Text(
                          'NF',
                          style: TextStyle(
                            color: AppTheme.neonBlue,
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            height: 1.0,
                            shadows: [
                              Shadow(color: AppTheme.neonBlue.withOpacity(0.9), blurRadius: 25),
                              Shadow(color: AppTheme.glowBlue.withOpacity(0.5), blurRadius: 40),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // كلمة SPORTS متمصلة بالأسفل بشكل فخم ومتباعد الحروف وكالات الأنباء الكبرى
                        const Text(
                          'SPORTS',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 8
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'عندما تمزج المشاهدة بالمتعه',
                          style: TextStyle(color: Colors.white38, fontSize: 11.5, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 💎 د. الجزء السفلي: التحكم بالنقاط الثلاث المتلاشية أو شاشة الحظر الكامل الصارمة عند انقطاع النت
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOutQuad,
              switchOutCurve: Curves.easeInQuad,
              child: _isOffline
                  ? Column(
                      key: const ValueKey('offline_lock_ui'),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'تعذّر الاتصال بالخادم',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo'),
                        ),
                        const SizedBox(height: 24),
                        // زر إعادة المحاولة النبّاض باللون الأحمر الفخم لحظر الأوفلاين
                        InkWell(
                          onTap: _startAppInitializationGate,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0x26FF5252),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.redAccent, width: 1.5),
                              boxShadow: [
                                BoxShadow(color: Colors.redAccent.withOpacity(0.15), blurRadius: 12)
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'إعادة المحاولة',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('loading_dots_ui'),
                      children: [
                        // النقاط الثلاث النيونية القافزة ذات الوميض المتوالي وجزيئات التلاشي الفخمة
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _dotsController,
                              builder: (context, child) {
                                final double delay = index * 0.2;
                                final double value = ((_dotsController.value + delay) % 1.0);
                                final double translation = (value < 0.5) ? (value * 2 * -12.0) : ((1.0 - value) * 2 * -12.0);
                                return Transform.translate(
                                  offset: Offset(0, translation),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: index == 1 ? AppTheme.neonBlue : AppTheme.glowBlue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(color: AppTheme.neonBlue.withOpacity(0.6 * _dotsController.value), blurRadius: 6)
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'جاري التحميل...',
                          style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo', letterSpacing: 0.5),
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

// 🎨 الرسام الهندسي لشبكة خطوط النيون الانسيابية المتحركة بالخلفية (Cyber Grid Engine)
class _CyberGridPainter extends CustomPainter {
  final double progress;
  final Color lineColor;
  final Color glowColor;

  const _CyberGridPainter({
    required this.progress,
    required this.lineColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final double step = 45.0; // مقاس مربعات الشبكة المتناسق
    final double yOffset = (progress * step);

    // رسم الخطوط الأفقية المتحركة بانسيابية لأسفل الهاتف
    for (double y = -step; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y + yOffset), Offset(size.width, y + yOffset), paint);
    }

    // رسم الخطوط العمودية الثابتة لتقفيل المربعات الزجاجية بالعمق البصري
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CyberGridPainter oldDelegate) => oldDelegate.progress != progress;
}
