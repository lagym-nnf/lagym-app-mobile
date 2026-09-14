import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/program.dart';

const _programSelect = '*, coach:coaches(name, avatar_url)';

/// Provider for fetching all programs
final programsProvider = FutureProvider<List<Program>>((ref) async {
  final response = await SupabaseConfig.client
      .from('programs')
      .select(_programSelect)
      .eq('is_active', true)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Program.fromJson(json)).toList();
});

/// Provider for fetching a single program by ID
final programProvider = FutureProvider.family<Program?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('programs')
      .select(_programSelect)
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Program.fromJson(response);
});

/// Provider for fetching featured programs (the programs table has no
/// is_featured column; the newest active programs are shown instead)
final featuredProgramsProvider = FutureProvider<List<Program>>((ref) async {
  final response = await SupabaseConfig.client
      .from('programs')
      .select(_programSelect)
      .eq('is_active', true)
      .order('created_at', ascending: false)
      .limit(5);

  return (response as List).map((json) => Program.fromJson(json)).toList();
});

/// Provider for fetching programs by training category id
final programsByCategoryProvider = FutureProvider.family<List<Program>, String>((ref, categoryId) async {
  final response = await SupabaseConfig.client
      .from('programs')
      .select(_programSelect)
      .eq('is_active', true)
      .eq('category_id', categoryId)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Program.fromJson(json)).toList();
});

const _programWorkoutSelect =
    '*, workout:workouts(*), day_exercises:program_day_exercises(*, exercise:exercises(*))';

/// Provider for fetching program workouts (rest days have no workout,
/// structured gym days carry their exercises in day_exercises)
final programWorkoutsProvider = FutureProvider.family<List<ProgramWorkout>, String>((ref, programId) async {
  final response = await SupabaseConfig.client
      .from('program_workouts')
      .select(_programWorkoutSelect)
      .eq('program_id', programId)
      .order('sequence_number');

  return (response as List).map((json) => ProgramWorkout.fromJson(json)).toList();
});

/// A single program day by program_workouts id (used by the structured
/// gym day screen when opened without a preloaded ProgramWorkout)
final programWorkoutProvider =
    FutureProvider.family<ProgramWorkout?, String>((ref, programWorkoutId) async {
  final response = await SupabaseConfig.client
      .from('program_workouts')
      .select(_programWorkoutSelect)
      .eq('id', programWorkoutId)
      .maybeSingle();

  if (response == null) return null;
  return ProgramWorkout.fromJson(response);
});

/// The current user's enrollment in a program (null when not enrolled)
final programEnrollmentProvider =
    FutureProvider.family<ProgramEnrollment?, String>((ref, programId) async {
  final user = SupabaseConfig.currentUser;
  if (user == null) return null;

  final response = await SupabaseConfig.client
      .from('user_program_enrollments')
      .select()
      .eq('user_id', user.id)
      .eq('program_id', programId)
      .eq('is_active', true)
      .maybeSingle();

  if (response == null) return null;
  return ProgramEnrollment.fromJson(response);
});

/// Enrollment actions. Call `ref.invalidate(programEnrollmentProvider(id))`
/// after mutations to refresh the UI.
class EnrollmentService {
  static Future<void> enroll(String programId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) throw Exception('Not logged in');

    await SupabaseConfig.client.from('user_program_enrollments').upsert({
      'user_id': user.id,
      'program_id': programId,
      'current_sequence': 1,
      'completed_workouts': 0,
      'is_active': true,
    }, onConflict: 'user_id,program_id');
  }

  /// Marks the current day complete and unlocks the next one.
  static Future<void> advance(ProgramEnrollment enrollment) async {
    await SupabaseConfig.client
        .from('user_program_enrollments')
        .update({
          'current_sequence': enrollment.currentSequence + 1,
          'completed_workouts': enrollment.completedWorkouts + 1,
          'last_workout_at': DateTime.now().toIso8601String(),
        })
        .eq('id', enrollment.id);
  }
}
