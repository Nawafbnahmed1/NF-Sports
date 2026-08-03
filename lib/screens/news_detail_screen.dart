import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'news_screen.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsArticleModel article;

  const NewsDetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late ScrollController _scrollController;
  late AnimationController _sparkController;
  late Animation<double> _sparkAnimation;
  
  double _readingProgress = 0.0;
  final TextEditingController _commentController = TextEditingController();
  String? _replyingToCommentId;
  String? _replyingToUserName;

  final List<String> _toxicityFilter = [
    'كلب', 'حمار', 'غبي', 'حيوان', 'يلعن', 'تفو', 'ياكلب', 'ياحمار', 'منيوك', 'كس'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_updateReadingProgress);
    
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _sparkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateReadingProgress);
    _scrollController.dispose();
    _sparkController.dispose();
    _commentController.dispose();
    super.dispose();
  }
  void _updateReadingProgress() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    setState(() {
      _readingProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
    });
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    bool isToxic = false;
    for (var word in _toxicityFilter) {
      if (text.toLowerCase().contains(word)) {
        isToxic = true;
        break;
      }
    }

    if (isToxic) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'نعتذر منك، الرجاء الالتزام بالروح الرياضية والابتعاد عن الألفاظ المسيئة للحفاظ على مجتمع التطبيق!',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      );
      return;
    }

    try {
      HapticFeedback.mediumImpact();
      final user = supabase.auth.currentUser;
      final String userName = user?.email?.split('@').first ?? 'مشجع عابر';

      await supabase.from('comments').insert({
        'article_url': widget.article.articleUrl,
        'user_name': userName,
        'comment_text': text,
        'parent_id': _replyingToCommentId,
        'created_at': DateTime.now().toIso8601String(),
      });

      _commentController.clear();
      setState(() {
        _replyingToCommentId = null;
        _replyingToUserName = null;
      });
    } catch (e) {
      print('❌ Error posting comment: $e');
    }
  }

  Future<void> _likeComment(String commentId, int currentLikes) async {
    HapticFeedback.selectionClick();
    try {
      await supabase
          .from('comments')
          .update({'likes': currentLikes + 1})
          .eq('id', commentId);
    } catch (e) {
      print('❌ Error liking comment: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    try {
      DateTime parsedDate = widget.article.publishedAt.toLocal();
      formattedDate = DateFormat('yyyy/MM/dd • hh:mm a').format(parsedDate);
    } catch (e) {
      formattedDate = 'منذ قليل';
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 320.0,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: AppTheme.backgroundColor,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: const Color(0xFF161926).withOpacity(0.8),
                        child: IconButton(
                          // ✅ تم استبدال اللون إلى الأزرق اللامع
                          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00A3FF), size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'news_image_${widget.article.articleUrl}',
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.article.imageUrl.isNotEmpty
                              ? Image.network(
                                  widget.article.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF1A1D2E),
                                      // ✅ تم استبدال اللون إلى الأزرق اللامع
                                      child: const Center(child: Icon(Icons.sports_soccer, color: Color(0xFF00A3FF), size: 48)),
                                    );
                                  },
                                )
                              : Container(
                                  color: const Color(0xFF1A1D2E),
                                  // ✅ تم استبدال اللون إلى الأزرق اللامع
                                  child: const Center(child: Icon(Icons.sports_soccer, color: Color(0xFF00A3FF), size: 48)),
                                ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, AppTheme.backgroundColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          textDirection: ui.TextDirection.rtl,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                // ✅ تم تغيير اللون للأزرق
                                color: const Color(0xFF00A3FF).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 1),
                              ),
                              child: Text(
                                widget.article.source,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  // ✅ نص أزرق
                                  color: const Color(0xFF00A3FF),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              textDirection: ui.TextDirection.rtl,
                              children: [
                                const Icon(Icons.access_time_filled, color: Color(0xFF707E94), size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  formattedDate,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    color: const Color(0xFF707E94),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        AnimatedBuilder(
                          animation: _sparkAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _sparkAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, (1.0 - _sparkAnimation.value) * 8),
                                child: child,
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.article.title,
                              textDirection: ui.TextDirection.rtl,
                              style: GoogleFonts.cairo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.4,
                                  // ✅ توهج أزرق
                                  shadows: [
                                    Shadow(color: const Color(0xFF00A3FF).withOpacity(0.2), blurRadius: 15)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0x0FFFFFFF),
                              borderRadius: BorderRadius.circular(14),
                              // ✅ حواف زرقاء
                              border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15), width: 1),
                            ),
                            child: Row(
                              textDirection: ui.TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  textDirection: ui.TextDirection.rtl,
                                  children: [
                                    // ✅ أيقونة زرقاء
                                    const Icon(Icons.mic_external_on_rounded, color: Color(0xFF00A3FF), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'الاستماع الذكي للخبر والتحليل اللحظي',
                                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: List.generate(4, (index) {
                                    return AnimatedBuilder(
                                      animation: _sparkAnimation,
                                      builder: (context, _) {
                                        final double sine = math.sin((_sparkAnimation.value * math.pi * 2) + (index * 0.5));
                                        final double heightValue = 4.0 + (sine.abs() * 14.0);
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                          width: 2.5,
                                          height: heightValue,
                                          decoration: BoxDecoration(
                                            // ✅ ألوان زرقاء
                                            color: index % 2 == 0 ? const Color(0xFF00A3FF) : AppTheme.neonBlue,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // ✅ تدرج أزرق
                              gradient: LinearGradient(
                                colors: [const Color(0xFF00A3FF).withOpacity(0.3), Colors.transparent],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: widget.article.description.length < 150 ? 250 : 450,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            // ✅ حواف زرقاء
                            border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.15), width: 1.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InAppWebView(
                              initialUrlRequest: URLRequest(url: WebUri(widget.article.articleUrl)),
                              initialSettings: InAppWebViewSettings(
                                javaScriptEnabled: true,
                                transparentBackground: true,
                                supportZoom: false,
                              ),
                              onLoadStop: (controller, url) async {
                                await controller.evaluateJavascript(source: """
                                  (function() {
                                    var selectors = [
                                      '.ads', '.ad-box', '#ad-container', '.banner-ad', 
                                      'iframe[src*="googleads"]', 'div[id*="google_ads"]',
                                      '.footer-ads', '.sidebar-ads', 'header', 'footer', '.nav-menu'
                                    ];
                                    selectors.forEach(function(selector) {
                                      var elements = document.querySelectorAll(selector);
                                      elements.forEach(function(el) { el.remove(); });
                                    });
                                  })();
                                """);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'ساحة النقاش والتفاعل الحية',
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: supabase
                              .from('comments')
                              .stream(primaryKey: ['id'])
                              .eq('article_url', widget.article.articleUrl)
                              .order('created_at', ascending: true)
                              .map((maps) => List<Map<String, dynamic>>.from(maps)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // ✅ مؤشر تحميل أزرق
                              return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: Color(0xFF00A3FF))));
                            }
                            final allComments = snapshot.data ?? [];
                            if (allComments.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: Text('كن أول من يترك بصمته ويعلق على هذا الخبر الكوني ⚽', style: GoogleFonts.cairo(color: Colors.white.withOpacity(0.28), fontSize: 11, fontWeight: FontWeight.bold))),
                              );
                            }

                            final rootComments = allComments.where((c) => c['parent_id'] == null).toList();
                            final replies = allComments.where((c) => c['parent_id'] != null).toList();

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rootComments.length,
                              itemBuilder: (context, index) {
                                final comment = rootComments[index];
                                final commentId = comment['id'].toString();
                                
                                final commentReplies = replies.where((r) => r['parent_id'].toString() == commentId).toList();

                                return Column(
                                  children: [
                                    _buildCommentCard(comment, false),
                                    if (commentReplies.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 24),
                                        child: Column(
                                          children: commentReplies.map((reply) => _buildCommentCard(reply, true)).toList(),
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        if (_replyingToCommentId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              // ✅ خلفية زرقاء شفافة
                              color: const Color(0xFF00A3FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              textDirection: ui.TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'جاري الرد على تعليق: ${_replyingToUserName}',
                                  // ✅ نص أزرق
                                  style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.white38, size: 16),
                                  onPressed: () => setState(() { _replyingToCommentId = null; _replyingToUserName = null; }),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          textDirection: ui.TextDirection.rtl,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                textDirection: ui.TextDirection.rtl,
                                style: GoogleFonts.cairo(color: Colors.white, fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: _replyingToCommentId != null ? 'اكتب ردك الرياضي الفخم هنا...' : 'شارك برأيك الكروي في ساحة النقاش...',
                                  hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 12),
                                  hintTextDirection: ui.TextDirection.rtl,
                                  filled: true,
                                  fillColor: AppTheme.surfaceColor.withOpacity(0.5),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    // ✅ حواف زرقاء عند الكتابة
                                    borderSide: BorderSide(color: const Color(0xFF00A3FF).withOpacity(0.4), width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                // ✅ خلفية زرقاء شفافة
                                color: const Color(0xFF00A3FF).withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.4), width: 1),
                              ),
                              child: IconButton(
                                // ✅ أيقونة زرقاء
                                icon: const Icon(Icons.send_rounded, color: Color(0xFF00A3FF), size: 20),
                                onPressed: _postComment,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        InkWell(
                          onTap: () => HapticFeedback.mediumImpact(),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161926).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                              // ✅ حواف زرقاء
                              border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.25)),
                              boxShadow: [BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.05), blurRadius: 10)],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: ui.TextDirection.rtl,
                                children: [
                                  const Icon(Icons.share_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'شارك المتعة الكروية مع الأصدقاء الآن',
                                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        Center(
                          child: Column(
                            children: [
                              Container(height: 1, width: 60, color: const Color(0xFF1F2438)),
                              const SizedBox(height: 15),
                              Text(
                                "NF Sports © ${DateTime.now().year}",
                                style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF707E94), letterSpacing: 1.2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Container(
                height: 2.5,
                width: double.infinity,
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    width: MediaQuery.of(context).size.width * _readingProgress,
                    height: 2.5,
                    decoration: BoxDecoration(
                      // ✅ مؤشر قراءة أزرق
                      color: const Color(0xFF00A3FF),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF00A3FF).withOpacity(0.8), blurRadius: 4, spreadRadius: 0.5)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildCommentCard(Map<String, dynamic> comment, bool isReply) {
    final String commentId = comment['id'].toString();
    final String userName = comment['user_name'] ?? 'مشجع';
    final String text = comment['comment_text'] ?? '';
    final int likes = int.tryParse(comment['likes'].toString()) ?? 0;

        return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF161926).withOpacity(isReply ? 0.3 : 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ حواف زرقاء
          color: Color(0xFF00A3FF).withOpacity(isReply ? 0.1 : 0.18),
          width: 1,
        ),
      ),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              textDirection: ui.TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  textDirection: ui.TextDirection.rtl,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        // ✅ خلفية وحواف زرقاء
                        color: const Color(0xFF00A3FF).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF00A3FF).withOpacity(0.3), width: 1),
                      ),
                      child: Center(
                        child: Text(
                          userName.substring(0, 1).toUpperCase(),
                          // ✅ نص أزرق
                          style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userName,
                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    if (isReply)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        // ✅ خلفية زرقاء شفافة
                        decoration: BoxDecoration(color: const Color(0x3300A3FF), borderRadius: BorderRadius.circular(4)),
                        child: Text('رد', style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                Text(
                  comment['created_at'] != null ? _getFormatedTimeAgo(DateTime.parse(comment['created_at'])) : 'الآن',
                  style: GoogleFonts.cairo(color: Colors.white24, fontSize: 9.5),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                text,
                textDirection: ui.TextDirection.rtl,
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 12.5, height: 1.3),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              textDirection: ui.TextDirection.rtl,
              children: [
                InkWell(
                  onTap: () => _likeComment(commentId, likes),
                  child: Row(
                    textDirection: ui.TextDirection.rtl,
                    children: [
                      // ✅ أيقونة قلب زرقاء
                      const Icon(Icons.favorite_rounded, color: Color(0xFF00A3FF), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        likes.toString(),
                        // ✅ نص أزرق
                        style: GoogleFonts.cairo(color: const Color(0xFF00A3FF), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (!isReply) ...[
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _replyingToCommentId = commentId;
                        _replyingToUserName = userName;
                      });
                    },
                    child: Row(
                      textDirection: ui.TextDirection.rtl,
                      children: [
                        const Icon(Icons.reply_rounded, color: Colors.white38, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'رد',
                          style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
