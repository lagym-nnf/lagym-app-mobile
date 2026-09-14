import 'user_profile.dart';

/// Workout type
enum WorkoutType {
  setsReps,
  followAlong,
}

/// How an exercise's sets are performed
enum SetType {
  normal,
  dropset,    // drop the weight; dropsetCount = number of drops
  amrap,      // as many reps as possible within durationSeconds
  emom,       // every minute on the minute: sets = minutes, reps = reps/minute
  onTime,     // sets x reps done as fast as possible
  repDropset; // descending reps per set, repScheme like '21-15-9'

  /// Parses db values ('on_time', 'rep_dropset', ...), defaulting to normal.
  static SetType fromDb(String? value) {
    switch (value) {
      case 'dropset':
        return SetType.dropset;
      case 'amrap':
        return SetType.amrap;
      case 'emom':
        return SetType.emom;
      case 'on_time':
        return SetType.onTime;
      case 'rep_dropset':
        return SetType.repDropset;
      default:
        return SetType.normal;
    }
  }
}

/// Training category
enum TrainingCategory {
  strength,
  pilates,
  cardio,
  yoga,
  hiit,
  recovery,
  barre,
  prePostNatal,
  quickWorkouts,
}

class Workout {
  final String id;
  final String title;
  final String description;
  final TrainingCategory category;
  final WorkoutType type;
  final int durationMinutes;
  final int caloriesBurned;
  final FitnessLevel difficulty;
  final WorkoutLocation location;
  final String? thumbnailUrl;
  final String? videoUrl;
  final String? coachId;
  final String? coachName;
  final List<Exercise> exercises;
  final bool isPremium;
  final DateTime? createdAt;

  const Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.difficulty,
    required this.location,
    this.thumbnailUrl,
    this.videoUrl,
    this.coachId,
    this.coachName,
    this.exercises = const [],
    this.isPremium = false,
    this.createdAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: TrainingCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TrainingCategory.strength,
      ),
      type: WorkoutType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => WorkoutType.setsReps,
      ),
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      difficulty: FitnessLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => FitnessLevel.intermediate,
      ),
      location: WorkoutLocation.values.firstWhere(
        (l) => l.name == json['location'],
        orElse: () => WorkoutLocation.home,
      ),
      thumbnailUrl: json['thumbnail_url'] as String?,
      videoUrl: json['video_url'] as String?,
      coachId: json['coach_id'] as String?,
      coachName: json['coach_name'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final String? videoUrl;
  final int? sets;
  final int? reps;
  final int? repsMax;
  final String repUnit; // 'reps', 'seconds' (timed holds), 'meters' (distance), 'calories', or 'minutes'
  final int? durationSeconds;
  final int? restSeconds;
  final List<String> targetMuscles;
  final List<String> equipment;
  final List<String> instructions;
  final List<String> tips;

  // Context fields when the exercise is part of a workout/program day
  final int? supersetGroup;
  final SetType setType;
  final int? dropsetCount;
  final String? repScheme; // '21-15-9' style, when setType is repDropset
  final String? notes;

  const Exercise({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    this.videoUrl,
    this.sets,
    this.reps,
    this.repsMax,
    this.repUnit = 'reps',
    this.durationSeconds,
    this.restSeconds,
    this.targetMuscles = const [],
    this.equipment = const [],
    this.instructions = const [],
    this.tips = const [],
    this.supersetGroup,
    this.setType = SetType.normal,
    this.dropsetCount,
    this.repScheme,
    this.notes,
  });

  bool get isDropset => setType == SetType.dropset;

  /// Badge text for special set types ('DROPSET ×3', 'AMRAP 10 MIN', ...),
  /// null for normal sets.
  String? get setTypeLabel {
    switch (setType) {
      case SetType.normal:
        return null;
      case SetType.dropset:
        return dropsetCount != null ? 'DROPSET ×$dropsetCount' : 'DROPSET';
      case SetType.repDropset:
        return repScheme != null ? 'DROPSET $repScheme' : 'DROPSET';
      case SetType.amrap:
        return durationSeconds != null
            ? 'AMRAP ${(durationSeconds! / 60).round()} MIN'
            : 'AMRAP';
      case SetType.emom:
        return 'EMOM';
      case SetType.onTime:
        return 'ON TIME';
    }
  }

  /// How to perform a special set type, for the exercise detail sheet.
  String? get setTypeDescription {
    switch (setType) {
      case SetType.normal:
        return null;
      case SetType.dropset:
        return 'Dropset: drop the weight ${dropsetCount ?? 2}× within each set, no rest between drops.';
      case SetType.repDropset:
        return 'Work down the reps${repScheme != null ? ' ($repScheme)' : ''}: one set per number, dropping the reps each set.';
      case SetType.amrap:
        return 'AMRAP: as many reps as possible${durationSeconds != null ? ' in ${(durationSeconds! / 60).round()} minutes' : ''}.';
      case SetType.emom:
        return 'EMOM: at the top of every minute do ${repsDisplay ?? 'the reps'}, rest for whatever is left of the minute. ${sets ?? '?'} minutes total.';
      case SetType.onTime:
        return 'On time: complete all sets and reps as fast as possible.';
    }
  }

  /// "12" or "10-15" when a range is set
  String? get repsLabel {
    if (reps == null) return null;
    return repsMax != null ? '$reps-$repsMax' : '$reps';
  }

  /// Value with its unit, e.g. "10-15 reps", "30-60 sec" or "20 m"
  String? get repsDisplay {
    final label = repsLabel;
    if (label == null) return null;
    if (repUnit == 'seconds') return '$label sec';
    if (repUnit == 'meters') return '$label m';
    if (repUnit == 'calories') return '$label cal';
    if (repUnit == 'minutes') return '$label min';
    return '$label reps';
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      videoUrl: json['video_url'] as String?,
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      repsMax: json['reps_max'] as int?,
      repUnit: json['rep_unit'] as String? ?? 'reps',
      durationSeconds: json['duration_seconds'] as int?,
      restSeconds: json['rest_seconds'] as int?,
      targetMuscles: (json['target_muscles'] as List<dynamic>?)?.cast<String>() ?? [],
      equipment: (json['equipment'] as List<dynamic>?)?.cast<String>() ?? [],
      instructions: (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
      tips: (json['tips'] as List<dynamic>?)?.cast<String>() ?? [],
      supersetGroup: json['superset_group'] as int?,
      setType: SetType.fromDb(json['set_type'] as String?),
      dropsetCount: json['dropset_count'] as int?,
      repScheme: json['rep_scheme'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
