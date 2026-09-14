// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainingPlanImpl _$$TrainingPlanImplFromJson(Map<String, dynamic> json) =>
    _$TrainingPlanImpl(
      id: json['id'] as String,
      coachId: json['coachId'] as String,
      clientUserId: json['clientUserId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      durationWeeks: (json['durationWeeks'] as num?)?.toInt(),
      status: $enumDecode(_$TrainingPlanStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TrainingPlanImplToJson(_$TrainingPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coachId': instance.coachId,
      'clientUserId': instance.clientUserId,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'durationWeeks': instance.durationWeeks,
      'status': _$TrainingPlanStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TrainingPlanStatusEnumMap = {
  TrainingPlanStatus.draft: 'draft',
  TrainingPlanStatus.active: 'active',
  TrainingPlanStatus.completed: 'completed',
  TrainingPlanStatus.archived: 'archived',
};

_$TrainingPlanWorkoutImpl _$$TrainingPlanWorkoutImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingPlanWorkoutImpl(
      id: json['id'] as String,
      trainingPlanId: json['trainingPlanId'] as String,
      workoutId: json['workoutId'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      weekNumber: (json['weekNumber'] as num?)?.toInt(),
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
      coachNotes: json['coachNotes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      workoutTitle: json['workoutTitle'] as String?,
      workoutDurationMinutes: (json['workoutDurationMinutes'] as num?)?.toInt(),
      workoutType: json['workoutType'] as String?,
      workoutThumbnailUrl: json['workoutThumbnailUrl'] as String?,
    );

Map<String, dynamic> _$$TrainingPlanWorkoutImplToJson(
        _$TrainingPlanWorkoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainingPlanId': instance.trainingPlanId,
      'workoutId': instance.workoutId,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'weekNumber': instance.weekNumber,
      'dayOfWeek': instance.dayOfWeek,
      'coachNotes': instance.coachNotes,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'workoutTitle': instance.workoutTitle,
      'workoutDurationMinutes': instance.workoutDurationMinutes,
      'workoutType': instance.workoutType,
      'workoutThumbnailUrl': instance.workoutThumbnailUrl,
    };
