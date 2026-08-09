class MatchModel {
  final String id;
  final String leagueName;
  final String homeTeam;
  final String awayTeam;
  final String? homeLogo;
  final String? awayLogo;
  final DateTime matchDate;
  final String status;
  final String? homeScore;
  final String? awayScore;
  final List<String> homeForm;
  final List<String> awayForm;
  final String? countdown;
  final String? homeScorer;
  final String? awayScorer;

  const MatchModel({
    required this.id,
    required this.leagueName,
    required this.homeTeam,
    required this.awayTeam,
    this.homeLogo,
    this.awayLogo,
    required this.matchDate,
    required this.status,
    this.homeScore,
    this.awayScore,
    this.homeForm = const [],
    this.awayForm = const [],
    this.countdown,
    this.homeScorer,
    this.awayScorer,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'].toString(),
      leagueName: json['league_name'] ?? '',
      homeTeam: json['home_team'] ?? '',
      awayTeam: json['away_team'] ?? '',
      homeLogo: json['home_logo'],
      awayLogo: json['away_logo'],
      matchDate: DateTime.parse(json['match_date']),
      status: json['status'] ?? 'scheduled',
      homeScore: json['home_score']?.toString(),
      awayScore: json['away_score']?.toString(),
      homeForm: List<String>.from(json['home_form'] ?? []),
      awayForm: List<String>.from(json['away_form'] ?? []),
      countdown: json['countdown'],
      homeScorer: json['home_scorer'],
      awayScorer: json['away_scorer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'league_name': leagueName,
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_logo': homeLogo,
      'away_logo': awayLogo,
      'match_date': matchDate.toIso8601String(),
      'status': status,
      'home_score': homeScore,
      'away_score': awayScore,
      'home_form': homeForm,
      'away_form': awayForm,
      'countdown': countdown,
      'home_scorer': homeScorer,
      'away_scorer': awayScorer,
    };
  }
}
