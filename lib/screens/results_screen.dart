import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

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
              // 🏆 1. الهيدر البانورامي العلوي الكاسح مع كأس دوري الأبطال النيوني
              Container(
                width: double.infinity,
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://unsplash.com'),
                    fit: BoxFit.cover,
                    opacity: 0.15,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF060B14), Colors.transparent, Color(0xFF060B14)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NF', style: TextStyle(color: AppTheme.neonBlue, fontSize: 38, fontWeight: FontWeight.bold, shadows: [Shadow(color: AppTheme.neonBlue.withValues(alpha: 0.8), blurRadius: 20)])),
                          const Text('SPORTS', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 3)),
                        ],
                      ),
                      const Icon(
                        Icons.emoji_events, 
                        color: Color(0xFF00B4FF), 
                        size: 90, 
                        shadows: [Shadow(color: Color(0xFF00B4FF), blurRadius: 30)],
                      ),
                    ],
                  ),
                ),
              ),

              // عنوان الصفحة الحاد والمحاذي لليمين
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('المزيد', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      SizedBox(width: 8),
                      Text('|', style: TextStyle(color: AppTheme.neonBlue, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 👤 2. كارد الترحيب والتسجيل الزجاجي المضيء
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 22,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(color: Color(0x1AFFFFFF), shape: BoxShape.circle),
                        child: const Icon(Icons.person, color: Colors.white54, size: 34),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(alignment: Alignment.centerRight, child: Text('مرحباً بك في NF Sports 👋', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                            const SizedBox(height: 4),
                            const Align(alignment: Alignment.centerRight, child: Text('ساعدنا في تقديم تجربة رياضية مخصصة لك.', style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo'))),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0x3300B4FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.neonBlue, width: 1.5),
                                  boxShadow: const [BoxShadow(color: Color(0x3200B4FF), blurRadius: 8)],
                                ),
                                child: const Center(child: Text('تسجيل الدخول أو إنشاء حساب', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 🧑‍💻 3. كارد المطور الأسطوري نواف بن أحمد المصلح والثابت
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 22,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 90,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage('https://unsplash.com'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white10, width: 1),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: const Color(0xCC060B14), borderRadius: BorderRadius.circular(6)),
                                child: const Text('NF', style: TextStyle(color: AppTheme.neonBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(alignment: Alignment.centerRight, child: Text('المطور 🥷', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                            Align(alignment: Alignment.centerRight, child: Text('نواف بن أحمد', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                            Align(alignment: Alignment.centerRight, child: Text('مؤسس ومطور تطبيق NF Sports', style: TextStyle(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                            SizedBox(height: 6),
                            Align(alignment: Alignment.centerRight, child: Text('شكراً لاستخدامك NF Sports. نعمل باستمرار على تطوير التطبيق لتقديم أفضل تجربة رياضية ممكنة.', textAlign: TextAlign.right, style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo'))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ⚙️ 4. قائمة الخيارات والإعدادات الـ 10 النيونية المنسقة بالملي (RTL)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  borderRadius: 22,
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.star_border, 'الفرق المفضلة', 'إضافة فريقك المفضل لمتابعته أولاً بأول'),
                      _buildDivider(),
                      _buildMenuItem(Icons.emoji_events, 'البطولات المفضلة', 'إضافة البطولات المفضلة لمتابعتها وتخصيص الأخبار'),
                      _buildDivider(),
                      _buildMenuItem(Icons.notifications_none, 'الإشعارات', 'إدارة تفضيلات الإشعارات المباشرة للمجريات والأخبار'),
                      _buildDivider(),
                      _buildMenuItem(Icons.brightness_3, 'المظهر', 'تغيير مظهر التطبيق واختيار الوضع الليلي والنيون المضيء'),
                      _buildDivider(),
                      _buildMenuItem(Icons.language, 'اللغة', 'تغيير لغة التطبيق الحالية واختيار العربية أو الإنجليزية'),
                      _buildDivider(),
                      _buildMenuItem(Icons.cloud_download, 'التحقق من وجود تحديثات', 'التحقق من آخر تحديث وترقية حزم التطبيق الحية الحين'),
                      _buildDivider(),
                      _buildMenuItem(Icons.chat_bubble_outline, 'تواصل معنا', 'تواصل معنا وشارك اقتراحاتك لتطوير التطبيق للعالمية'),
                      _buildDivider(),
                      _buildMenuItem(Icons.star_outline, 'قيم التطبيق', 'شاركونا رأيكم عن التطبيق وتقييمه على المتاجر الرسمية'),
                      _buildDivider(),
                      _buildMenuItem(Icons.assignment_outlined, 'سياسة الخصوصية', 'قراءة بنود وشروط سياسة الخصوصية وحماية بيانات المستخدم'),
                      _buildDivider(),
                      _buildMenuItem(Icons.info_outline, 'حول التطبيق', 'معلومات وتفاصيل شاملة حول تطبيق NF Sports الفخم'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ⏱️ 5. مستطيل البيانات الفنية السفلي المنسق بالكامل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: 18,
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Icon(Icons.schedule, color: Colors.white38, size: 16),
                              SizedBox(width: 8),
                              Text('إصدار التطبيق', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
                            ],
                          ),
                          Text('1.0.0', style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Icon(Icons.history, color: Colors.white38, size: 16),
                              SizedBox(width: 8),
                              Text('آخر تحديث', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
                            ],
                          ),
                          Text('اليوم', style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 👑 6. التوقيع الملكي النهائي للتطبيق وتوثيق اسم نواف بن أحمد كمالك ومطور للتطبيق
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('NF', style: TextStyle(color: AppTheme.neonBlue, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(color: AppTheme.neonBlue.withValues(alpha: 0.6), blurRadius: 10)])),
                        const SizedBox(width: 4),
                        const Text('SPORTS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Designed & Developed by',
                      style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'نواف بن أحمد',
                      style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Made with ', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                        Icon(Icons.favorite, color: Colors.redAccent.withValues(alpha: 0.6), size: 11),
                        const Text(' for Football Fans', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
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

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: const Color(0xFF00B4FF), size: 22, shadows: const [Shadow(color: Color(0xFF00B4FF), blurRadius: 10)]),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(alignment: Alignment.centerRight, child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))),
                  const SizedBox(height: 2),
                  Align(alignment: Alignment.centerRight, child: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo'))),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Colors.white10, height: 1),
    );
  }
}
