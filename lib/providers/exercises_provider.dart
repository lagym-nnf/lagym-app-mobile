import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/workout.dart';

/// Provider for fetching all exercises
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final response = await SupabaseConfig.client
      .from('exercises')
      .select()
      .order('name');

  return (response as List).map((json) => Exercise.fromJson(json)).toList();
});

/// Provider for fetching a single exercise by ID
final exerciseProvider = FutureProvider.family<Exercise?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('exercises')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Exercise.fromJson(response);
});

/// Provider for fetching exercises by muscle group
final exercisesByMuscleProvider = FutureProvider.family<List<Exercise>, String>((ref, muscle) async {
  final response = await SupabaseConfig.client
      .from('exercises')
      .select()
      .contains('target_muscles', [muscle])
      .order('name');

  return (response as List).map((json) => Exercise.fromJson(json)).toList();
});

/// Provider for fetching exercises for a specific workout, with the
/// per-workout sets/reps/superset/dropset context merged into each Exercise
final workoutExercisesProvider = FutureProvider.family<List<Exercise>, String>((ref, workoutId) async {
  final response = await SupabaseConfig.client
      .from('workout_exercises')
      .select('*, exercises(*)')
      .eq('workout_id', workoutId)
      .order('sequence_order');

  return (response as List)
      .where((json) => json['exercises'] != null)
      .map((json) => Exercise.fromJson({
            ...(json['exercises'] as Map<String, dynamic>),
            'sets': json['sets'],
            'reps': json['reps'],
            'reps_max': json['reps_max'],
            'rep_unit': json['rep_unit'],
            'duration_seconds': json['duration_seconds'],
            'rest_seconds': json['rest_seconds'],
            'notes': json['notes'],
            'superset_group': json['superset_group'],
            'set_type': json['set_type'],
            'dropset_count': json['dropset_count'],
            'rep_scheme': json['rep_scheme'],
          }))
      .toList();
});
