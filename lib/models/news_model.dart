class NewsModel {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? source;
  final String category;
  final DateTime publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.source,
    required this.category,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      source: json['source'],
      category: json['category'] ?? 'football',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'source': source,
      'category': category,
      'published_at': publishedAt.toIso8601String(),
    };
  }
}
