import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/no_internet_widget.dart';

class HighlightMediaModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String source;
  final DateTime publishedAt;

  const HighlightMediaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.source,
    required this.publishedAt,
  });

  factory HighlightMediaModel.fromMap(Map<String, dynamic> map) {
    return HighlightMediaModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title_ar'] ?? map['title'] ?? '').toString(),
      description: (map['description_ar'] ?? map['description'] ?? 'أبرز لقطات وأهداف المباراة حياً ومباشرة.').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      videoUrl: (map['video_url'] ?? '').toString(),
      source: (map['source'] ?? 'NF Sports').toString(),
      publishedAt: DateTime.parse(map['published_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late AnimationController _pulseController;
  late AnimationController _marqueeController;
  final Set<String> _readHighlightsMemory = <String>{};
  
  final Map<String, int> _baseViewsMap = {};
  final Map<String, int> _timeOffsetMap = {};
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
    super.dispose();
  }

  // 📡 محرك التمويه التفاعلي الذكي
  String _generateStealthViews(HighlightMediaModel media) {
    final String key = media.id.isNotEmpty ? media.id : media.videoUrl;
    
    if (!_baseViewsMap.containsKey(key)) {
      final int seed = key.hashCode.abs();
      _baseViewsMap[key] = 200 + (seed % 190);
      _timeOffsetMap[key] = 2 + (seed % 5);
    }

    final int baseViews = _baseViewsMap[key]!;
    final int minutesInterval = _timeOffsetMap[key]!;
    
    final duration = DateTime.now().difference(media.publishedAt);
    final int passedIntervals = duration.inMinutes ~/ minutesInterval;
    
    int growth = 0;
    if (passedIntervals > 0) {
      final int cryptoSeed = key.hashCode.abs() + passedIntervals;
      final int stepValue = 100 + (cryptoSeed % 120); 
      growth = passedIntervals * stepValue;
    }

    final int totalViews = baseViews + growth;

    if (totalViews >= 1000) {
      return '${(totalViews / 1000).toStringAsFixed(1)}K';
    }
    return '$totalViews';
  }

  String _getFormatedTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) return 'الآن';
    if (duration.inMinutes < 60) return 'منذ ${duration.inMinutes} د';
    if (duration.inHours < 24) return 'قبل ${duration.inHours} ساعة';
    return 'قبل ${duration.inDays} يوم';
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {});
    }
  }

  void _openFullscreenVideoPlayer(BuildContext context, HighlightMediaModel media) {
    HapticFeedback.vibrate();
    if (mounted) {
      setState(() {
        _readHighlightsMemory.add(media.videoUrl);
      });
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    double localVolume = 0.8;
    double localBrightness = 0.6;
    double currentProgress = 0.3;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Player",
      barrierColor: Colors.black.withOpacity(0.95),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setPlayerState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            if (media.imageUrl.isNotEmpty)
                              Positioned.fill(child: Image.network(media.imageUrl, fit: BoxFit.cover)),
                            Container(color: Colors.black54),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: FadeTransition(
                                opacity: _pulseController,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3)),
                                  ),
                                  child: const Text(
                                    "NF SPORTS",
                                    style: TextStyle(color: Color(0xFF00A3FF), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF00A3FF), width: 1),
                                ),
                                child: const Text("1080p HD", style: TextStyle(color: Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 36),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      setPlayerState(() {
                                        currentProgress = (currentProgress - 0.05).clamp(0.0, 1.0);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 40),
                                  const Icon(Icons.play_arrow_rounded, color: Color(0xFF00A3FF), size: 64),
                                  const SizedBox(width: 40),
                                  IconButton(
                                    icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 36),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      setPlayerState(() {
                                        currentProgress = (currentProgress + 0.05).clamp(0.0, 1.0);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setPlayerState(() {
                                localBrightness = (localBrightness - details.primaryDelta! / 200).clamp(0.0, 1.0);
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: localBrightness < 0.5
                                  ? const Icon(Icons.brightness_low, color: Colors.white24)
                                  : const Icon(Icons.brightness_high, color: Color(0xFF00A3FF)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setPlayerState(() {
                                localVolume = (localVolume - details.primaryDelta! / 200).clamp(0.0, 1.0);
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: localVolume == 0
                                  ? const Icon(Icons.volume_off, color: Colors.white24)
                                  : const Icon(Icons.volume_up, color: Color(0xFF00A3FF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.2)),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(Icons.pause_circle_filled, color: Color(0xFF00A3FF), size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              media.title,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.download_for_offline, color: Color(0xFF00A3FF), size: 24),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('جاري التحميل...', style: TextStyle(fontFamily: 'Cairo'))),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 24),
                            onPressed: () {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: StreamBuilder(
          stream: supabase.from('highlights').stream(primaryKey: ['id']).order('published_at', ascending: false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF00A3FF)));
            }
            if (snapshot.hasError) {
              return const Center(child: Text("تعذر جلب البيانات الحالية", style: TextStyle(color: Colors.white24, fontFamily: 'Cairo')));
            }
            
            final List<dynamic> rawData = snapshot.data ?? [];
            final List<HighlightMediaModel> highlightsList = rawData.map((e) => HighlightMediaModel.fromMap(e as Map<String, dynamic>)).toList();

            if (highlightsList.isEmpty) {
              return const Center(child: Text("لا توجد لقطات متوفرة حالياً", style: TextStyle(color: Colors.white38, fontFamily: 'Cairo')));
            }
            return RefreshIndicator(
              color: const Color(0xFF00A3FF),
              backgroundColor: const Color(0xFF0A1220),
              strokeWidth: 3,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          itemCount: highlightsList.length,
                          itemBuilder: (context, i) {
                            final bool isRead = _readHighlightsMemory.contains(highlightsList[i].videoUrl);

                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                _openFullscreenVideoPlayer(context, highlightsList[i]);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 14),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: isRead ? Colors.white24 : const Color(0xFF00A3FF), width: 2),
                                        boxShadow: !isRead ? [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.3), blurRadius: 6)] : null,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: highlightsList[i].imageUrl.isNotEmpty
                                            ? Image.network(highlightsList[i].imageUrl, fit: BoxFit.cover)
                                            : Container(color: AppTheme.surfaceColor, child: const Icon(Icons.play_circle_outline, color: Color(0xFF00A3FF))),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.play_arrow, size: 10, color: isRead ? Colors.white24 : const Color(0xFF00A3FF).withOpacity(0.7)),
                                        const SizedBox(width: 2),
                                        Text(
                                          _generateStealthViews(highlightsList[i]),
                                          style: TextStyle(color: isRead ? Colors.white24 : Colors.white60, fontSize: 9.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // 🛸 مستطيل الإعلانات الأزرق الفاخر (تم تكبيره وتعديل النص لأبيض مع أزرق)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        height: 62, // ✅ تم تكبير الحجم
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16), // ✅ زيادة انحناء الحواف
                          border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00A3FF).withOpacity(0.12),
                              blurRadius: 10,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedBuilder(
                            animation: _marqueeController,
                            builder: (context, child) {
                              return FractionalTranslation(
                                translation: Offset(-1.0 + (_marqueeController.value * 2.0), 0.0),
                                child: Center(
                                  child: Text(
                                    '⚽ NF SPORTS HIGHLIGHTS 🎬', 
                                    maxLines: 1,
                                    style: GoogleFonts.cairo(
                                      color: Colors.white, // ✅ نص أبيض
                                      fontSize: 16, // ✅ تم تكبير حجم النص
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(color: const Color(0xFF00A3FF).withOpacity(0.6), blurRadius: 8) // ✅ توهج أزرق
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0x1A00A3FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.2), width: 1),
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            FadeTransition(
                              opacity: _pulseController,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 8, spreadRadius: 2)],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'أحدث الملخصات والأهداف',
                              style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                            ),
                            const Spacer(),
                            const Text("LIVE", style: TextStyle(color: Color(0xFF00A3FF), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: highlightsList.length,
                      itemBuilder: (context, index) {
                        final media = highlightsList[index];
                        return index == 0
                            ? _buildMainHighlightCard(context, media)
                            : _buildSubHighlightCard(context, media);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainHighlightCard(BuildContext context, HighlightMediaModel media) {
    final bool isRead = _readHighlightsMemory.contains(media.videoUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isRead ? 0.7 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: !isRead ? [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.12), blurRadius: 16)] : null,
          ),
          child: GlassCard(
            padding: EdgeInsets.zero,
            borderRadius: 24,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 155,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: media.imageUrl.isNotEmpty
                            ? Image.network(media.imageUrl, fit: BoxFit.cover)
                            : Container(color: Colors.black26, child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 48))),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.2)),
                        ),
                        child: const Text(
                          "NF SPORTS",
                          style: TextStyle(color: Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: FadeTransition(
                          opacity: _pulseController,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                              border: Border.all(color: isRead ? Colors.white38 : const Color(0xFF00A3FF), width: 2),
                              boxShadow: !isRead ? [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.4), blurRadius: 12)] : null,
                            ),
                            child: Icon(Icons.play_arrow_rounded, color: isRead ? Colors.white38 : const Color(0xFF00A3FF), size: 36),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF00A3FF), width: 1)),
                        child: const Text("HD", style: TextStyle(color: Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          media.title,
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isRead ? Colors.white38 : Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.white10 : const Color(0x1A00A3FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isRead ? Colors.white24 : const Color(0xFF00A3FF), width: 1.5),
                            ),
                            child: InkWell(
                              onTap: () => _openFullscreenVideoPlayer(context, media),
                              borderRadius: BorderRadius.circular(10),
                              child: const Center(
                                child: Text('شاهد الملخص', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ),
                            ),
                          ),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Icon(Icons.play_arrow, color: Color(0xFF00A3FF), size: 13),
                              const SizedBox(width: 4),
                              Text(
                                _generateStealthViews(media),
                                style: TextStyle(color: isRead ? Colors.white24 : Colors.white60, fontSize: 10.5, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubHighlightCard(BuildContext context, HighlightMediaModel media) {
    final bool isRead = _readHighlightsMemory.contains(media.videoUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isRead ? 0.75 : 1.0,
        child: GlassCard(
          padding: const EdgeInsets.all(11),
          borderRadius: 20,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Stack(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: media.imageUrl.isNotEmpty
                          ? Image.network(media.imageUrl, fit: BoxFit.cover)
                          : Container(color: Colors.black26, child: const Center(child: Icon(Icons.image, color: Colors.white10, size: 28))),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                      child: const Text("NF", style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                          border: Border.all(color: isRead ? Colors.white38 : const Color(0xFF00A3FF), width: 1.5),
                        ),
                        child: Icon(Icons.play_arrow_rounded, color: isRead ? Colors.white38 : const Color(0xFF00A3FF), size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        media.title,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isRead ? Colors.white38 : Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isRead ? Colors.white10 : const Color(0x1A00A3FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isRead ? Colors.white24 : const Color(0xFF00A3FF).withOpacity(0.5), width: 1),
                          ),
                          child: InkWell(
                            onTap: () => _openFullscreenVideoPlayer(context, media),
                            borderRadius: BorderRadius.circular(8),
                            child: const Center(
                              child: Text('شاهد الملخص', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                          ),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            const Icon(Icons.video_collection_outlined, color: Colors.white24, size: 11),
                            const SizedBox(width: 4),
                            Text(
                              _generateStealthViews(media),
                              style: TextStyle(color: isRead ? Colors.white24 : Colors.white38, fontSize: 10, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
