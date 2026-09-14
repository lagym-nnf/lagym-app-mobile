import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/habit_config.dart';

/// Provider for fetching all habit configs
final habitConfigsProvider = FutureProvider<List<HabitConfig>>((ref) async {
  final response = await SupabaseConfig.client
      .from('habit_configs')
      .select()
      .eq('is_active', true)
      .order('sort_order');

  return (response as List).map((json) => HabitConfig.fromJson(json)).toList();
});

/// Provider for fetching a single habit config by ID
final habitConfigProvider = FutureProvider.family<HabitConfig?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('habit_configs')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return HabitConfig.fromJson(response);
});

/// Provider for fetching user's habit tracking for today
final todaysHabitTrackingProvider = FutureProvider<List<HabitTracking>>((ref) async {
  final userId = SupabaseConfig.currentUser?.id;
  if (userId == null) return [];

  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('habit_tracking')
      .select()
      .eq('user_id', userId)
      .eq('date', today);

  return (response as List).map((json) => HabitTracking.fromJson(json)).toList();
});

/// State notifier for managing habit tracking
class HabitTrackingNotifier extends StateNotifier<Map<String, HabitTracking>> {
  HabitTrackingNotifier() : super({});

  Future<void> loadTodaysTracking() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return;

    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await SupabaseConfig.client
        .from('habit_tracking')
        .select()
        .eq('user_id', userId)
        .eq('date', today);

    final tracking = (response as List)
        .map((json) => HabitTracking.fromJson(json))
        .toList();

    state = {
      for (final t in tracking) t.habitConfigId: t,
    };
  }

  Future<void> updateHabitProgress(String habitConfigId, int value) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return;

    final today = DateTime.now().toIso8601String().split('T')[0];

    await SupabaseConfig.client.from('habit_tracking').upsert({
      'user_id': userId,
      'habit_config_id': habitConfigId,
      'date': today,
      'current_value': value,
    }, onConflict: 'user_id, habit_config_id, date');

    await loadTodaysTracking();
  }

  Future<void> completeHabit(String habitConfigId) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return;

    final today = DateTime.now().toIso8601String().split('T')[0];

    await SupabaseConfig.client.from('habit_tracking').upsert({
      'user_id': userId,
      'habit_config_id': habitConfigId,
      'date': today,
      'is_completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id, habit_config_id, date');

    await loadTodaysTracking();
  }
}

final habitTrackingProvider =
    StateNotifierProvider<HabitTrackingNotifier, Map<String, HabitTracking>>((ref) {
  return HabitTrackingNotifier();
});
