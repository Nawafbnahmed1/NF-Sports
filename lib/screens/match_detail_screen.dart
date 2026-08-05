import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

// 👑 موديل أحداث اللقاء الحية المصفى ليتناسب 100% مع معطيات المصادر المجانية الصافية
class MatchEventModel {
  final String id;
  final String minute;
  final String type; // goal, card, substitution
  final String playerName;
  final String detail; // assist name, or card color, or sub player out
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

// 👑 موديل إحصائيات اللقاء الموزون والمضمون برمجياً بنقاء
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

// 👑 موديل بيانات كروت التشكيلة الرسمية للاعبين والتقييمات الرقمية المضيئة
class PlayerLineupModel {
  final String name;
  final String number;
  final String rating;
  final String position; // GK, DEF, MID, ATT
  final int xGrid; // من 1 إلى 5 لتوزيع اللاعبين تكتيكياً
  final int yGrid; // من 1 = للحارس إلى 5 = للهجوم

  const PlayerLineupModel({
    required this.name,
    required this.number,
    required this.rating,
    required this.position,
    required this.xGrid,
    required this.yGrid,
  });
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
  
  final List<String> _blacklistedUsers = [];
  final Map<String, DateTime> _banList = {};
  
  final List<String> _toxicKeywords = ['كلب', 'حمار', 'غبي', 'حيوان', 'يلعن', 'تفو', 'منيوك', 'كس', 'عرص', 'قحبة'];

  int _homeVotes = 0;
  int _drawVotes = 0;
  int _awayVotes = 0;
  bool _hasVoted = false;
  String? _myVoteChoice;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lineupPageController = PageController(initialPage: 0);
    _syncVotesFromCloud();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lineupPageController.dispose();
    _chatController.dispose();
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

    if (shouldBan) {
      HapticFeedback.vibrate(); 
      setState(() {
        _banList[userName] = DateTime.now().add(const Duration(hours: 12));
      });
      return true; 
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00A3FF), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الإمبراطورية الرياضية',
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00A3FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF00A3FF),
          unselectedLabelColor: Colors.white38,
          labelStyle: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'تفاصيل المباراة'),
            Tab(text: 'مناقشات كروية'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF0F111A), AppTheme.backgroundColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10, right: 15,
                        child: Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.2), fontSize: 11, fontWeight: FontWeight.w900)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60, height: 60,
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15))),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.shield, color: Colors.white70, size: 40),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(widget.team1, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF161926).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.25)),
                                    boxShadow: [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.08), blurRadius: 12)],
                                  ),
                                  child: const Text('2 - 1', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                  child: Text('انتهت المباراة • FT', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60, height: 60,
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15))),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.shield, color: Colors.white70, size: 40),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(widget.team2, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 🎫 2. لوحة كبسولات تفاصيل اللقاء الأساسية (البطولة • الملعب)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161926).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.18), width: 1),
                    ),
                    child: GlassCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(textDirection: TextDirection.rtl, children: [
                                const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                                const SizedBox(width: 8),
                                Text('الدوري الممتاز', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              ]),
                              Text('الأسبوع 18', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.white10, height: 1)),
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(textDirection: TextDirection.rtl, children: [
                                const Icon(Icons.stadium, color: Color(0xFF00A3FF), size: 16),
                                const SizedBox(width: 8),
                                Text('استاد الملك فهد الدولي', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              ]),
                              Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.black)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 📊 3. شريط المقارنة اللحظية للإحصائيات الحية المصفاة لبراند NF SPORTS
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text('إحصائيات اللقاء الحالية', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161926).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15), width: 1),
                    ),
                    child: GlassCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('55%', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('الاستحواذ الكلي', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const Text('45%', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              height: 5, width: double.infinity, color: Colors.white10,
                              child: Row(
                                children: [
                                  const Expanded(flex: 55, child: ColoredBox(color: Color(0xFF00A3FF))),
                                  Expanded(flex: 45, child: ColoredBox(color: const Color(0xFF161926))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('14', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('إجمالي التسديدات', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              const Text('8', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              height: 5, width: double.infinity, color: Colors.white10,
                              child: Row(
                                children: [
                                  const Expanded(flex: 14, child: ColoredBox(color: Color(0xFF00A3FF))),
                                  Expanded(flex: 8, child: ColoredBox(color: const Color(0xFF161926))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // 🟢 4. معجزة مجسم الملعب العشبي ثلاثي الأبعاد المائل مع التمرير الأفقي السلس بين التشكيلتين لـ NF SPORTS
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text('التشكيلة التكتيكية الرسمية للخطوط', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      const Icon(Icons.swipe, color: Color(0xFF00A3FF), size: 14),
                      const SizedBox(width: 6),
                      Text('مرر الشاشة أفقياً لرؤية تشكيلة الخصم المتقابلة', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                SizedBox(
                  height: 380,
                  child: PageView(
                    controller: _lineupPageController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // 🏠 الملعب الأول: تشكيلة أصحاب الأرض (Team 1) ثلاثية الأبعاد الفخمة
                      _buildPerspectivePitch(widget.team1, [
                        const PlayerLineupModel(name: 'بونو', number: '1', rating: '7.8', position: 'GK', xGrid: 3, yGrid: 1),
                        const PlayerLineupModel(name: 'كوليبالي', number: '3', rating: '8.1', position: 'DEF', xGrid: 2, yGrid: 2),
                        const PlayerLineupModel(name: 'البليهي', number: '5', rating: '7.2', position: 'DEF', xGrid: 4, yGrid: 2),
                        const PlayerLineupModel(name: 'نيفيز', number: '8', rating: '8.5', position: 'MID', xGrid: 3, yGrid: 3),
                        const PlayerLineupModel(name: 'سافيتش', number: '22', rating: '7.9', position: 'MID', xGrid: 4, yGrid: 3),
                        const PlayerLineupModel(name: 'مالكوم', number: '77', rating: '8.2', position: 'ATT', xGrid: 2, yGrid: 4),
                        const PlayerLineupModel(name: 'ميتروفيتش', number: '9', rating: '9.0', position: 'ATT', xGrid: 3, yGrid: 5),
                      ]),

                      // 🚀 الملعب الثاني: تشكيلة الخصم والضيوف (Team 2) ثلاثية الأبعاد المتقابلة
                      _buildPerspectivePitch(widget.team2, [
                        const PlayerLineupModel(name: 'بينتو', number: '24', rating: '7.5', position: 'GK', xGrid: 3, yGrid: 1),
                        const PlayerLineupModel(name: 'لا بورت', number: '27', rating: '8.0', position: 'DEF', xGrid: 3, yGrid: 2),
                        const PlayerLineupModel(name: 'الغنام', number: '2', rating: '7.1', position: 'DEF', xGrid: 5, yGrid: 2),
                        const PlayerLineupModel(name: 'الخيبري', number: '17', rating: '7.4', position: 'MID', xGrid: 2, yGrid: 3),
                        const PlayerLineupModel(name: 'أوتافيو', number: '25', rating: '8.3', position: 'MID', xGrid: 4, yGrid: 3),
                        const PlayerLineupModel(name: 'تاليسكا', number: '94', rating: '7.8', position: 'ATT', xGrid: 4, yGrid: 4),
                        const PlayerLineupModel(name: 'رونالدو', number: '7', rating: '9.2', position: 'ATT', xGrid: 3, yGrid: 5),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 🔄 5. الخط الزمني الملكي للأحداث والتبديلات والأهداف (Timeline)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text('شريط الأحداث الزمني والتبديلات', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
                _buildTimelineEventsSection(),
                const SizedBox(height: 60),
              ],
            ),
          ),
  // 🏟️ دالة بناء مجسم الملعب العشبي ثلاثي الأبعاد المائل مع حساب إحداثيات قمصان اللاعبين والتقييم المضيء
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
            // 🗺️ الخلفية العشبية الفخمة ثلاثية الأبعاد والمائلة سينمائياً للملعب الكوني
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002) // عامل قهر أبعاد المنظور المائل وعمق الـ 3D Perspective
                ..rotateX(-0.35), // degree of tilt for pitch angle
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
                    // 🛡️ زراعة وحقن وسم حقوق الملكية وتوقيع براندك الكوني "NF" في منتصف عشب الملعب لفرض الهيبة الرسمية
                    Center(
                      child: Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.12), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ),
                  ],
                ),
              ),
            ),

            // ترويسة اسم الفريق المستعرض أعلى كادر الملعب
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

            // 🎽 فرش وتوزيع كبسولات قمصان اللاعبين والتقييمات الرقمية المضيئة فوق الملعب المائل
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
                        // التقييم الرقمي المضيء للاعب مستقر بالزاوية العلوية للقميص بنقاء
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
  // 🔄 دالة بناء الخط الزمني الملكي للأحداث والتبديلات والأهداف الموزعة بالتبادل لراحة عين المشجع
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
                    // أحداث الفريق الثاني (الضيوف) تفرز وتتراصف يساراً بنقاء 100%
                    Expanded(
                      child: !ev.isHomeTeam
                          ? Row(
                              children: [
                                Icon(
                                  ev.type == 'goal' 
                                      ? Icons.sports_soccer 
                                      : (ev.type == 'card' ? Icons.style_rounded : Icons.cached_rounded), 
                                  color: ev.type == 'goal' 
                                      ? Colors.white 
                                      : (ev.type == 'card' ? Colors.amber : const Color(0xFF00A3FF)), 
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ev.playerName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                      Text(ev.detail, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 9)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),

                    // العمود المركزي الصافي والمضيء الحارس للدقائق الزمنية لكل حدث كروي
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A3FF).withOpacity(0.12), 
                        borderRadius: BorderRadius.circular(8), 
                        border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 0.8),
                      ),
                      child: Text(ev.minute, style: const TextStyle(color: Color(0xFF00A3FF), fontSize: 9, fontWeight: FontWeight.w900)),
                    ),

                    // أحداث الفريق الأول (أصحاب الأرض) تفرز وتتراصف يميناً بنقاء 100%
                    Expanded(
                      child: ev.isHomeTeam
                          ? Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Icon(
                                  ev.type == 'goal' 
                                      ? Icons.sports_soccer 
                                      : (ev.type == 'card' ? Icons.style_rounded : Icons.cached_rounded), 
                                  color: ev.type == 'goal' 
                                      ? Colors.white 
                                      : (ev.type == 'card' ? Colors.amber : const Color(0xFF00A3FF)), 
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text(ev.playerName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                      Text(ev.detail, textDirection: TextDirection.rtl, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 9)),
                                    ],
                                  ),
                                ),
                              ],
                            )
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
          // 💬 الواجهة الثانية: ساحة "مناقشات كروية" المدججة بترسانة التفاعل والبوت الحارس لـ NF SPORTS
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // 📊 أولاً: شريط استفتاء توقع الفائز الكوني (موضع بالقمة لإشعال حماس الجماهير)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161926).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.2), width: 1),
                    ),
                    child: GlassCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('توقع الفائز في هذه الملحمة الكروية', style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('NF', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF).withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.black)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // شريط النسب المشع والنابض لتوقع الجماهير
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 24, width: double.infinity, color: Colors.white05,
                              child: Row(
                                children: [
                                  Expanded(flex: _homeVotes > 0 ? _homeVotes : 1, child: Container(color: const Color(0xFF00A3FF), child: Center(child: Text('${(_homeVotes + _drawVotes + _awayVotes) > 0 ? ((_homeVotes/(_homeVotes+_drawVotes+_awayVotes))*100).toStringAsFixed(0) : 0}%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))),
                                  Expanded(flex: _drawVotes > 0 ? _drawVotes : 1, child: Container(color: Colors.white10, child: Center(child: Text('${(_homeVotes + _drawVotes + _awayVotes) > 0 ? ((_drawVotes/(_homeVotes+_drawVotes+_awayVotes))*100).toStringAsFixed(0) : 0}%', style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))))),
                                  Expanded(flex: _awayVotes > 0 ? _awayVotes : 1, child: Container(color: const Color(0xFF00A3FF).withOpacity(0.4), child: Center(child: Text('${(_homeVotes + _drawVotes + _awayVotes) > 0 ? ((_awayVotes/(_homeVotes+_drawVotes+_awayVotes))*100).toStringAsFixed(0) : 0}%', style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold))))),
                                ],
                              ),
                            ),
                          ),
                          
                          // أزرار كبس التصويت التفاعلية قبل انطلاق اللقاء (تختفي فور نقر المستخدم)
                          if (!_hasVoted) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => setState(() { _homeVotes++; _hasVoted = true; _myVoteChoice = 'home'; HapticFeedback.lightImpact(); }),
                                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Text('فوز ${widget.team1}', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 10, fontWeight: FontWeight.bold))),
                                ),
                                InkWell(
                                  onTap: () => setState(() { _drawVotes++; _hasVoted = true; _myVoteChoice = 'draw'; HapticFeedback.lightImpact(); }),
                                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.white05, borderRadius: BorderRadius.circular(8)), child: Text('تعادل', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
                                ),
                                InkWell(
                                  onTap: () => setState(() { _awayVotes++; _hasVoted = true; _myVoteChoice = 'away'; HapticFeedback.lightImpact(); }),
                                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.05), borderRadius: BorderRadius.circular(8)), child: Text('فوز ${widget.team2}', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold))),
                                ),
                              ],
                            ),
                          ] else ...[
                            const SizedBox(height: 8),
                            Text('شكراً لتصويتك! أنت توقعت: ${_myVoteChoice == 'home' ? widget.team1 : (_myVoteChoice == 'away' ? widget.team2 : 'التعادل')}', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                //  ساحة فرز نقاشات المشجين الحية (قائمة الاستماع اللحظي)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('منبر الجماهير الحركي 🏟️', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                //  محاكاة لستة الرسائل المباشرة المفرومة بنقاء وبوت الحماية من الإعلانات
                ListView.builder(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final names = ['الكابتن ماجد', 'مدرج العميد', 'ابن اليمن'];
                    final texts = ['تكتيك أسطوري ومباراة للتاريخ 🔥', 'رونالدو اليوم بينفجر في الملعب ⚽', 'رابط بث مباشر للمباراة هنا ://matchlive.com'];
                    final currentName = names[index % 3];
                    final currentText = texts[index % 3];
                    
                    final isBannedByBot = _banList.containsKey(currentName);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161926).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.12)),
                        ),
                        child: GlassCard(
                          borderRadius: 16, padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🚨 المربع الأحمر النيوني التحذيري من البوت الحارس للمخالفين والروابط
                              if (isBannedByBot || currentText.contains('www.')) ...[
                                Container(
                                  width: double.infinity, margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.redAccent.withOpacity(0.4))),
                                  child: Text('⚠️ تم الحظر التلقائي: خالف هذا الحساب شروط وقوانين مجتمع NF الرياضية لمده 12 ساعة.', textDirection: TextDirection.rtl, style: GoogleFonts.cairo(color: Colors.redAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                              ],
                              Row(
                                textDirection: TextDirection.rtl, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(currentName, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                  Text('منذ قليل', style: GoogleFonts.cairo(color: Colors.white24, fontSize: 8)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Align(alignment: Alignment.centerRight, child: Text(currentText, textDirection: TextDirection.rtl, style: GoogleFonts.cairo(color: (isBannedByBot || currentText.contains('www.')) ? Colors.white24 : Colors.white, fontSize: 12))),
                              
                              const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(color: Colors.white10, height: 1)),
                              // أزرار التفاعل المدججة للزوار 👍 و 👎 والرسائل الصوتية بالأسفل مع توقيع الحقوق
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(icon: const Icon(Icons.thumb_up_rounded, color: Color(0xFF00A3FF), size: 12), onPressed: () => HapticFeedback.selectionClick()),
                                      const Text('12', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 9)),
                                      const SizedBox(width: 10),
                                      IconButton(icon: const Icon(Icons.thumb_down_rounded, color: Colors.white24, size: 12), onPressed: () => HapticFeedback.selectionClick()),
                                      const Text('2', style: TextStyle(color: Colors.white24, fontSize: 9)),
                                    ],
                                  ),
                                  if (index == 0) // محاكاة لـ وسم تشغيل الصوت المرسل بنقاء
                                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Row(children: const [Text('0:04 ', style: TextStyle(color: Color(0xFF00A3FF), fontSize: 8)), Icon(Icons.volume_up_rounded, color: Color(0xFF00A3FF), size: 10)])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // 🛠️ صندوق إدخال الآراء والتعليقات والرسائل الصوتية بالأسفل
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController, textDirection: TextDirection.rtl,
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'اكتب نقاشك الرياضي الفخم هنا...',
                            hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 11),
                            hintTextDirection: TextDirection.rtl, filled: true, fillColor: const Color(0xFF161926).withOpacity(0.5),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: const Color(0xFF00A3FF).withOpacity(0.4), width: 1.5)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // زر إرسال التفاعلات الصوتية للأصوات المنسابة حياً بنقاء لحماية المنصة مجاناً
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF161926), shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
                        child: IconButton(icon: const Icon(Icons.mic_rounded, color: Colors.white60, size: 18), onPressed: () { HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: const Color(0xFF00A3FF), content: Text('🎙️ ميزة البلاغات المفعلة للأصوات تعمل حماية تلقائية ومجانية لـ مجتمع NF', textAlign: TextAlign.right, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold)))); }),
                      ),
                      const SizedBox(width: 6),
                      // زر الإرسال الكوني المربوط بالبوت الحارس الذكي فورا
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF00A3FF).withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.4))),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Color(0xFF00A3FF), size: 18),
                          onPressed: () {
                            final txt = _chatController.text.trim();
                            if (txt.isEmpty) return;
                            _checkAndApplyBotGuard(txt, 'مشجع_حالي');
                            _chatController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
