import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// In-app notification
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String userId,
    required String type,
    required String title,
    String? body,
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

/// Notification types
class NotificationType {
  static const coachingAccepted = 'coaching_accepted';
  static const coachingDeclined = 'coaching_declined';
  static const newTrainingPlan = 'new_training_plan';
  static const trainingPlanUpdated = 'training_plan_updated';
  static const workoutReminder = 'workout_reminder';
  static const newWorkoutAssigned = 'new_workout_assigned';
  static const streakMilestone = 'streak_milestone';
  static const badgeEarned = 'badge_earned';
}

/// Extension methods for AppNotification
extension AppNotificationX on AppNotification {
  /// Get the icon for this notification type
  String get iconName {
    switch (type) {
      case NotificationType.coachingAccepted:
      case NotificationType.coachingDeclined:
        return 'user_check';
      case NotificationType.newTrainingPlan:
      case NotificationType.trainingPlanUpdated:
        return 'calendar';
      case NotificationType.workoutReminder:
      case NotificationType.newWorkoutAssigned:
        return 'dumbbell';
      case NotificationType.streakMilestone:
        return 'flame';
      case NotificationType.badgeEarned:
        return 'trophy';
      default:
        return 'bell';
    }
  }

  /// Check if this notification is related to coaching
  bool get isCoachingRelated =>
      type == NotificationType.coachingAccepted ||
      type == NotificationType.coachingDeclined ||
      type == NotificationType.newTrainingPlan ||
      type == NotificationType.trainingPlanUpdated ||
      type == NotificationType.newWorkoutAssigned;
}
