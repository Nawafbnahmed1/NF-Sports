import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MatchEventModel {
  final String id;
  final String minute;
  final String type; 
  final String playerName;
  final String detail;
  final bool isHomeTeam;

  const MatchEventModel({
    required this.id,
    required this.minute,
    required this.type,
    required this.playerName,
    required this.detail,
    required this.isHomeTeam,
  });
}

class MatchStatsModel {
  final int homePossession;
  final int awayPossession;
  final int homeShots;
  final int awayShots;
  final int homeShotsOnTarget;
  final int awayShotsOnTarget;
  final int homeCorners;
  final int awayCorners;

  const MatchStatsModel({
    this.homePossession = 50,
    this.awayPossession = 50,
    this.homeShots = 0,
    this.awayShots = 0,
    this.homeShotsOnTarget = 0,
    this.awayShotsOnTarget = 0,
    this.homeCorners = 0,
    this.awayCorners = 0,
  });
}

class PlayerLineupModel {
  final String name;
  final String number;
  final String rating;
  final String position; 
  final int xGrid; 
  final int yGrid;

  const PlayerLineupModel({
    required this.name,
    required this.number,
    required this.rating,
    required this.position,
    required this.xGrid,
    required this.yGrid,
  });
}

class MatchCommentModel {
  final String id;
  final String userName;
  final String text;
  final String? audioUrl;
  final int likes;
  final DateTime createdAt;
  final String? parentId;

  MatchCommentModel({
    required this.id,
    required this.userName,
    required this.text,
    this.audioUrl,
    this.likes = 0,
    required this.createdAt,
    this.parentId,
  });

  factory MatchCommentModel.fromMap(Map<String, dynamic> map) {
    return MatchCommentModel(
      id: map['id'].toString(),
      userName: map['user_name'] ?? 'مشجع',
      text: map['comment_text'] ?? '',
      audioUrl: map['audio_url'],
      likes: map['likes'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      parentId: map['parent_id']?.toString(),
    );
  }
}

class MatchDetailScreen extends StatefulWidget {
  final String team1;
  final String team2;
  final String matchId; 

  const MatchDetailScreen({
    super.key,
    required this.team1,
    required this.team2,
    this.matchId = 'global_match_2026',
  });

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  
  late TabController _tabController;
  late PageController _lineupPageController; 
  
  final TextEditingController _chatController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  final List<String> _toxicKeywords = ['كلب', 'حمار', 'غبي', 'حيوان', 'يلعن', 'تفو', 'منيوك', 'كس', 'عرص', 'قحبة'];
  String? _replyingToCommentId;

  int _homeVotes = 0;
  int _drawVotes = 0;
  int _awayVotes = 0;
  bool _hasVoted = false;
  String? _myVoteChoice;

  bool _isRecording = false;
  String? _currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lineupPageController = PageController(initialPage: 0);
    _syncVotesFromCloud();
    final user = supabase.auth.currentUser;
    if(user != null) {
      _currentUser = user.id;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lineupPageController.dispose();
    _chatController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _syncVotesFromCloud() async {
    try {
      final response = await supabase
          .from('match_votes')
          .select()
          .eq('match_id', widget.matchId)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          _homeVotes = response['home_votes'] ?? 0;
          _drawVotes = response['draw_votes'] ?? 0;
          _awayVotes = response['away_votes'] ?? 0;
        });
      }
    } catch (_) {}
  }

  bool _checkAndApplyBotGuard(String text, String userName) {
    final cleanText = text.toLowerCase().trim();
    bool shouldBan = false;
    if (cleanText.contains('http://') || cleanText.contains('https://') || cleanText.contains('.com') || cleanText.contains('www.')) {
      shouldBan = true;
    }
    for (var word in _toxicKeywords) {
      if (cleanText.contains(word)) {
        shouldBan = true;
        break;
      }
    }
    return shouldBan;
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final String? path = await _audioRecorder.stop();
      if (path != null) {
        HapticFeedback.mediumImpact();
        _isRecording = false;
        setState(() {});
        try {
          final file = File(path);
          final fileName = 'audio_comments/${DateTime.now().millisecondsSinceEpoch}.m4a';
          await supabase.storage.from('audio_comments').upload(fileName, file);
          final audioUrl = supabase.storage.from('audio_comments').getPublicUrl(fileName);
          await _submitComment(null, audioUrl);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل رفع التسجيل الصوتي', style: GoogleFonts.cairo())),
          );
        }
      }
    } else {
      HapticFeedback.mediumImpact();
      _isRecording = true;
      setState(() {});
      try {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
      } catch (e) {
        _isRecording = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر الوصول إلى الميكروفون', style: GoogleFonts.cairo())),
        );
      }
    }
  }

  Future<void> _submitComment(String? text, [String? audioUrl]) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يجب عليك تسجيل الدخول أولاً للتعليق', style: GoogleFonts.cairo())),
      );
      return;
    }
    final String userName = user.email?.split('@').first ?? 'مشجع NF';
    final String commentText = text ?? '';
    if (commentText.trim().isEmpty && audioUrl == null) return;
    if (_checkAndApplyBotGuard(commentText, userName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حظر الرسالة لاحتوائها على محتوى غير لائق', style: GoogleFonts.cairo())),
      );
      return;
    }
    try {
      await supabase.from('match_comments').insert({
        'match_id': widget.matchId,
        'user_id': user.id,
        'user_name': userName,
        'comment_text': commentText,
        'audio_url': audioUrl,
        'parent_id': _replyingToCommentId,
        'created_at': DateTime.now().toIso8601String(),
      });
      _chatController.clear();
      _replyingToCommentId = null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإرسال', style: GoogleFonts.cairo())),
      );
    }
  }

  Future<void> _likeComment(String commentId, int currentLikes) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يجب تسجيل الدخول للإعجاب', style: GoogleFonts.cairo())),
      );
      return;
    }
    HapticFeedback.selectionClick();
    try {
      await supabase.from('match_comments').update({'likes': currentLikes + 1}).eq('id', commentId);
    } catch (e) {
      print('Error liking comment: $e');
    }
  }

  Widget _buildPerspectivePitch(String teamName, List<PlayerLineupModel> players) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF161926).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.2), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX(-0.35),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1424),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 2),
                ),
                child: Stack(
                  children: [
                    Center(child: Container(height: 1, width: double.infinity, color: const Color(0xFF00A3FF).withOpacity(0.15))),
                    Center(
                      child: Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15), width: 1.5)),
                      ),
                    ),
                    Center(
                      child: Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.12), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF0F111A).withOpacity(0.85), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 0.8)),
                  child: Text(teamName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            ...players.map((player) {
              final double alignmentX = -1.0 + ((player.xGrid - 1) * 0.5);
              final double alignmentY = 0.85 - ((player.yGrid - 1) * 0.42);
              return Align(
                alignment: Alignment(alignmentX, alignmentY),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F111A),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00A3FF), width: 1.5),
                            boxShadow: [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.3), blurRadius: 6)],
                          ),
                          child: Center(child: Text(player.number, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                        ),
                        Positioned(
                          top: -3, right: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(color: const Color(0xFF00A3FF), borderRadius: BorderRadius.circular(4)),
                            child: Text(player.rating, style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: const Color(0xFF0F111A).withOpacity(0.75), borderRadius: BorderRadius.circular(4)),
                      child: Text(player.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineEventsSection() {
    final List<MatchEventModel> sampleEvents = [
      const MatchEventModel(id: '1', minute: "24'", type: 'goal', playerName: 'ميتروفيتش', detail: 'تمريرة حاسمة: مالكوم', isHomeTeam: true),
      const MatchEventModel(id: '2', minute: "41'", type: 'card', playerName: 'الخيبري', detail: 'بطاقة صفراء', isHomeTeam: false),
      const MatchEventModel(id: '3', minute: "68'", type: 'substitution', playerName: 'رونالدو', detail: 'خروج: تاليسكا', isHomeTeam: false),
      const MatchEventModel(id: '4', minute: "82'", type: 'goal', playerName: 'نيفيز', detail: 'ضربة جزاء ناجحة', isHomeTeam: true),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161926).withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.18), width: 1),
        ),
        child: GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sampleEvents.length,
            itemBuilder: (context, index) {
              final ev = sampleEvents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: !ev.isHomeTeam
                          ? Row(
                              children: [
                                Icon(ev.type == 'goal' ? Icons.sports_soccer : (ev.type == 'card' ? Icons.style_rounded : Icons.cached_rounded), color: ev.type == 'goal' ? Colors.white : (ev.type == 'card' ? Colors.amber : const Color(0xFF00A3FF)), size: 14),
                                const SizedBox(width: 8),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(ev.playerName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)), Text(ev.detail, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 9))])),
                              ],
                            )
                          : const SizedBox(),
                    ),
                    Container(margin: const EdgeInsets.symmetric(horizontal: 10), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 0.8)), child: Text(ev.minute, style: const TextStyle(color: Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.w900))),
                    Expanded(
                      child: ev.isHomeTeam
                          ? Row(textDirection: TextDirection.rtl, children: [
                              Icon(ev.type == 'goal' ? Icons.sports_soccer : (ev.type == 'card' ? Icons.style_rounded : Icons.cached_rounded), color: ev.type == 'goal' ? Colors.white : (ev.type == 'card' ? Colors.amber : const Color(0xFF00A3FF)), size: 14),
                              const SizedBox(width: 8),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, textDirection: TextDirection.rtl, children: [Text(ev.playerName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)), Text(ev.detail, textDirection: TextDirection.rtl, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 9))])),
                            ])
                          : const SizedBox(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getFormatedTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) return 'الآن';
    if (duration.inMinutes < 60) return 'منذ ${duration.inMinutes} د';
    if (duration.inHours < 24) return 'قبل ${duration.inHours} ساعة';
    return 'قبل ${duration.inDays} يوم';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111A),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00A3FF), size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('الإمبراطورية الرياضية', style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00A3FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF00A3FF),
          unselectedLabelColor: Colors.white38,
          labelStyle: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: const [Tab(text: 'تفاصيل المباراة'), Tab(text: 'مناقشات كروية')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: double.infinity, height: 180, decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF0F111A), AppTheme.backgroundColor], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: Stack(children: [
                Positioned(top: 10, right: 15, child: Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.2), fontSize: 11, fontWeight: FontWeight.w900))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15))), padding: const EdgeInsets.all(8), child: const Icon(Icons.shield, color: Colors.white70, size: 40)), const SizedBox(height: 8), Text(widget.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))])),
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF161926).withOpacity(0.6), borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.25)), boxShadow: [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.08), blurRadius: 12)]), child: const Text('2 - 1', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5))), const SizedBox(height: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text('انتهت المباراة • FT', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.w900)))]),
                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15))), padding: const EdgeInsets.all(8), child: const Icon(Icons.shield, color: Colors.white70, size: 40)), const SizedBox(height: 8), Text(widget.team2, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))])),
                ],),),
              ],),),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), child: Container(decoration: BoxDecoration(color: const Color(0xFF161926).withOpacity(0.6), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.18), width: 1)), child: GlassCard(borderRadius: 20, padding: const EdgeInsets.all(16), child: Column(children: [Row(textDirection: TextDirection.rtl, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(textDirection: TextDirection.rtl, children: [const Icon(Icons.emoji_events, color: Colors.amber, size: 16), const SizedBox(width: 8), Text('الدوري الممتاز', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))]), Text('الأسبوع 18', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 11))]), const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.white10, height: 1)), Row(textDirection: TextDirection.rtl, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(textDirection: TextDirection.rtl, children: [const Icon(Icons.stadium, color: Color(0xFF00A3FF), size: 16), const SizedBox(width: 8), Text('استاد الملك فهد الدولي', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))]), Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w900))])],),),)),
              const SizedBox(height: 14),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4), child: Text('إحصائيات اللقاء الحالية', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), child: Container(decoration: BoxDecoration(color: const Color(0xFF161926).withOpacity(0.6), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15), width: 1)), child: GlassCard(borderRadius: 20, padding: const EdgeInsets.all(16), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('55%', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 12, fontWeight: FontWeight.bold)), Text('الاستحواذ الكلي', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)), const Text('45%', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold))]), const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(4), child: Container(height: 5, width: double.infinity, color: Colors.white10, child: Row(children: [const Expanded(flex: 55, child: ColoredBox(color: Color(0xFF00A3FF))), Expanded(flex: 45, child: ColoredBox(color: const Color(0xFF161926)))])), const SizedBox(height: 14), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('14', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 12, fontWeight: FontWeight.bold)), Text('إجمالي التسديدات', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)), const Text('8', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold))]), const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(4), child: Container(height: 5, width: double.infinity, color: Colors.white10, child: Row(children: [const Expanded(flex: 14, child: ColoredBox(color: Color(0xFF00A3FF))), Expanded(flex: 8, child: ColoredBox(color: const Color(0xFF161926)))])),],),),)),
              const SizedBox(height: 14),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4), child: Text('التشكيلة التكتيكية الرسمية للخطوط', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.center, textDirection: TextDirection.rtl, children: [const Icon(Icons.swipe, color: Color(0xFF00A3FF), size: 14), const SizedBox(width: 6), Text('مرر الشاشة أفقياً لرؤية تشكيلة الخصم المتقابلة', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))]), ),
              const SizedBox(height: 6),
              SizedBox(height: 380, child: PageView(controller: _lineupPageController, physics: const BouncingScrollPhysics(), children: [ _buildPerspectivePitch(widget.team1, [const PlayerLineupModel(name: 'بونو', number: '1', rating: '7.8', position: 'GK', xGrid: 3, yGrid: 1), const PlayerLineupModel(name: 'كوليبالي', number: '3', rating: '8.1', position: 'DEF', xGrid: 2, yGrid: 2), const PlayerLineupModel(name: 'البليهي', number: '5', rating: '7.2', position: 'DEF', xGrid: 4, yGrid: 2), const PlayerLineupModel(name: 'نيفيز', number: '8', rating: '8.5', position: 'MID', xGrid: 3, yGrid: 3), const PlayerLineupModel(name: 'سافيتش', number: '22', rating: '7.9', position: 'MID', xGrid: 4, yGrid: 3), const PlayerLineupModel(name: 'مالكوم', number: '77', rating: '8.2', position: 'ATT', xGrid: 2, yGrid: 4), const PlayerLineupModel(name: 'ميتروفيتش', number: '9', rating: '9.0', position: 'ATT', xGrid: 3, yGrid: 5)]), _buildPerspectivePitch(widget.team2, [const PlayerLineupModel(name: 'بينتو', number: '24', rating: '7.5', position: 'GK', xGrid: 3, yGrid: 1), const PlayerLineupModel(name: 'لا بورت', number: '27', rating: '8.0', position: 'DEF', xGrid: 3, yGrid: 2), const PlayerLineupModel(name: 'الغنام', number: '2', rating: '7.1', position: 'DEF', xGrid: 5, yGrid: 2), const PlayerLineupModel(name: 'الخيبري', number: '17', rating: '7.4', position: 'MID', xGrid: 2, yGrid: 3), const PlayerLineupModel(name: 'أوتافيو', number: '25', rating: '8.3', position: 'MID', xGrid: 4, yGrid: 3), const PlayerLineupModel(name: 'تاليسكا', number: '94', rating: '7.8', position: 'ATT', xGrid: 4, yGrid: 4), const PlayerLineupModel(name: 'رونالدو', number: '7', rating: '9.2', position: 'ATT', xGrid: 3, yGrid: 5)])],)),
              const SizedBox(height: 14),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4), child: Text('شريط الأحداث الزمني والتبديلات', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
              _buildTimelineEventsSection(),
              const SizedBox(height: 60),
            ]),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Container(decoration: BoxDecoration(color: const Color(0xFF161926).withOpacity(0.6), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.2), width: 1)), child: GlassCard(borderRadius: 20, padding: const EdgeInsets.all(16), child: Column(children: [
                Row(textDirection: TextDirection.rtl, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('توقع الفائز في هذه الملحمة الكروية', style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)), Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w900))]),
                const SizedBox(height: 12),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(height: 24, width: double.infinity, color: Colors.white.withOpacity(0.05), child: Row(children: [Expanded(flex: _homeVotes > 0 ? _homeVotes : 1, child: Container(color: const Color(0xFF00A3FF), child: Center(child: Text('${(_homeVotes + _drawVotes + _awayVotes) > 0 ? ((_homeVotes/(_homeVotes+_drawVotes+_awayVotes))*100).toStringAsFixed(0) : 0}%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))), Expanded(flex: _drawVotes > 0 ? _drawVotes : 1, child: Container(color: Colors.white.withOpacity(0.05), child: Center(child: Text('${(_homeVotes + _drawVotes + _awayVotes) > 0 ? ((_drawVotes/(_homeVotes+_drawVotes+_awayVotes))*100).toStringAsFixed(0) : 0}%', style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))))), Expanded(flex: _awayVotes > 0 ? _awayVotes : 1, child: Container(color: const Color(0xFF00A3FF).withOpacity(0.4), child: Center(child: Text('${(_homeVotes + _drawVotes + _awayVotes) > 0 ? ((_awayVotes/(_homeVotes+_drawVotes+_awayVotes))*100).toStringAsFixed(0) : 0}%', style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)))))],),),),
                if (!_hasVoted) ...[
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    InkWell(onTap: () => setState(() { _homeVotes++; _hasVoted = true; _myVoteChoice = 'home'; HapticFeedback.lightImpact(); }), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Text('فوز ${widget.team1}', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 10, fontWeight: FontWeight.bold))),
                    InkWell(onTap: () => setState(() { _drawVotes++; _hasVoted = true; _myVoteChoice = 'draw'; HapticFeedback.lightImpact(); }), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)), child: Text('تعادل', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
                    InkWell(onTap: () => setState(() { _awayVotes++; _hasVoted = true; _myVoteChoice = 'away'; HapticFeedback.lightImpact(); }), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.05), borderRadius: BorderRadius.circular(8)), child: Text('فوز ${widget.team2}', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold))),
                  ]),
                ] else ...[
                  const SizedBox(height: 8),
                  Text('شكراً لتصويتك! أنت توقعت: ${_myVoteChoice == 'home' ? widget.team1 : (_myVoteChoice == 'away' ? widget.team2 : 'التعادل')}', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ],),),),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text('منبر الجماهير الحركي 🏟️', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold))),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: supabase
                    .from('match_comments')
                    .stream(primaryKey: ['id'])
                    .eq('match_id', widget.matchId)
                    .order('created_at', ascending: false)
                    .map((data) => List<Map<String, dynamic>>.from(data)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Color(0xFF00A3FF))));
                  }
                  final commentsData = snapshot.data ?? [];
                  if (commentsData.isEmpty) {
                    return Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Center(child: Text('كن أول من يطلق العنان لصوته في هذه الملحمة!', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold))));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: commentsData.length,
                    itemBuilder: (context, index) {
                      final comment = commentsData[index];
                      final String id = comment['id'].toString();
                      final String userName = comment['user_name'] ?? 'مشجع';
                      final String text = comment['comment_text'] ?? '';
                      final String? audioUrl = comment['audio_url'];
                      final int likes = int.tryParse(comment['likes'].toString()) ?? 0;
                      final DateTime createdAt = DateTime.parse(comment['created_at'] ?? DateTime.now().toIso8601String());

                      return Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), child: Container(decoration: BoxDecoration(color: const Color(0xFF161926).withOpacity(0.6), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.12))), child: GlassCard(borderRadius: 16, padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(textDirection: TextDirection.rtl, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(userName, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)), Text(_getFormatedTimeAgo(createdAt), style: GoogleFonts.cairo(color: Colors.white24, fontSize: 8))]),
                        const SizedBox(height: 6),
                        Align(alignment: Alignment.centerRight, child: Text(text, textDirection: TextDirection.rtl, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12))),
                        if (audioUrl != null && audioUrl.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)), child: Row(textDirection: TextDirection.rtl, children: [const Icon(Icons.audiotrack, color: Color(0xFF00A3FF), size: 16), const SizedBox(width: 8), Text('رسالة صوتية 🎙️', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10)), const Spacer(), IconButton(icon: const Icon(Icons.play_arrow_rounded, color: Color(0xFF00A3FF), size: 16), onPressed: () { /* تشغيل الصوت باستخدام audioplayers لاحقاً */ })])),
                        ],
                        const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(color: Colors.white10, height: 1)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            InkWell(onTap: () => _likeComment(id, likes), child: Row(children: [const Icon(Icons.thumb_up_rounded, color: Color(0xFF00A3FF), size: 12), const SizedBox(width: 4), Text('$likes', style: const TextStyle(color: Color(0xFF00A3FF), fontSize: 9))])),
                            const SizedBox(width: 14),
                            InkWell(onTap: () => setState(() { _replyingToCommentId = id; }), child: Row(children: [const Icon(Icons.reply_rounded, color: Colors.white24, size: 12), const SizedBox(width: 4), Text('رد', style: GoogleFonts.cairo(color: Colors.white24, fontSize: 9))]))
                          ]),
                        ]),
                      ],),),);
                    },
                  );
                },
              ),
              Padding(padding: const EdgeInsets.all(20), child: Row(textDirection: TextDirection.rtl, children: [
                Expanded(child: TextField(controller: _chatController, textDirection: TextDirection.rtl, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12), decoration: InputDecoration(hintText: _replyingToCommentId != null ? 'اكتب ردك...' : 'اكتب نقاشك الرياضي الفخم هنا...', hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 11), hintTextDirection: TextDirection.rtl, filled: true, fillColor: const Color(0xFF161926).withOpacity(0.5), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: const Color(0xFF00A3FF).withOpacity(0.4), width: 1.5))))),
                const SizedBox(width: 8),
                AnimatedBuilder(animation: _audioRecorder, builder: (context, _) {
                  return GestureDetector(
                    onLongPressStart: (_) => _toggleRecording(),
                    onLongPressEnd: (_) => _toggleRecording(),
                    child: Container(
                      decoration: BoxDecoration(color: _isRecording ? Colors.redAccent.withOpacity(0.2) : const Color(0xFF161926), shape: BoxShape.circle, border: Border.all(color: _isRecording ? Colors.redAccent : Colors.white10)),
                      child: Padding(padding: const EdgeInsets.all(8), child: _isRecording ? const Icon(Icons.stop_rounded, color: Colors.white, size: 18) : const Icon(Icons.mic_rounded, color: Colors.white60, size: 18)),
                    ),
                  );
                }),
                const SizedBox(width: 6),
                Container(decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.4))), child: IconButton(icon: const Icon(Icons.send_rounded, color: Color(0xFF00A3FF), size: 18), onPressed: () { final txt = _chatController.text.trim(); if (txt.isNotEmpty) _submitComment(txt); _chatController.clear(); _replyingToCommentId = null; })),
              ])),
              const SizedBox(height: 60),
            ]),
          ),
        ],
      ),
    );
  }
}
