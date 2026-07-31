import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_title.dart';
import '../widgets/neon_button.dart';
import 'match_detail_screen.dart';
import 'news_detail_screen.dart';
import 'news_screen.dart';

class HomeMatchModel {
  final String team1;
  final String team2;
  final String status;
  final String time;
  final String p1;
  final String p2;
  final String h1;
  final String h2;
  final String f1;
  final String f2;

  const HomeMatchModel({
    required this.team1,
    required this.team2,
    required this.status,
    required this.time,
    required this.p1,
    required this.p2,
    required this.h1,
    required this.h2,
    required this.f1,
    required this.f2,
  });
}

class HomeMediaModel {
  final String title;
  final String imageUrl;
  final String videoUrl;
  final DateTime publishedAt;

  const HomeMediaModel({
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.publishedAt,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _audioWaveController;
  final Set<String> _homeReadMemory = <String>{};

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _audioWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioWaveController.dispose();
    super.dispose();
  }

  String _generateDynamicViewsForHome(HomeMediaModel media) {
    final int seed = media.videoUrl.hashCode.abs() + media.title.hashCode.abs();
    final int baseViews = 450 + (seed % 250);
    final duration = DateTime.now().difference(media.publishedAt);
    final int growth = (duration.inMinutes ~/ 30) * 11;
    final int totalViews = baseViews + growth;

    if (totalViews >= 1000) {
      return '${(totalViews / 1000).toStringAsFixed(1)}K';
    }
    return '$totalViews';
  }

  void _openFullscreenVideoPlayer(BuildContext context, HomeMediaModel media) {
    HapticFeedback.vibrate();
    setState(() {
      _homeReadMemory.add(media.videoUrl);
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    double localVolume = 0.85;
    double localBrightness = 0.70;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "HomePlayer",
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
                            Container(color: Colors.black45),
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
                                    border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3)),
                                  ),
                                  child: const Text(
                                    "NF SPORTS",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
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
                                  border: Border.all(color: const Color(0xFF00F0FF), width: 1),
                                ),
                                child: const Text("1080p HD", style: TextStyle(color: Color(0xFF00F0FF), fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const Center(
                              child: Icon(Icons.play_arrow_rounded, color: AppTheme.neonBlue, size: 64),
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
                                  : const Icon(Icons.brightness_high, color: AppTheme.neonBlue),
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
                                  : const Icon(Icons.volume_up, color: AppTheme.neonBlue),
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
                        border: Border.all(color: AppTheme.neonBlue.withOpacity(0.2)),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(Icons.pause_circle_filled, color: AppTheme.neonBlue, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              media.title.isNotEmpty ? media.title : "أبرز لقطات المباراة",
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.download_for_offline, color: AppTheme.neonBlue, size: 24),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('جاري تحميل المقطع بحقوق NF SPORTS المثبتة...', style: TextStyle(fontFamily: 'Cairo'))),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NF',
                          style: TextStyle(
                            color: AppTheme.neonBlue,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            shadows: AppTheme.neonGlow(blur: 25),
                          ),
                        ),
                        const Text(
                          'SPORTS',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 4),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 32),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ],
                ),
              ),
              const SectionTitle(title: 'مباريات اليوم'),
              SizedBox(
                height: 355,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final match = HomeMatchModel(
                      team1: '',
                      team2: '',
                      status: '',
                      time: '',
                      p1: '0%',
                      p2: '0%',
                      h1: '',
                      h2: '',
                      f1: '',
                      f2: '',
                    );

                    final bool isLive = match.status.contains('مباشر') || match.status.toLowerCase().contains('live');

                    return Container(
                      width: 325,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isLive
                            ? [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        borderRadius: 24,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLive ? const Color(0x33FF5252) : const Color(0x1A00B4FF),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isLive ? Colors.redAccent.withOpacity(0.4) : AppTheme.neonBlue.withOpacity(0.4), width: 1),
                              ),
                              child: Text(
                                match.status,
                                style: TextStyle(
                                  color: isLive ? Colors.redAccent : AppTheme.neonBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1)),
                                        child: const Icon(Icons.shield, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(match.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                                        child: Text(match.f1, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(match.time, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                    const SizedBox(height: 5),
                                    isLive
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(4, (i) {
                                              return AnimatedBuilder(
                                                animation: _audioWaveController,
                                                builder: (context, child) {
                                                  final double heightFactor = (i == 0 || i == 3) ? 12.0 : 20.0;
                                                  return Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                                    width: 3,
                                                    height: 4 + (_audioWaveController.value * heightFactor),
                                                    decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      borderRadius: BorderRadius.circular(2),
                                                      boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 4)],
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(color: const Color(0x4D00B4FF), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.neonBlue, width: 1)),
                                            child: Text(match.time, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                          ),
                                    const SizedBox(height: 4),
                                    const Text('', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0x0AFFFFFF), shape: BoxShape.circle, border: Border.all(color: const Color(0x3300B4FF), width: 1)),
                                        child: const Icon(Icons.shield, color: Colors.white, size: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(match.team2, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0x2600B4FF), borderRadius: BorderRadius.circular(8)),
                                        child: Text(match.f2, style: const TextStyle(color: Color(0xFF00B4FF), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(match.p1, style: const TextStyle(color: AppTheme.neonBlue, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Text(match.p2, style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 5,
                                width: double.infinity,
                                color: Colors.white10,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: int.tryParse(match.p1.replaceAll('%', '')) ?? 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.neonBlue,
                                          boxShadow: [BoxShadow(color: AppTheme.neonBlue.withOpacity(0.5), blurRadius: 4)],
                                        ),
                                      ),
                                    ),
                                    const Expanded(flex: 15, child: ColoredBox(color: Colors.white10)),
                                    Expanded(
                                      flex: int.tryParse(match.p2.replaceAll('%', '')) ?? 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 4)],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(match.h1, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                                const SizedBox(width: 8),
                                Expanded(child: Text(match.h2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white10, height: 1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(match.f1, style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                const Text('', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Text(match.f2, style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Divider(color: Colors.white10, height: 1)),
                            NeonButton(
                              text: 'تفاصيل المباراة',
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(team1: match.team1, team2: match.team2)));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'آخر الأخبار'),
              _buildHorizontalList(isNews: true),
              const SizedBox(height: 20),
              const SectionTitle(title: 'أبرز اللقطات'),
              _buildHorizontalList(isNews: false),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalList({required bool isNews}) {
    return SizedBox(
      height: isNews ? 165 : 175,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          final media = HomeMediaModel(
            title: isNews ? 'عنوان الخبر الرياضي الممتد' : 'ملخص المباراة والأهداف الحاسمة',
            imageUrl: '',
            videoUrl: 'unique_video_id_$index',
            publishedAt: DateTime.now().subtract(Duration(minutes: index * 45)),
          );

          final bool isRead = _homeReadMemory.contains(media.videoUrl);
          final bool isHot = index % 3 == 0;

          return GestureDetector(
            onTap: () {
              setState(() {
                _homeReadMemory.add(media.videoUrl);
              });
              HapticFeedback.mediumImpact();
              if (isNews) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: NewsArticleModel(title: media.title, description: '', imageUrl: media.imageUrl, source: 'NF SPORTS', articleUrl: media.videoUrl, publishedAt: media.publishedAt))));
              } else {
                _openFullscreenVideoPlayer(context, media);
              }
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isRead ? 0.75 : 1.0,
              child: Container(
                width: isNews ? 160 : 230,
                margin: const EdgeInsets.only(left: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: (!isRead && isHot)
                      ? [
                          BoxShadow(color: AppTheme.glowBlue.withOpacity(0.25), blurRadius: 12, spreadRadius: 1),
                          BoxShadow(color: AppTheme.neonBlue.withOpacity(0.15), blurRadius: 6, spreadRadius: 0),
                        ]
                      : null,
                ),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: isNews ? 90 : 105,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              color: Colors.black26,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: media.imageUrl.isNotEmpty
                                  ? Image.network(media.imageUrl, fit: BoxFit.cover)
                                  : Center(
                                      child: Icon(
                                        isNews ? Icons.newspaper : Icons.play_circle_outline,
                                        color: isRead ? Colors.white10 : AppTheme.neonBlue.withOpacity(0.4),
                                        size: 32,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                              child: const Text(
                                "NF",
                                style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (!isNews)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFF00F0FF), width: 0.5)),
                                child: const Text("HD", style: TextStyle(color: Color(0xFF00F0FF), fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                if (isHot && !isRead)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(Icons.local_fire_department, color: Colors.redAccent, size: 14),
                                  ),
                                Expanded(
                                  child: Text(
                                    media.title.isNotEmpty ? media.title : (isNews ? "عنوان الخبر الرياضي عاجل" : "ملخص الماتش والأهداف حية"),
                                    textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: isRead ? Colors.white38 : Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.rtl,
                              children: [
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Icon(isNews ? Icons.visibility : Icons.play_arrow_rounded, size: 11, color: isRead ? Colors.white24 : AppTheme.neonBlue.withOpacity(0.7)),
                                    const SizedBox(width: 2),
                                    Text(
                                      _generateDynamicViewsForHome(media),
                                      style: TextStyle(color: isRead ? Colors.white24 : Colors.white60, fontSize: 9.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                    ),
                                  ],
                                ),
                                Icon(isNews ? Icons.insert_drive_file_outlined : Icons.file_download_done, size: 11, color: Colors.white24),
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
        },
      ),
    );
  }
}
