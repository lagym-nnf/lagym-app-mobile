/// Motivational quote entity
class Quote {
  final String id;
  final String text;
  final String? author;
  final String? category;
  final DateTime? scheduledDate;
  final bool isActive;
  final DateTime? createdAt;

  const Quote({
    required this.id,
    required this.text,
    this.author,
    this.category,
    this.scheduledDate,
    this.isActive = true,
    this.createdAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String?,
      category: json['category'] as String?,
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
