import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/workout.dart';

/// Provider for fetching all workouts
final workoutsProvider = FutureProvider<List<Workout>>((ref) async {
  final response = await SupabaseConfig.client
      .from('workouts')
      .select()
      .eq('is_active', true)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Workout.fromJson(json)).toList();
});

/// Provider for fetching a single workout by ID
final workoutProvider = FutureProvider.family<Workout?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('workouts')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Workout.fromJson(response);
});

/// Provider for fetching workouts by category
final workoutsByCategoryProvider = FutureProvider.family<List<Workout>, String>((ref, category) async {
  final response = await SupabaseConfig.client
      .from('workouts')
      .select()
      .eq('is_active', true)
      .eq('category', category)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Workout.fromJson(json)).toList();
});

/// Provider for fetching featured workouts
final featuredWorkoutsProvider = FutureProvider<List<Workout>>((ref) async {
  final response = await SupabaseConfig.client
      .from('workouts')
      .select()
      .eq('is_active', true)
      .eq('is_featured', true)
      .order('created_at', ascending: false)
      .limit(5);

  return (response as List).map((json) => Workout.fromJson(json)).toList();
});

/// Provider for fetching today's workout (from daily_workouts or featured)
final todaysWorkoutProvider = FutureProvider<Workout?>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  // First try to get from daily_workouts schedule
  final dailyResponse = await SupabaseConfig.client
      .from('daily_workouts')
      .select('workout_id, workouts(*)')
      .eq('date', today)
      .maybeSingle();

  if (dailyResponse != null && dailyResponse['workouts'] != null) {
    return Workout.fromJson(dailyResponse['workouts'] as Map<String, dynamic>);
  }

  // Fallback to most recent featured workout
  final featuredResponse = await SupabaseConfig.client
      .from('workouts')
      .select()
      .eq('is_active', true)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (featuredResponse != null) {
    return Workout.fromJson(featuredResponse);
  }

  return null;
});
