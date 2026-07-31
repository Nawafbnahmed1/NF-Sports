import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'package:glass_kit/glass_kit.dart';
import '../widgets/glass_card.dart';

class UserLineupPrediction {
  final String positionName;
  final double dx;
  final double dy;
  String playerName;
  String playerNumber;
  Color jerseyColor;
  bool isPlaced;

  UserLineupPrediction({
    required this.positionName,
    required this.dx,
    required this.dy,
    this.playerName = '',
    this.playerNumber = '',
    this.jerseyColor = AppTheme.neonBlue,
    this.isPlaced = false,
  });
}

class MatchDetailScreen extends StatefulWidget {
  final String team1;
  final String team2;

  const MatchDetailScreen({super.key, required this.team1, required this.team2});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _CyberPitchPainter extends CustomPainter {
  final Color linesColor;
  final double pulseValue;

  _CyberPitchPainter({required this.linesColor, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = linesColor.withOpacity(0.12 + (pulseValue * 0.08))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 45, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2, paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, 0, size.width * 0.6, 50), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.35, 0, size.width * 0.3, 18), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, size.height - 50, size.width * 0.6, 50), paint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.35, size.height - 18, size.width * 0.3, 18), paint);
  }

  @override
  bool shouldRepaint(covariant _CyberPitchPainter oldDelegate) => oldDelegate.pulseValue != pulseValue;
}
class _MatchDetailScreenState extends State<MatchDetailScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _marqueeController;

  final List<UserLineupPrediction> _predictedLineup = [
    UserLineupPrediction(positionName: 'GK', dx: 0.5, dy: 0.88),
    UserLineupPrediction(positionName: 'CB1', dx: 0.32, dy: 0.72),
    UserLineupPrediction(positionName: 'CB2', dx: 0.68, dy: 0.72),
    UserLineupPrediction(positionName: 'LB', dx: 0.12, dy: 0.65),
    UserLineupPrediction(positionName: 'RB', dx: 0.88, dy: 0.65),
    UserLineupPrediction(positionName: 'CM', dx: 0.5, dy: 0.48),
    UserLineupPrediction(positionName: 'LCM', dx: 0.25, dy: 0.45),
    UserLineupPrediction(positionName: 'RCM', dx: 0.75, dy: 0.45),
    UserLineupPrediction(positionName: 'ST', dx: 0.5, dy: 0.18),
    UserLineupPrediction(positionName: 'LW', dx: 0.20, dy: 0.22),
    UserLineupPrediction(positionName: 'RW', dx: 0.80, dy: 0.22),
  ];

  int? _activePositionIndex;
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _playerNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Color _selectedJerseyColor = AppTheme.neonBlue;
  bool _isOfficialLineupReleased = false;
  bool _showTutorial = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _marqueeController.dispose();
    _playerNameController.dispose();
    _playerNumberController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _openMechaBench(int index) {
    if (_isOfficialLineupReleased) return;
    HapticFeedback.lightImpact();
    setState(() {
      _activePositionIndex = index;
      _playerNameController.text = _predictedLineup[index].playerName;
      _playerNumberController.text = _predictedLineup[index].playerNumber;
      if (_predictedLineup[index].isPlaced) {
        _selectedJerseyColor = _predictedLineup[index].jerseyColor;
      }
    });
  }

  void _submitPredictionToCloud() {
    if (_userNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة اسمك أولاً لحفظ التشكيلة! ⚠️', style: TextStyle(fontFamily: 'Cairo'))),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال تشكيلتك يا ${_userNameController.text.trim()}! في انتظار مطابقة الواقع... 🏆', style: const TextStyle(fontFamily: 'Cairo'))),
    );
  }
  @override
  Widget build(BuildContext context) {
    final colors = [Colors.cyanAccent, AppTheme.neonBlue, Colors.amberAccent, Colors.redAccent];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تفاصيل اللقاء',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GlassCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle),
                              child: const Icon(Icons.shield, color: Colors.white60, size: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(widget.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text('- : -', style: TextStyle(color: Colors.white24, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0x0AFFFFFF), borderRadius: BorderRadius.circular(6)),
                            child: const Text('في انتظار البداية', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle),
                              child: const Icon(Icons.shield, color: Colors.white60, size: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(widget.team2, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showTutorial && !_isOfficialLineupReleased)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showTutorial ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0x1F00B4FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.neonBlue.withOpacity(0.2)),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Icon(Icons.lightbulb_outline, color: AppTheme.neonBlue, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            '💡 طريقة توقع تشكيلة المدرب : اضغط على مركز في الملعب، ثم اختر الروبوت من دكة الاحتياط، واكتب اسم اللاعب ورقمه لتبني خطتك الأسطورية!',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Cairo', height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AspectRatio(
                aspectRatio: 0.72,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF040A14),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10, width: 1.5),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _CyberPitchPainter(linesColor: AppTheme.neonBlue, pulseValue: _pulseController.value),
                            );
                          },
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: List.generate(_predictedLineup.length, (index) {
                              final p = _predictedLineup[index];
                              final double posX = (p.dx * constraints.maxWidth) - 20;
                              final double posY = (p.dy * constraints.maxHeight) - 25;
                              final bool isActive = _activePositionIndex == index;

                              return Positioned(
                                left: posX,
                                top: posY,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _showTutorial = false);
                                    _openMechaBench(index);
                                  },
                                  child: Column(
                                    children: [
                                      AnimatedBuilder(
                                        animation: _pulseController,
                                        builder: (context, child) {
                                          return Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: p.isPlaced ? p.jerseyColor.withOpacity(0.2) : (isActive ? AppTheme.neonBlue.withOpacity(0.3) : const Color(0x1AFFFFFF)),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: p.isPlaced ? p.jerseyColor : (isActive ? Colors.white : AppTheme.neonBlue.withOpacity(0.4)),
                                                width: isActive ? 2.0 : 1.5,
                                              ),
                                              boxShadow: (p.isPlaced || isActive)
                                                  ? [
                                                      BoxShadow(color: (p.isPlaced ? p.jerseyColor : AppTheme.neonBlue).withOpacity(0.4 * _pulseController.value), blurRadius: 10),
                                                    ]
                                                  : null,
                                            ),
                                            child: child,
                                          );
                                        },
                                        child: Icon(p.isPlaced ? Icons.android_rounded : Icons.add_moderator, size: 18, color: p.isPlaced ? Colors.white : Colors.white38),
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                                        child: Text(
                                          p.isPlaced ? '${p.playerNumber}. ${p.playerName}' : p.positionName,
                                          maxLines: 1,
                                          style: TextStyle(color: p.isPlaced ? Colors.white : Colors.white54, fontSize: p.isPlaced ? 9 : 8, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      if (_activePositionIndex != null && !_isOfficialLineupReleased)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: GlassCard(
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text('إعداد مركز: ${_predictedLineup[_activePositionIndex!].positionName}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 18),
                                        onPressed: () => setState(() => _activePositionIndex = null),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _playerNameController,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                          decoration: InputDecoration(
                                            hintText: 'اسم اللاعب التوقعي',
                                            hintStyle: const TextStyle(color: Colors.white24, fontSize: 11, fontFamily: 'Cairo'),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            filled: true,
                                            fillColor: Colors.black26,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          controller: _playerNumberController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                          decoration: InputDecoration(
                                            hintText: 'الرقم',
                                            hintStyle: const TextStyle(color: Colors.white24, fontSize: 11, fontFamily: 'Cairo'),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                            filled: true,
                                            fillColor: Colors.black26,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Row(
                                        children: colors.map((color) {
                                          return GestureDetector(
                                            onTap: () => setState(() => _selectedJerseyColor = color),
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: _selectedJerseyColor == color ? Colors.white : Colors.transparent, width: 1.5),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonBlue, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                        onPressed: () {
                                          if (_playerNameController.text.trim().isNotEmpty) {
                                            setState(() {
                                              final p = _predictedLineup[_activePositionIndex!];
                                              p.playerName = _playerNameController.text.trim();
                                              p.playerNumber = _playerNumberController.text.trim().isEmpty ? '10' : _playerNumberController.text.trim();
                                              p.jerseyColor = _selectedJerseyColor;
                                              p.isPlaced = true;
                                              _activePositionIndex = null;
                                            });
                                            HapticFeedback.mediumImpact();
                                          }
                                        },
                                        child: const Text('تأكيد التمركز', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (!_isOfficialLineupReleased)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  borderRadius: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _userNameController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'اكتب اسمك كمدرب (إجباري)',
                              hintStyle: const TextStyle(color: Colors.white24, fontSize: 11, fontFamily: 'Cairo'),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              filled: true,
                              fillColor: Colors.black26,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _submitPredictionToCloud,
                          child: const Text('إرسال الخطة', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 28,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AnimatedBuilder(
                    animation: _marqueeController,
                    builder: (context, child) {
                      return FractionalTranslation(
                        translation: Offset(1.0 - (_marqueeController.value * 2.0), 0.0),
                        child: child,
                      );
                    },
                    child: Center(
                      child: Text(
                        'NF SPORTS PREMIUM PARTNER ADVERTISING PANEL • LIVE SPORTS METRIC SYNCED DATA • BROADCASTING 2100',
                        maxLines: 1,
                        style: TextStyle(color: AppTheme.neonBlue.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text('إحصائيات المواجهة اللحظية', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: GlassCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('45%', style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('الاستحواذ الكلي', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo')),
                          Text('55%', style: TextStyle(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold)),
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
                            children: const [
                              Expanded(flex: 45, child: ColoredBox(color: Colors.cyanAccent)),
                              Expanded(flex: 55, child: ColoredBox(color: AppTheme.neonBlue)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('8', style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('إجمالي التسديدات', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo')),
                          Text('12', style: TextStyle(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold)),
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
                            children: const [
                              Expanded(flex: 8, child: ColoredBox(color: Colors.cyanAccent)),
                              Expanded(flex: 12, child: ColoredBox(color: AppTheme.neonBlue)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text('العيادة الطبية والغيابات', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: GlassCard(
                borderRadius: 20,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, _) {
                          return Icon(Icons.monitor_heart_rounded, color: Colors.redAccent.withOpacity(0.2 + (_pulseController.value * 0.4)), size: 36);
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'لا توجد غيابات حية أو إصابات مسجلة حالياً لعناصر الفريقين',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
