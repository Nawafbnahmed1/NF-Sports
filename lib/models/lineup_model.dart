class LineupModel {
  final String id;
  final String matchId;
  final String team;
  final String formation;
  final List<Map<String, dynamic>> players;

  const LineupModel({
    required this.id,
    required this.matchId,
    required this.team,
    required this.formation,
    required this.players,
  });

  factory LineupModel.fromJson(Map<String, dynamic> json) {
    return LineupModel(
      id: json['id']?.toString() ?? '',
      matchId: json['match_id']?.toString() ?? '',
      team: json['team'] ?? '',
      formation: json['formation'] ?? '',
      players: List<Map<String, dynamic>>.from(json['players'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'team': team,
      'formation': formation,
      'players': players,
    };
  }
}
