import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_plan.freezed.dart';
part 'training_plan.g.dart';

/// Personalized training plan for private coaching clients
@freezed
class TrainingPlan with _$TrainingPlan {
  const factory TrainingPlan({
    required String id,
    required String coachId,
    required String clientUserId,
    required String title,
    String? description,
    required DateTime startDate,
    DateTime? endDate,
    int? durationWeeks,
    required TrainingPlanStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TrainingPlan;

  factory TrainingPlan.fromJson(Map<String, dynamic> json) =>
      _$TrainingPlanFromJson(json);
}

/// Status of a training plan
enum TrainingPlanStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('archived')
  archived,
}

/// A scheduled workout within a training plan
@freezed
class TrainingPlanWorkout with _$TrainingPlanWorkout {
  const factory TrainingPlanWorkout({
    required String id,
    required String trainingPlanId,
    required String workoutId,
    required DateTime scheduledDate,
    int? weekNumber,
    int? dayOfWeek,
    String? coachNotes,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    required DateTime createdAt,
    // Populated from join
    String? workoutTitle,
    int? workoutDurationMinutes,
    String? workoutType,
    String? workoutThumbnailUrl,
  }) = _TrainingPlanWorkout;

  factory TrainingPlanWorkout.fromJson(Map<String, dynamic> json) =>
      _$TrainingPlanWorkoutFromJson(json);
}

/// Extension methods for TrainingPlan
extension TrainingPlanX on TrainingPlan {
  /// Check if the plan is currently active
  bool get isActive => status == TrainingPlanStatus.active;

  /// Check if the plan is editable (draft)
  bool get isDraft => status == TrainingPlanStatus.draft;

  /// Get the progress percentage based on dates
  double getProgressPercentage() {
    if (endDate == null) return 0.0;
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0.0;
    if (now.isAfter(endDate!)) return 1.0;

    final totalDays = endDate!.difference(startDate).inDays;
    final elapsedDays = now.difference(startDate).inDays;
    return totalDays > 0 ? elapsedDays / totalDays : 0.0;
  }

  /// Get remaining weeks
  int? get remainingWeeks {
    if (endDate == null) return null;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return 0;
    return endDate!.difference(now).inDays ~/ 7;
  }
}

/// Extension methods for TrainingPlanWorkout
extension TrainingPlanWorkoutX on TrainingPlanWorkout {
  /// Check if the workout is scheduled for today
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  /// Check if the workout is in the past but not completed
  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final scheduleEnd = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      23,
      59,
      59,
    );
    return now.isAfter(scheduleEnd);
  }

  /// Check if the workout is upcoming
  bool get isUpcoming {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDay = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );
    return scheduleDay.isAfter(today);
  }
}
