class MatchDetailModel {
  final String id;
  final String matchId;
  final int possessionHome;
  final int possessionAway;
  final int shotsHome;
  final int shotsAway;
  final int foulsHome;
  final int foulsAway;
  final List<String> homeInjuries;
  final List<String> awayInjuries;
  final List<Map<String, dynamic>> events;

  const MatchDetailModel({
    required this.id,
    required this.matchId,
    required this.possessionHome,
    required this.possessionAway,
    required this.shotsHome,
    required this.shotsAway,
    required this.foulsHome,
    required this.foulsAway,
    required this.homeInjuries,
    required this.awayInjuries,
    required this.events,
  });

  factory MatchDetailModel.fromJson(Map<String, dynamic> json) {
    return MatchDetailModel(
      id: json['id']?.toString() ?? '',
      matchId: json['match_id']?.toString() ?? '',
      possessionHome: json['possession_home'] ?? 0,
      possessionAway: json['possession_away'] ?? 0,
      shotsHome: json['shots_home'] ?? 0,
      shotsAway: json['shots_away'] ?? 0,
      foulsHome: json['fouls_home'] ?? 0,
      foulsAway: json['fouls_away'] ?? 0,
      homeInjuries: List<String>.from(json['home_injuries'] ?? []),
      awayInjuries: List<String>.from(json['away_injuries'] ?? []),
      events: List<Map<String, dynamic>>.from(json['events'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'possession_home': possessionHome,
      'possession_away': possessionAway,
      'shots_home': shotsHome,
      'shots_away': shotsAway,
      'fouls_home': foulsHome,
      'fouls_away': foulsAway,
      'home_injuries': homeInjuries,
      'away_injuries': awayInjuries,
      'events': events,
    };
  }
}
