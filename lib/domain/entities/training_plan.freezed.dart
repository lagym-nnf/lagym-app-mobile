// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainingPlan _$TrainingPlanFromJson(Map<String, dynamic> json) {
  return _TrainingPlan.fromJson(json);
}

/// @nodoc
mixin _$TrainingPlan {
  String get id => throw _privateConstructorUsedError;
  String get coachId => throw _privateConstructorUsedError;
  String get clientUserId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get durationWeeks => throw _privateConstructorUsedError;
  TrainingPlanStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TrainingPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingPlanCopyWith<TrainingPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingPlanCopyWith<$Res> {
  factory $TrainingPlanCopyWith(
          TrainingPlan value, $Res Function(TrainingPlan) then) =
      _$TrainingPlanCopyWithImpl<$Res, TrainingPlan>;
  @useResult
  $Res call(
      {String id,
      String coachId,
      String clientUserId,
      String title,
      String? description,
      DateTime startDate,
      DateTime? endDate,
      int? durationWeeks,
      TrainingPlanStatus status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$TrainingPlanCopyWithImpl<$Res, $Val extends TrainingPlan>
    implements $TrainingPlanCopyWith<$Res> {
  _$TrainingPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? clientUserId = null,
    Object? title = null,
    Object? description = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? durationWeeks = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _value.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationWeeks: freezed == durationWeeks
          ? _value.durationWeeks
          : durationWeeks // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TrainingPlanStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingPlanImplCopyWith<$Res>
    implements $TrainingPlanCopyWith<$Res> {
  factory _$$TrainingPlanImplCopyWith(
          _$TrainingPlanImpl value, $Res Function(_$TrainingPlanImpl) then) =
      __$$TrainingPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String coachId,
      String clientUserId,
      String title,
      String? description,
      DateTime startDate,
      DateTime? endDate,
      int? durationWeeks,
      TrainingPlanStatus status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$TrainingPlanImplCopyWithImpl<$Res>
    extends _$TrainingPlanCopyWithImpl<$Res, _$TrainingPlanImpl>
    implements _$$TrainingPlanImplCopyWith<$Res> {
  __$$TrainingPlanImplCopyWithImpl(
      _$TrainingPlanImpl _value, $Res Function(_$TrainingPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? clientUserId = null,
    Object? title = null,
    Object? description = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? durationWeeks = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TrainingPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      clientUserId: null == clientUserId
          ? _value.clientUserId
          : clientUserId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationWeeks: freezed == durationWeeks
          ? _value.durationWeeks
          : durationWeeks // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TrainingPlanStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingPlanImpl implements _TrainingPlan {
  const _$TrainingPlanImpl(
      {required this.id,
      required this.coachId,
      required this.clientUserId,
      required this.title,
      this.description,
      required this.startDate,
      this.endDate,
      this.durationWeeks,
      required this.status,
      required this.createdAt,
      this.updatedAt});

  factory _$TrainingPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String coachId;
  @override
  final String clientUserId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final int? durationWeeks;
  @override
  final TrainingPlanStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TrainingPlan(id: $id, coachId: $coachId, clientUserId: $clientUserId, title: $title, description: $description, startDate: $startDate, endDate: $endDate, durationWeeks: $durationWeeks, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.clientUserId, clientUserId) ||
                other.clientUserId == clientUserId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.durationWeeks, durationWeeks) ||
                other.durationWeeks == durationWeeks) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      coachId,
      clientUserId,
      title,
      description,
      startDate,
      endDate,
      durationWeeks,
      status,
      createdAt,
      updatedAt);

  /// Create a copy of TrainingPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingPlanImplCopyWith<_$TrainingPlanImpl> get copyWith =>
      __$$TrainingPlanImplCopyWithImpl<_$TrainingPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingPlanImplToJson(
      this,
    );
  }
}

abstract class _TrainingPlan implements TrainingPlan {
  const factory _TrainingPlan(
      {required final String id,
      required final String coachId,
      required final String clientUserId,
      required final String title,
      final String? description,
      required final DateTime startDate,
      final DateTime? endDate,
      final int? durationWeeks,
      required final TrainingPlanStatus status,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$TrainingPlanImpl;

  factory _TrainingPlan.fromJson(Map<String, dynamic> json) =
      _$TrainingPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get coachId;
  @override
  String get clientUserId;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  int? get durationWeeks;
  @override
  TrainingPlanStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of TrainingPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingPlanImplCopyWith<_$TrainingPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainingPlanWorkout _$TrainingPlanWorkoutFromJson(Map<String, dynamic> json) {
  return _TrainingPlanWorkout.fromJson(json);
}

/// @nodoc
mixin _$TrainingPlanWorkout {
  String get id => throw _privateConstructorUsedError;
  String get trainingPlanId => throw _privateConstructorUsedError;
  String get workoutId => throw _privateConstructorUsedError;
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  int? get weekNumber => throw _privateConstructorUsedError;
  int? get dayOfWeek => throw _privateConstructorUsedError;
  String? get coachNotes => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Populated from join
  String? get workoutTitle => throw _privateConstructorUsedError;
  int? get workoutDurationMinutes => throw _privateConstructorUsedError;
  String? get workoutType => throw _privateConstructorUsedError;
  String? get workoutThumbnailUrl => throw _privateConstructorUsedError;

  /// Serializes this TrainingPlanWorkout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingPlanWorkout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingPlanWorkoutCopyWith<TrainingPlanWorkout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingPlanWorkoutCopyWith<$Res> {
  factory $TrainingPlanWorkoutCopyWith(
          TrainingPlanWorkout value, $Res Function(TrainingPlanWorkout) then) =
      _$TrainingPlanWorkoutCopyWithImpl<$Res, TrainingPlanWorkout>;
  @useResult
  $Res call(
      {String id,
      String trainingPlanId,
      String workoutId,
      DateTime scheduledDate,
      int? weekNumber,
      int? dayOfWeek,
      String? coachNotes,
      bool isCompleted,
      DateTime? completedAt,
      DateTime createdAt,
      String? workoutTitle,
      int? workoutDurationMinutes,
      String? workoutType,
      String? workoutThumbnailUrl});
}

/// @nodoc
class _$TrainingPlanWorkoutCopyWithImpl<$Res, $Val extends TrainingPlanWorkout>
    implements $TrainingPlanWorkoutCopyWith<$Res> {
  _$TrainingPlanWorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingPlanWorkout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingPlanId = null,
    Object? workoutId = null,
    Object? scheduledDate = null,
    Object? weekNumber = freezed,
    Object? dayOfWeek = freezed,
    Object? coachNotes = freezed,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? workoutTitle = freezed,
    Object? workoutDurationMinutes = freezed,
    Object? workoutType = freezed,
    Object? workoutThumbnailUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingPlanId: null == trainingPlanId
          ? _value.trainingPlanId
          : trainingPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      coachNotes: freezed == coachNotes
          ? _value.coachNotes
          : coachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workoutTitle: freezed == workoutTitle
          ? _value.workoutTitle
          : workoutTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      workoutDurationMinutes: freezed == workoutDurationMinutes
          ? _value.workoutDurationMinutes
          : workoutDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      workoutType: freezed == workoutType
          ? _value.workoutType
          : workoutType // ignore: cast_nullable_to_non_nullable
              as String?,
      workoutThumbnailUrl: freezed == workoutThumbnailUrl
          ? _value.workoutThumbnailUrl
          : workoutThumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingPlanWorkoutImplCopyWith<$Res>
    implements $TrainingPlanWorkoutCopyWith<$Res> {
  factory _$$TrainingPlanWorkoutImplCopyWith(_$TrainingPlanWorkoutImpl value,
          $Res Function(_$TrainingPlanWorkoutImpl) then) =
      __$$TrainingPlanWorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trainingPlanId,
      String workoutId,
      DateTime scheduledDate,
      int? weekNumber,
      int? dayOfWeek,
      String? coachNotes,
      bool isCompleted,
      DateTime? completedAt,
      DateTime createdAt,
      String? workoutTitle,
      int? workoutDurationMinutes,
      String? workoutType,
      String? workoutThumbnailUrl});
}

/// @nodoc
class __$$TrainingPlanWorkoutImplCopyWithImpl<$Res>
    extends _$TrainingPlanWorkoutCopyWithImpl<$Res, _$TrainingPlanWorkoutImpl>
    implements _$$TrainingPlanWorkoutImplCopyWith<$Res> {
  __$$TrainingPlanWorkoutImplCopyWithImpl(_$TrainingPlanWorkoutImpl _value,
      $Res Function(_$TrainingPlanWorkoutImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingPlanWorkout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingPlanId = null,
    Object? workoutId = null,
    Object? scheduledDate = null,
    Object? weekNumber = freezed,
    Object? dayOfWeek = freezed,
    Object? coachNotes = freezed,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? workoutTitle = freezed,
    Object? workoutDurationMinutes = freezed,
    Object? workoutType = freezed,
    Object? workoutThumbnailUrl = freezed,
  }) {
    return _then(_$TrainingPlanWorkoutImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingPlanId: null == trainingPlanId
          ? _value.trainingPlanId
          : trainingPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      dayOfWeek: freezed == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      coachNotes: freezed == coachNotes
          ? _value.coachNotes
          : coachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workoutTitle: freezed == workoutTitle
          ? _value.workoutTitle
          : workoutTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      workoutDurationMinutes: freezed == workoutDurationMinutes
          ? _value.workoutDurationMinutes
          : workoutDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      workoutType: freezed == workoutType
          ? _value.workoutType
          : workoutType // ignore: cast_nullable_to_non_nullable
              as String?,
      workoutThumbnailUrl: freezed == workoutThumbnailUrl
          ? _value.workoutThumbnailUrl
          : workoutThumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingPlanWorkoutImpl implements _TrainingPlanWorkout {
  const _$TrainingPlanWorkoutImpl(
      {required this.id,
      required this.trainingPlanId,
      required this.workoutId,
      required this.scheduledDate,
      this.weekNumber,
      this.dayOfWeek,
      this.coachNotes,
      this.isCompleted = false,
      this.completedAt,
      required this.createdAt,
      this.workoutTitle,
      this.workoutDurationMinutes,
      this.workoutType,
      this.workoutThumbnailUrl});

  factory _$TrainingPlanWorkoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingPlanWorkoutImplFromJson(json);

  @override
  final String id;
  @override
  final String trainingPlanId;
  @override
  final String workoutId;
  @override
  final DateTime scheduledDate;
  @override
  final int? weekNumber;
  @override
  final int? dayOfWeek;
  @override
  final String? coachNotes;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
// Populated from join
  @override
  final String? workoutTitle;
  @override
  final int? workoutDurationMinutes;
  @override
  final String? workoutType;
  @override
  final String? workoutThumbnailUrl;

  @override
  String toString() {
    return 'TrainingPlanWorkout(id: $id, trainingPlanId: $trainingPlanId, workoutId: $workoutId, scheduledDate: $scheduledDate, weekNumber: $weekNumber, dayOfWeek: $dayOfWeek, coachNotes: $coachNotes, isCompleted: $isCompleted, completedAt: $completedAt, createdAt: $createdAt, workoutTitle: $workoutTitle, workoutDurationMinutes: $workoutDurationMinutes, workoutType: $workoutType, workoutThumbnailUrl: $workoutThumbnailUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingPlanWorkoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainingPlanId, trainingPlanId) ||
                other.trainingPlanId == trainingPlanId) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.coachNotes, coachNotes) ||
                other.coachNotes == coachNotes) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.workoutTitle, workoutTitle) ||
                other.workoutTitle == workoutTitle) &&
            (identical(other.workoutDurationMinutes, workoutDurationMinutes) ||
                other.workoutDurationMinutes == workoutDurationMinutes) &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            (identical(other.workoutThumbnailUrl, workoutThumbnailUrl) ||
                other.workoutThumbnailUrl == workoutThumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      trainingPlanId,
      workoutId,
      scheduledDate,
      weekNumber,
      dayOfWeek,
      coachNotes,
      isCompleted,
      completedAt,
      createdAt,
      workoutTitle,
      workoutDurationMinutes,
      workoutType,
      workoutThumbnailUrl);

  /// Create a copy of TrainingPlanWorkout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingPlanWorkoutImplCopyWith<_$TrainingPlanWorkoutImpl> get copyWith =>
      __$$TrainingPlanWorkoutImplCopyWithImpl<_$TrainingPlanWorkoutImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingPlanWorkoutImplToJson(
      this,
    );
  }
}

abstract class _TrainingPlanWorkout implements TrainingPlanWorkout {
  const factory _TrainingPlanWorkout(
      {required final String id,
      required final String trainingPlanId,
      required final String workoutId,
      required final DateTime scheduledDate,
      final int? weekNumber,
      final int? dayOfWeek,
      final String? coachNotes,
      final bool isCompleted,
      final DateTime? completedAt,
      required final DateTime createdAt,
      final String? workoutTitle,
      final int? workoutDurationMinutes,
      final String? workoutType,
      final String? workoutThumbnailUrl}) = _$TrainingPlanWorkoutImpl;

  factory _TrainingPlanWorkout.fromJson(Map<String, dynamic> json) =
      _$TrainingPlanWorkoutImpl.fromJson;

  @override
  String get id;
  @override
  String get trainingPlanId;
  @override
  String get workoutId;
  @override
  DateTime get scheduledDate;
  @override
  int? get weekNumber;
  @override
  int? get dayOfWeek;
  @override
  String? get coachNotes;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  DateTime get createdAt; // Populated from join
  @override
  String? get workoutTitle;
  @override
  int? get workoutDurationMinutes;
  @override
  String? get workoutType;
  @override
  String? get workoutThumbnailUrl;

  /// Create a copy of TrainingPlanWorkout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingPlanWorkoutImplCopyWith<_$TrainingPlanWorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
