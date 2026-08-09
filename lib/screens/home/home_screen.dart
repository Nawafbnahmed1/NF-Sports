import 'package:flutter/material.dart';
import '../../services/match_service.dart';
import '../../services/news_service.dart';
import '../../services/highlight_service.dart';
import '../../models/match_model.dart';
import '../../models/news_model.dart';
import '../../models/highlight_model.dart';
import 'widgets/home_header.dart';
import 'widgets/featured_match_card.dart';
import 'widgets/news_preview_card.dart';
import 'widgets/highlights_preview_card.dart';
import '../../core/widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  final HighlightService _highlightService = HighlightService();

  late Future<List<MatchModel>> matches;
  late Future<List<NewsModel>> news;
  late Future<List<HighlightModel>> highlights;

  @override
  void initState() {
    super.initState();
    matches = MatchService.getTodayMatches();
    news = _newsService.getNews();
    highlights = _highlightService.getHighlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              matches = MatchService.getTodayMatches();
              news = _newsService.getNews();
              highlights = _highlightService.getHighlights();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const HomeHeader(),
                const SizedBox(height: 20),
                const SectionTitle(title: "مباريات اليوم"),
                FutureBuilder<List<MatchModel>>(
                  future: matches,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        "لا توجد مباريات حالياً",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return Column(
                      children: snapshot.data!
                          .map(
                            (match) => FeaturedMatchCard(
                              leagueName: match.leagueName,
                              homeTeam: match.homeTeam,
                              awayTeam: match.awayTeam,
                              matchTime: match.matchDate.toString(),
                              status: match.status,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SectionTitle(title: "آخر الأخبار"),
                FutureBuilder<List<NewsModel>>(
                  future: news,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    return Column(
                      children: snapshot.data!
                          .map(
                            (item) => NewsPreviewCard(
                              title: item.title,
                              time: item.publishedAt.toString(),
                              imageUrl: item.imageUrl,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SectionTitle(title: "أبرز الملخصات"),
                FutureBuilder<List<HighlightModel>>(
                  future: highlights,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    return Column(
                      children: snapshot.data!
                          .map(
                            (item) => HighlightsPreviewCard(
                              title: item.title,
                              duration: item.duration,
                              thumbnailUrl: item.thumbnailUrl,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
