/// Featured content entity for home screen scheduling
class FeaturedContent {
  final String id;
  final String contentType; // 'workout', 'recipe', 'program', 'challenge'
  final String contentId;
  final String? title;
  final DateTime scheduledDate;
  final String position; // 'home', 'workouts', 'nutrition'
  final bool isActive;
  final DateTime? createdAt;

  const FeaturedContent({
    required this.id,
    required this.contentType,
    required this.contentId,
    this.title,
    required this.scheduledDate,
    this.position = 'home',
    this.isActive = true,
    this.createdAt,
  });

  factory FeaturedContent.fromJson(Map<String, dynamic> json) {
    return FeaturedContent(
      id: json['id'] as String,
      contentType: json['content_type'] as String,
      contentId: json['content_id'] as String,
      title: json['title'] as String?,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      position: json['position'] as String? ?? 'home',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
