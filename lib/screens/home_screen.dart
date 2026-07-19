import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_title.dart';
import '../widgets/neon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              // 1️⃣ الهيدر العلوي الاحترافي المضيء (NF SPORTS)
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
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: AppTheme.neonBlue.withValues(alpha: 0.6),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'SPORTS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // 2️⃣ قسم مباريات اليوم والعنوان المضيء
              const SectionTitle(title: 'مباريات اليوم'),

              // 3️⃣ بطاقة المباراة البرمجية الفخمة باللون الزجاجي والنيون
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTeamSection(Icons.sports_soccer, 'الهلال'),
                          const Column(
                            children: [
                              Text(
                                '21:45',
                                style: TextStyle(
                                  color: AppTheme.neonBlue,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'اليوم',
                                style: TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                          _buildTeamSection(Icons.sports_soccer, 'النصر'),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: Colors.white10, height: 1),
                      ),
                      NeonButton(
                        text: 'تفاصيل المباراة',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 4️⃣ قسم آخر الأخبار المضيء
              const SectionTitle(title: 'آخر الأخبار'),
              _buildHorizontalList(isNews: true),

              const SizedBox(height: 15),

              // 5️⃣ قسم أبرز اللقطات المضيء
              const SectionTitle(title: 'أبرز اللقطات'),
              _buildHorizontalList(isNews: false),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(IconData icon, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          child: Icon(icon, color: Colors.white70, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildHorizontalList({required bool isNews}) {
    return SizedBox(
      height: isNews ? 170 : 130,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: isNews ? 150 : 220,
            margin: const EdgeInsets.only(right: 15),
            child: GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 16,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      isNews ? Icons.newspaper : Icons.play_circle_outline,
                      color: Colors.white24,
                      size: isNews ? 32 : 44,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    left: 12,
                    child: Text(
                      isNews ? 'عنوان الخبر الرياضي...' : 'ملخص مباراة قوية...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
