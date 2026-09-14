import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/daily_challenge.dart';

/// Provider for fetching all challenges
final challengesProvider = FutureProvider<List<DailyChallenge>>((ref) async {
  final response = await SupabaseConfig.client
      .from('daily_challenges')
      .select()
      .eq('is_active', true)
      .order('scheduled_date', ascending: false);

  return (response as List).map((json) => DailyChallenge.fromJson(json)).toList();
});

/// Provider for fetching a single challenge by ID
final challengeProvider = FutureProvider.family<DailyChallenge?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('daily_challenges')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return DailyChallenge.fromJson(response);
});

/// Provider for fetching today's challenge
final todaysChallengeProvider = FutureProvider<DailyChallenge?>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('daily_challenges')
      .select()
      .eq('scheduled_date', today)
      .eq('is_active', true)
      .maybeSingle();

  if (response == null) return null;
  return DailyChallenge.fromJson(response);
});

/// Provider for fetching upcoming challenges
final upcomingChallengesProvider = FutureProvider<List<DailyChallenge>>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('daily_challenges')
      .select()
      .eq('is_active', true)
      .gte('scheduled_date', today)
      .order('scheduled_date')
      .limit(7);

  return (response as List).map((json) => DailyChallenge.fromJson(json)).toList();
});

/// Provider for fetching past challenges
final pastChallengesProvider = FutureProvider<List<DailyChallenge>>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('daily_challenges')
      .select()
      .eq('is_active', true)
      .lt('scheduled_date', today)
      .order('scheduled_date', ascending: false)
      .limit(30);

  return (response as List).map((json) => DailyChallenge.fromJson(json)).toList();
});
