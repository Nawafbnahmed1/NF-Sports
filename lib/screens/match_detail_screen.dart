import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/details_tab.dart';
import 'tabs/lineup_tab.dart';

class MatchDetailScreen extends StatefulWidget {
  final String team1;
  final String team2;

  const MatchDetailScreen({super.key, required this.team1, required this.team2});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تفاصيل المباراة',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white38, size: 42), const SizedBox(height: 8), Text(widget.team1, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))])),
                Column(
                  children: [
                    const Text('3 - 1', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0x1A00FF00), borderRadius: BorderRadius.circular(8)),
                      child: const Text('انتهت', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ),
                  ],
                ),
                Expanded(child: Column(children: [const Icon(Icons.shield, color: Colors.white38, size: 42), const SizedBox(height: 8), Text(widget.team2, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'))])),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // شريط التبويبات المزدوج
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10, width: 1),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0x2600B4FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.neonBlue, width: 1.5),
                ),
                labelColor: AppTheme.neonBlue,
                unselectedLabelColor: Colors.white38,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                tabs: const [
                  Tab(text: 'تفاصيل المباراة'),
                  Tab(text: 'التشكيلات'),
                ],
              ),
            ),
          ),

          // عرض الصفحات الفرعية التفاعلية المستقلة
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                DetailsTab(),
                LineupTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
