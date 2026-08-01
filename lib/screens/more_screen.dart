import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  bool _isLoggedIn = false;
  String _userName = "نواف بن أحمد";
  String _userRole = "مؤسس ومطور تطبيق NF Sports";
  int _correctPredictionsCount = 24;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _userSuggestionController.dispose();
    super.dispose();
  }
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
              Text('انضم إلى عائلة NF SPORTS', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('سجل حسابك لتوقع التشكيلات والمناقشة حياً مع جماهير فريقك', textAlign: TextAlign.center, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 24),
              _buildAuthButton(
                icon: Icons.g_mobiledata_rounded,
                text: 'تسجيل الدخول عبر Google',
                color: const Color(0xFF4285F4),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _isLoggedIn = true);
                },
              ),
              const SizedBox(height: 12),
              _buildAuthButton(
                icon: Icons.mail_outline_rounded,
                text: 'تسجيل الدخول عبر البريد الإلكتروني',
                color: AppTheme.neonBlue,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _isLoggedIn = true);
                },
              ),
              const SizedBox(height: 12),
              _buildAuthButton(
                icon: Icons.phone_android_rounded,
                text: 'تسجيل الدخول عبر رقم الهاتف',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _isLoggedIn = true);
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
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'المزيد',
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
                        _isLoggedIn ? _userName.substring(0, 1) : 'G',
                        style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Text(
                _isLoggedIn ? _userName : 'زائر منصة NF Sports',
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _isLoggedIn ? _userRole : 'سجل حسابك لفتح كامل المزايا التفاعلية',
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
                        '🏆 $_correctPredictionsCount',
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
              onTap: _showPrivacyDialog,
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
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم نسخ رابط المشاركة بنجاح! 🚀', style: GoogleFonts.cairo())),
                );
              },
            ),
            if (_isLoggedIn) ...[
              Divider(color: Colors.white.withOpacity(0.03), height: 1, indent: 20, endIndent: 20),
              _buildSettingTile(
                icon: Icons.logout_rounded,
                iconColor: Colors.redAccent,
                title: 'تسجيل الخروج من الحساب',
                subtitle: 'العودة كزائر للمنصة دون حفظ البيانات الحية',
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setState(() => _isLoggedIn = false);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0A1220),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: AlertDialog(
            backgroundColor: const Color(0xFF0A1220),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'سياسة الخصوصية وحماية البيانات',
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Text(
                'منصة NF SPORTS تلتزم تماماً بمعايير الأمان العالمية وشروط المتاجر الرسمية، نؤكد في منصة نواف بن أحمد أن جميع بيانات التوقعات والأسماء مشفرة ومحمية بالكامل ولا يتم مشاركتها مع أي جهة خارجية لضمان تجربة رياضية آمنة.',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(color: Colors.white60, fontSize: 12, height: 1.6),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'الموافقة وإغلاق',
                  style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
                Text(
                  'اقتراح ميزة لتطوير التطبيق',
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
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
                  Text(
                    title,
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10),
                  ),
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
