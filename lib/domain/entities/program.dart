import 'user_profile.dart';
import 'workout.dart';

/// Program type
enum ProgramType {
  fixed,    // 12-week programs with set duration
  infinity, // Ongoing daily workouts, unlock day by day
}

/// Program entity
class Program {
  final String id;
  final String title;
  final String description;
  final ProgramType type;
  final int? durationWeeks; // For fixed programs
  final String? coachId;
  final String? coachName;
  final String? coachImageUrl;
  final String? thumbnailUrl;
  final String? coverImageUrl;
  final TrainingCategory category;
  final FitnessLevel difficulty;
  final WorkoutLocation location;
  final int totalWorkouts;
  final int estimatedCaloriesPerWorkout;
  final List<String> equipment;
  final List<String> tags;
  final bool isPremium;
  final DateTime? createdAt;

  const Program({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.durationWeeks,
    this.coachId,
    this.coachName,
    this.coachImageUrl,
    this.thumbnailUrl,
    this.coverImageUrl,
    required this.category,
    required this.difficulty,
    required this.location,
    required this.totalWorkouts,
    this.estimatedCaloriesPerWorkout = 300,
    this.equipment = const [],
    this.tags = const [],
    this.isPremium = false,
    this.createdAt,
  });

  bool get isFixed => type == ProgramType.fixed;
  bool get isInfinity => type == ProgramType.infinity;

  factory Program.fromJson(Map<String, dynamic> json) {
    // Joined coach row when selected as `coach:coaches(name, avatar_url)`
    final coach = json['coach'] as Map<String, dynamic>?;
    final durationWeeks = json['duration_weeks'] as int?;
    final workoutsPerWeek = json['workouts_per_week'] as int?;

    return Program(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      type: ProgramType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => ProgramType.fixed,
      ),
      durationWeeks: durationWeeks,
      coachId: json['coach_id'] as String?,
      coachName: coach?['name'] as String? ?? json['coach_name'] as String?,
      coachImageUrl:
          coach?['avatar_url'] as String? ?? json['coach_image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String? ??
          json['thumbnail_url'] as String?,
      category: TrainingCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TrainingCategory.strength,
      ),
      difficulty: FitnessLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => FitnessLevel.intermediate,
      ),
      location: WorkoutLocation.values.firstWhere(
        (l) => l.name == json['location'],
        orElse: () => WorkoutLocation.home,
      ),
      totalWorkouts: json['total_workouts'] as int? ??
          ((durationWeeks != null && workoutsPerWeek != null)
              ? durationWeeks * workoutsPerWeek
              : 0),
      estimatedCaloriesPerWorkout: json['estimated_calories'] as int? ?? 300,
      equipment: (json['equipment'] as List<dynamic>?)?.cast<String>() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }
}

/// User's enrollment in a program
class ProgramEnrollment {
  final String id;
  final String oderId;
  final String programId;
  final int currentSequence; // For infinity: current day unlocked
  final int currentWeek;     // For fixed: current week
  final int completedWorkouts;
  final DateTime enrolledAt;
  final DateTime? lastWorkoutAt;
  final bool isActive;

  const ProgramEnrollment({
    required this.id,
    required this.oderId,
    required this.programId,
    this.currentSequence = 1,
    this.currentWeek = 1,
    this.completedWorkouts = 0,
    required this.enrolledAt,
    this.lastWorkoutAt,
    this.isActive = true,
  });

  factory ProgramEnrollment.fromJson(Map<String, dynamic> json) {
    return ProgramEnrollment(
      id: json['id'] as String,
      oderId: json['user_id'] as String,
      programId: json['program_id'] as String,
      currentSequence: json['current_sequence'] as int? ?? 1,
      currentWeek: json['current_week'] as int? ?? 1,
      completedWorkouts: json['completed_workouts'] as int? ?? 0,
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
      lastWorkoutAt: json['last_workout_at'] != null
          ? DateTime.parse(json['last_workout_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// An exercise entry in a structured program day (program_day_exercises row)
class ProgramDayExercise {
  final String id;
  final String exerciseId;
  final int sequenceOrder;
  final int sets;
  final int reps;
  final int? repsMax;
  final String repUnit;
  final int? durationSeconds;
  final int restSeconds;
  final String? notes;
  final int? supersetGroup;
  final SetType setType;
  final int? dropsetCount;
  final String? repScheme;
  final Exercise? exercise;

  const ProgramDayExercise({
    required this.id,
    required this.exerciseId,
    required this.sequenceOrder,
    required this.sets,
    required this.reps,
    this.repsMax,
    this.repUnit = 'reps',
    this.durationSeconds,
    required this.restSeconds,
    this.notes,
    this.supersetGroup,
    this.setType = SetType.normal,
    this.dropsetCount,
    this.repScheme,
    this.exercise,
  });

  bool get isDropset => setType == SetType.dropset;

  /// The joined exercise with this entry's sets/reps context merged in,
  /// ready for display in exercise lists and the detail sheet.
  Exercise? get exerciseWithContext {
    final ex = exercise;
    if (ex == null) return null;
    return Exercise(
      id: ex.id,
      name: ex.name,
      description: ex.description,
      thumbnailUrl: ex.thumbnailUrl,
      videoUrl: ex.videoUrl,
      sets: sets,
      reps: reps,
      repsMax: repsMax,
      repUnit: repUnit,
      durationSeconds: durationSeconds,
      restSeconds: restSeconds,
      targetMuscles: ex.targetMuscles,
      equipment: ex.equipment,
      instructions: ex.instructions,
      tips: ex.tips,
      supersetGroup: supersetGroup,
      setType: setType,
      dropsetCount: dropsetCount,
      repScheme: repScheme,
      notes: notes,
    );
  }

  factory ProgramDayExercise.fromJson(Map<String, dynamic> json) {
    return ProgramDayExercise(
      id: json['id'] as String,
      exerciseId: json['exercise_id'] as String,
      sequenceOrder: json['sequence_order'] as int? ?? 0,
      sets: json['sets'] as int? ?? 3,
      reps: json['reps'] as int? ?? 12,
      repsMax: json['reps_max'] as int?,
      repUnit: json['rep_unit'] as String? ?? 'reps',
      durationSeconds: json['duration_seconds'] as int?,
      restSeconds: json['rest_seconds'] as int? ?? 60,
      notes: json['notes'] as String?,
      supersetGroup: json['superset_group'] as int?,
      setType: SetType.fromDb(json['set_type'] as String?),
      dropsetCount: json['dropset_count'] as int?,
      repScheme: json['rep_scheme'] as String?,
      exercise: json['exercise'] != null
          ? Exercise.fromJson(json['exercise'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Program workout (links program to workout with sequence)
class ProgramWorkout {
  final String id;
  final String programId;
  final String? workoutId; // null for rest days / structured gym days
  final int sequenceNumber; // Day number for infinity, or workout order for fixed
  final int? weekNumber;    // For fixed programs
  final bool isRestDay;
  final String? customTitle;
  final String? notes;
  final Workout? workout;
  final List<ProgramDayExercise> dayExercises;

  const ProgramWorkout({
    required this.id,
    required this.programId,
    this.workoutId,
    required this.sequenceNumber,
    this.weekNumber,
    this.isRestDay = false,
    this.customTitle,
    this.notes,
    this.workout,
    this.dayExercises = const [],
  });

  /// A gym day built from exercises in the admin (no video workout attached)
  bool get isStructuredDay =>
      !isRestDay && workout == null && dayExercises.isNotEmpty;

  /// Renders as a rest day: explicitly marked, or an empty legacy entry
  bool get isRestLike =>
      isRestDay || (workout == null && dayExercises.isEmpty);

  factory ProgramWorkout.fromJson(Map<String, dynamic> json) {
    final dayExercises = (json['day_exercises'] as List<dynamic>?)
            ?.map((e) => ProgramDayExercise.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    dayExercises.sort((a, b) => a.sequenceOrder.compareTo(b.sequenceOrder));

    return ProgramWorkout(
      id: json['id'] as String,
      programId: json['program_id'] as String,
      workoutId: json['workout_id'] as String?,
      sequenceNumber: json['sequence_number'] as int,
      weekNumber: json['week_number'] as int?,
      isRestDay: json['is_rest_day'] as bool? ?? false,
      customTitle: json['custom_title'] as String?,
      notes: json['notes'] as String?,
      workout: json['workout'] != null
          ? Workout.fromJson(json['workout'] as Map<String, dynamic>)
          : null,
      dayExercises: dayExercises,
    );
  }
}
