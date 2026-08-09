class HighlightModel {
  final String id;
  final String? matchId;
  final String title;
  final String? thumbnailUrl;
  final String? videoUrl;
  final String duration;
  final DateTime? createdAt;

  HighlightModel({
    required this.id,
    this.matchId,
    required this.title,
    this.thumbnailUrl,
    this.videoUrl,
    required this.duration,
    this.createdAt,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json['id']?.toString() ?? '',
      matchId: json['match_id']?.toString(),
      title: json['title'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
      duration: json['duration'] ?? '00:00',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'duration': duration,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
