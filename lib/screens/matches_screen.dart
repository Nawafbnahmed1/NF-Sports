import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with TickerProviderStateMixin {
  late AnimationController _glowController;
  final TextEditingController _userSuggestionController = TextEditingController();

  // متغيرات الحالة الحقيقية القادمة من السحابة
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String _userName = '';
  String _userBio = '';
  int _correctPredictions = 0;
  String _avatarLetter = 'G';
  String? _userId;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _userSuggestionController.dispose();
    super.dispose();
  }

  // 🔮 جلب بيانات المستخدم الحقيقية من السحابة
  Future<void> _fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoggedIn = true;
      _userId = user.id;
      _avatarLetter = user.email?.substring(0, 1).toUpperCase() ?? 'U';
    });

    try {
      // جلب البيانات من جدول profiles الذي سننشئه لاحقاً
      final response = await Supabase.instance.client
          .from('profiles')
          .select('username, bio, correct_predictions')
          .eq('id', _userId!)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          _userName = response['username'] ?? 'مشجع NF Sports';
          _userBio = response['bio'] ?? 'عاشق كرة القدم والمستقبل الرقمي';
          _correctPredictions = response['correct_predictions'] ?? 0;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // 🚀 دالة مشاركة التطبيق (تستخدم الحافظة لتكون خفيفة جداً)
  void _shareAppLink() {
    HapticFeedback.lightImpact();
    // 🔵 هنا سنضع رابط متجرك الحقيقي لاحقاً
    const String appLink = 'https://play.google.com/store/apps/details?id=com.nf.sports';
    Clipboard.setData(ClipboardData(text: appLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📋 تم نسخ رابط التطبيق! شاركه مع عشاق كرة القدم.', style: GoogleFonts.cairo()),
        backgroundColor: const Color(0xFF0A1220),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 🔐 دالة تسجيل الخروج الآمنة
  Future<void> _handleLogout() async {
    HapticFeedback.mediumImpact();
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _userName = '';
          _userBio = '';
          _correctPredictions = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء تسجيل الخروج، حاول مجدداً.', style: GoogleFonts.cairo())),
        );
      }
    }
  }

  // 🗂️ صفحة سياسة الخصوصية والأمان (صفحة كاملة بمستطيلات زجاجية)
  void _openPrivacyPolicyPage() {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.neonBlue, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'سياسة الخصوصية والأمان',
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // مستطيل 1: المقدمة وبيان الأمان
                GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المقدمة وبيان الأمان', style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'في NF SPORTS، نضع أمان بياناتك أولوياتنا، نحن نلتزم بأعلى معايير الحماية العالمية للخصوصية (GDPR و CCPA)، ونستخدم تقنيات تشفير متقدمة ومتطورة لحماية جميع بياناتك الحساسة أثناء نقلها عبر الخوادم وأثناء تخزينها، لضمان عدم تمكن أي جهة خارجية من اختراقها أو الاطلاع عليها، بياناتك آمنة تماماً في خزائننا الرقمية.',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // مستطيل 2: ما هي البيانات التي نجمعها؟
                GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ما هي البيانات التي نجمعها؟', style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'لنقدم لك تجربة رياضية مخصصة وفريدة، نقوم بجمع أنواع أساسية من البيانات:\n1. معلومات الحساب: مثل الاسم الذي تختاره، البريد الإلكتروني، أو رقم الهاتف الذي تستخدمه للتسجيل.\n2. بيانات التفاعل الرياضي: التعليقات التي تكتبها في الأخبار والمباريات، الإعجابات، ونوع المحتوى (الدوري أو النادي) الذي تتابعه.',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // مستطيل 3: كيف نستخدم بياناتك؟
                GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('كيف نستخدم بياناتك؟', style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'نستخدم بياناتك لأغراض محددة وواضحة جداً فقط:\n1. التخصيص الذكي: لضمان ظهور أخبار وإحصائيات فرقك المفضلة لك أولاً بأول.\n2. تطوير التطبيق: تحليل كيفية استخدام التطبيق لتحسين تصميماته وجعلها أكثر انسيابية.\n3. الاتصال الهادف: إرسال تنبيهات وإشعارات فورية لك حول الأهداف والمباريات العاجلة (يمكنك تعطيلها في أي وقت).\nنؤكد لك: نحن لا نبيع بياناتك إطلاقاً، ولا نشاركها مع أي شركات إعلانات أو جهات تسويقية خارجية.',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // مستطيل 4: حقوقك الكاملة في بياناتك
                GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('حقوقك الكاملة في بياناتك', style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'أنت المتحكم الوحيد ببياناتك. وفقاً للقوانين الدولية، يحق لك في أي وقت:\n· التصحيح: تعديل اسمك أو صورتك أو أي معلومات حسابية.\n· النسخ الاحتياطي: طلب نسخة من جميع بياناتك التي بحوزتنا.\n· الحذف الدائم: طلب حذف حسابك بالكامل وجميع بياناتك من خوادمنا (سيتم الحذف نهائياً ولا يمكن استعادته).\nفترة الاحتفاظ بالبيانات: نحتفظ ببياناتك فقط طالما أن حسابك نشط. في حالة حذف الحساب، سيتم مسح جميع السجلات الخاصة بك بشكل آمن وفوري.',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // زر الموافقة والإغلاق
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'الموافقة وإغلاق',
                      style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 💬 نافذة إرسال الاقتراح
  void _showSuggestionDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0A1220),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اقتراح ميزة لتطوير التطبيق', style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  controller: _userSuggestionController,
                  maxLines: 3,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'اكتب ميزتك التوقعية المقترحة هنا...',
                    hintStyle: GoogleFonts.cairo(color: Colors.white24, fontSize: 11),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        if (_userSuggestionController.text.trim().isNotEmpty) {
                          // 🔮 هنا سنقوم بحفظ الاقتراح في السحابة لاحقاً
                          _userSuggestionController.clear();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('شكراً لاقتراحك الأسطوري! سيتم مراجعته فوراً 🚀', style: GoogleFonts.cairo())),
                          );
                        }
                      },
                      child: Text('إرسال الاقتراح', style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 📋 دالة فتح نافذة تسجيل الدخول
  void _showAuthBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A1220),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('انضم إلى عائلة NF Sports', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('سجل حسابك لتوقع التشكيلات والمناقشة حياً مع جماهير فريقك', textAlign: TextAlign.center, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 24),
              _buildAuthButton(
                icon: Icons.g_mobiledata_rounded,
                text: 'تسجيل الدخول عبر Google',
                color: const Color(0xFF4285F4),
                onTap: () {
                  Navigator.pop(context);
                  // 🔮 سيتم تفعيلها عند الربط السحابي
                },
              ),
              const SizedBox(height: 12),
              _buildAuthButton(
                icon: Icons.mail_outline_rounded,
                text: 'تسجيل الدخول عبر البريد الإلكتروني',
                color: AppTheme.neonBlue,
                onTap: () {
                  Navigator.pop(context);
                  // 🔮 سيتم تفعيلها عند الربط السحابي
                },
              ),
              const SizedBox(height: 12),
              _buildAuthButton(
                icon: Icons.phone_android_rounded,
                text: 'تسجيل الدخول عبر رقم الهاتف',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  // 🔮 سيتم تفعيلها عند الربط السحابي
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(text, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 🏗️ بناء واجهة المستخدم الرئيسية
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('المزيد', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildUserProfileCard(),
            const SizedBox(height: 20),
            _buildSettingsSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        borderRadius: 20,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, _) {
                  return Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.neonBlue.withOpacity(0.3 + (_glowController.value * 0.5)),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonBlue.withOpacity(0.2 * _glowController.value),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      child: Text(
                        _isLoading ? '...' : (_isLoggedIn ? _avatarLetter : 'G'),
                        style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              if (_isLoading)
                const SizedBox(width: 100, child: LinearProgressIndicator(color: AppTheme.neonBlue))
              else ...[
                Text(
                  _isLoggedIn ? _userName : 'زائر منصة NF Sports',
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _isLoggedIn ? _userBio : 'سجل حسابك لفتح كامل المزايا التفاعلية',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(color: Colors.white38, fontSize: 11),
                ),
                if (_isLoggedIn) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text('التوقعات الصحيحة المتطابقة:', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11)),
                        Text(
                          '🏆 $_correctPredictions',
                          style: GoogleFonts.cairo(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _showAuthBottomSheet,
                    child: Text('تسجيل الدخول الفوري', style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        borderRadius: 20,
        child: Column(
          children: [
            _buildSettingTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: Colors.amberAccent,
              title: 'سياسة الخصوصية والشروط',
              subtitle: 'معايير الأمان ومعالجة البيانات الرسمية',
              onTap: _openPrivacyPolicyPage,
            ),
            Divider(color: Colors.white.withOpacity(0.03), height: 1, indent: 20, endIndent: 20),
            _buildSettingTile(
              icon: Icons.assistant_photo_outlined,
              iconColor: Colors.cyanAccent,
              title: 'اقتراح ميزة أو إرسال تقرير',
              subtitle: 'شاركنا أفكارك لتطوير المنصة الرياضية',
              onTap: _showSuggestionDialog,
            ),
            Divider(color: Colors.white.withOpacity(0.03), height: 1, indent: 20, endIndent: 20),
            _buildSettingTile(
              icon: Icons.share_rounded,
              iconColor: Colors.purpleAccent,
              title: 'مشاركة التطبيق مع الأصدقاء',
              subtitle: 'انشر المنصة في مجتمعات كرة القدم',
              onTap: _shareAppLink,
            ),
            if (_isLoggedIn) ...[
              Divider(color: Colors.white.withOpacity(0.03), height: 1, indent: 20, endIndent: 20),
              _buildSettingTile(
                icon: Icons.logout_rounded,
                iconColor: Colors.redAccent,
                title: 'تسجيل الخروج من الحساب',
                subtitle: 'العودة كزائر للمنصة دون حفظ البيانات الحية',
                onTap: _handleLogout,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white12, size: 14),
          ],
        ),
      ),
    );
  }
}
