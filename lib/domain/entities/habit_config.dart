/// Habit configuration entity
class HabitConfig {
  final String id;
  final String name;
  final String? description;
  final String icon;
  final int targetValue;
  final String targetUnit;
  final String? displayUnit;
  final String color;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;

  const HabitConfig({
    required this.id,
    required this.name,
    this.description,
    this.icon = 'heart',
    this.targetValue = 10000,
    this.targetUnit = 'steps',
    this.displayUnit,
    this.color = '#3B82F6',
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
  });

  String get displayText => displayUnit ?? '$targetValue $targetUnit';

  factory HabitConfig.fromJson(Map<String, dynamic> json) {
    return HabitConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String? ?? 'heart',
      targetValue: json['target_value'] as int? ?? 10000,
      targetUnit: json['target_unit'] as String? ?? 'steps',
      displayUnit: json['display_unit'] as String?,
      color: json['color'] as String? ?? '#3B82F6',
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}

/// User's habit tracking for a specific day
class HabitTracking {
  final String id;
  final String oderId;
  final String habitConfigId;
  final DateTime date;
  final int currentValue;
  final bool isCompleted;
  final DateTime? completedAt;

  const HabitTracking({
    required this.id,
    required this.oderId,
    required this.habitConfigId,
    required this.date,
    this.currentValue = 0,
    this.isCompleted = false,
    this.completedAt,
  });

  factory HabitTracking.fromJson(Map<String, dynamic> json) {
    return HabitTracking(
      id: json['id'] as String,
      oderId: json['user_id'] as String,
      habitConfigId: json['habit_config_id'] as String,
      date: DateTime.parse(json['date'] as String),
      currentValue: json['current_value'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}
