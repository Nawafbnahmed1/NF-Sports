class MatchModel {
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final String league;
  final String matchTime;
  final String status;

  const MatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.league,
    required this.matchTime,
    required this.status,
  });

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      homeTeam: map['home_team'] ?? '',
      awayTeam: map['away_team'] ?? '',
      homeLogo: map['home_logo'] ?? '',
      awayLogo: map['away_logo'] ?? '',
      league: map['league'] ?? '',
      matchTime: map['match_time'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_logo': homeLogo,
      'away_logo': awayLogo,
      'league': league,
      'match_time': matchTime,
      'status': status,
    };
  }
}
