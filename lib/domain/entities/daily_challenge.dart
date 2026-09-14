/// Daily challenge entity
class DailyChallenge {
  final String id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String challengeType;
  final int targetValue;
  final String targetUnit;
  final int points;
  final String difficulty;
  final int durationMinutes;
  final DateTime scheduledDate;
  final bool isActive;
  final DateTime? createdAt;

  const DailyChallenge({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.challengeType = 'reps',
    this.targetValue = 100,
    this.targetUnit = 'reps',
    this.points = 50,
    this.difficulty = 'medium',
    this.durationMinutes = 15,
    required this.scheduledDate,
    this.isActive = true,
    this.createdAt,
  });

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      challengeType: json['challenge_type'] as String? ?? 'reps',
      targetValue: json['target_value'] as int? ?? 100,
      targetUnit: json['target_unit'] as String? ?? 'reps',
      points: json['points'] as int? ?? 50,
      difficulty: json['difficulty'] as String? ?? 'medium',
      durationMinutes: json['duration_minutes'] as int? ?? 15,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  String get targetDisplay => '$targetValue $targetUnit';
}
