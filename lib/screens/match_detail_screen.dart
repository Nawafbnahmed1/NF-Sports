import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/lineup_tab.dart';
import 'tabs/details_tab.dart';
import 'tabs/stats_tab.dart';

class MatchDetailScreen extends StatefulWidget {
  final String team1;
  final String team2;

  const MatchDetailScreen({
    super.key,
    required this.team1,
    required this.team2,
  });

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تفاصيل المباراة',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.neonBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 الرأس الملكي العلوي لعرض مواجهة الفرق الكبرى والنتيجة الفخمة
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: AppTheme.surfaceColor.withValues(alpha: 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderTeam(widget.team1, Icons.shield),
                  Column(
                    children: [
                      const Text(
                        '٣ - ١',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                        child: const Text('انتهت', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                    ],
                  ),
                  _buildHeaderTeam(widget.team2, Icons.shield),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // 🌟 2. شريط التبويبات الزجاجي المضيء بالنيون المتوهج (نفس تخطيط صورك بالملي)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.neonBlue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppTheme.neonBlue,
                  unselectedLabelColor: Colors.white38,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                  unselectedLabelStyle: const TextStyle(fontSize: 13, fontFamily: 'Cairo'),
                  indicator: BoxDecoration(
                    color: AppTheme.neonBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.neonBlue, width: 1.2),
                  ),
                  tabs: const [
                    Tab(text: 'التفاصيل'),
                    Tab(text: 'التشكيلات'),
                    Tab(text: 'الإحصائيات'),
                  ],
                ),
              ),
            ),
            // 🌟 3. مساحة عرض محتويات الملفات الثلاثة المستقلة والمخففة
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  DetailsTab(),  // استدعاء ملف الأحداث والمجريات بالدقائق
                  LineupTab(),   // استدعاء ملف عشب الملعب وشعار تطبيقك المضيء
                  StatsTab(),    // استدعاء ملف المقارنات الرقمية ومؤشرات التفوق
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTeam(String name, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          child: Icon(icon, color: Colors.white70, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
      ],
    );
  }
}
