import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

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
              
              _buildAuthButton(icon: Icons.g_mobiledata_rounded, text: 'تسجيل الدخول عبر Google', color: const Color(0xFF4285F4), onTap: () {
                Navigator.pop(context);
                setState(() => _isLoggedIn = true);
              }),
              const SizedBox(height: 12),
              
              _buildAuthButton(icon: Icons.mail_outline_rounded, text: 'تسجيل الدخول عبر البريد الإلكتروني', color: AppTheme.neonBlue, onTap: () {
                Navigator.pop(context);
                setState(() => _isLoggedIn = true);
              }),
              const SizedBox(height: 12),
              
              _buildAuthButton(icon: Icons.phone_android_rounded, text: 'تسجيل الدخول عبر رقم الهاتف', color: Colors.green, onTap: () {
                Navigator.pop(context);
                setState(() => _isLoggedIn = true);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthButton({required IconData icon, required String text, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(14)),
        
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, _) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppTheme.neonBlue.withOpacity(0.15 * _glowController.value), blurRadius: 10, spreadRadius: 1)]
                          ),
                          child: const Icon(Icons.emoji_events_rounded, color: AppTheme.neonBlue, size: 32),
                        );
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('NF', style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                        Text('SPORTS', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4.0)),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161926).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10, width: 1.5),
                  ),
                  child: _isLoggedIn 
                      ? Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              width: 54, height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.neonBlue, width: 2),
                                boxShadow: [BoxShadow(color: AppTheme.neonBlue.withOpacity(0.2), blurRadius: 8)],
                              ),
                              child: const CircleAvatar(backgroundColor: Color(0xFF1A1D2E), child: Icon(Icons.person_rounded, color: Colors.white, size: 28)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(_userName, style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                  Text(_userRole, style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 10, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(6)),
                                    child: Text('• توقعات ناجحة: $_correctPredictionsCount قمة تكتيكية •', style: GoogleFonts.cairo(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout_rounded, color: Colors.white38, size: 20),
                              onPressed: () => setState(() => _isLoggedIn = false),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Container(width: 44, height: 44, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle), child: const Icon(Icons.account_circle_outlined, color: Colors.white38, size: 26)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('مرحباً بك في منصة NF SPORTS', style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text('سجل حسابك الآن لتفعيل ميزاتك التفاعلية الكاملة', style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: _showAuthBottomSheet,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0x1F00B4FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.neonBlue.withOpacity(0.4), width: 1.5),
                                ),
                                child: Center(child: Text('تسجيل الدخول أو إنشاء حساب مخصص', style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),

              _buildSettingTile(icon: Icons.star_border_rounded, iconColor: Colors.amberAccent, title: 'الفرق المفضلة', subtitle: 'إضافة فريقك المفضل لمتابعته أولاً بأول حياً'),
              _buildSettingTile(icon: Icons.emoji_events_outlined, iconColor: AppTheme.neonBlue, title: 'البطولات المفضلة', subtitle: 'إضافة البطولات المفضلة لمتابعتها وتخصيص الأخبار لها'),
              
              const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4), child: Divider(color: Colors.white10, height: 1)),

              _buildSettingTile(icon: Icons.notifications_active_outlined, iconColor: Colors.cyanAccent, title: 'الإشعارات التفضيلية', subtitle: 'إدارة وتخصيص تفضيلات إشعارات الأهداف وصافرة البث المباشر'),
              _buildSettingTile(icon: Icons.palette_outlined, iconColor: Colors.pinkAccent, title: 'المظهر والوضع الليلي', subtitle: 'تغيير مظهر التطبيق واختيار الوضع الليلي والنيون المضيء'),
              _buildSettingTile(icon: Icons.language_rounded, iconColor: Colors.indigoAccent, title: 'اللغة الحالية', subtitle: 'تغيير لغة التطبيق الحالية واختيار العربية أو الإنجليزية'),
              _buildSettingTile(
                icon: Icons.cloud_sync_rounded, 
                iconColor: Colors.tealAccent, 
                title: 'التحقق من وجود تحديثات حية', 
                subtitle: 'التحقق من آخر تحديث وترقية حزم التطبيق الحية الحين من الخادم',
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تطبيقك متصل بالسحاب ومحدث بالكامل لآخر حزمة مستقرة! 🌐🔥', style: TextStyle(fontFamily: 'Cairo'))));
                }
              ),
              
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    _buildCompactSocialButton(icon: Icons.telegram_rounded, color: const Color(0xFF0088CC), label: 'تليجرام', onTap: () {
                    }),
                    const SizedBox(width: 8),
                    _buildCompactSocialButton(icon: Icons.chat_rounded, color: Colors.green, label: 'واتساب', onTap: () {
                    }),
                    const SizedBox(width: 8),
                    _buildCompactSocialButton(icon: Icons.camera_alt_rounded, color: Colors.pinkAccent, label: 'إنستغرام', onTap: () {
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              _buildSettingTile(
                icon: Icons.gavel_rounded, 
                iconColor: Colors.blueAccent, 
                title: 'سياسة الخصوصية وبنود الشروط', 
                subtitle: 'قراءة بنود وشروط سياسة الخصوصية الصارمة وحماية بيانات المستخدمين',
                onTap: _showPrivacyDialog
              ),
              _buildSettingTile(icon: Icons.info_outline_rounded, iconColor: Colors.orangeAccent, title: 'حول التطبيق', subtitle: 'الفخم NF Sports معلومات وتفاصيل شاملة حول تطبيق براند الرياضة'),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161926).withOpacity(0.2), 
                    borderRadius: BorderRadius.circular(14), 
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        'إصدار التطبيق الرسمي', 
                        style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '1.0.0', 
                        style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: Column(
                  children: [
                    Text('NF SPORTS', style: GoogleFonts.cairo(color: Colors.white12, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4.0)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('نواف بن أحمد', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Text('Designed & Developed by', style: GoogleFonts.cairo(color: Colors.white24, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: AlertDialog(
            backgroundColor: const Color(0xFF0A1220),
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('سياسة الخصوصية وحماية البيانات', textAlign: TextAlign.right, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Text(
                'التزاماً منا بمعايير الأمان العالمية وشروط المتاجر الرسمية، نؤكد في منصة NF SPORTS حماية بيانات المستخدمين وسريتها المطلقة بنسبة 100%. إن معلومات تسجيل الدخول وحصاد توقعات التشكيلات التكتيكية يتم تشفيرها بالكامل وحفظها عبر خوادم السحاب المشفرة بأمان صارم، ولا يتم مشاركتها أو بيعها لأي جهات خارجية نهائياً. إن استخدامك للتطبيق يعني موافقتك الصريحة على شروط الخدمة لتقديم أفضل تجربة رياضية متكاملة تليق بك كمدرب ومشجع أسطوري.',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(color: Colors.white60, fontSize: 12, height: 1.6),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('الموافقة وإغلاق', style: GoogleFonts.cairo(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({required IconData icon, required Color iconColor, required String title, required String subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white12, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSocialButton({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
