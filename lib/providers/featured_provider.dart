import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/featured_content.dart';

/// Provider for fetching today's featured content
final todaysFeaturedProvider = FutureProvider<List<FeaturedContent>>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('featured_content')
      .select()
      .eq('scheduled_date', today)
      .eq('is_active', true)
      .order('position');

  return (response as List).map((json) => FeaturedContent.fromJson(json)).toList();
});

/// Provider for fetching featured content for a specific position
final featuredByPositionProvider = FutureProvider.family<List<FeaturedContent>, String>((ref, position) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('featured_content')
      .select()
      .eq('scheduled_date', today)
      .eq('position', position)
      .eq('is_active', true);

  return (response as List).map((json) => FeaturedContent.fromJson(json)).toList();
});

/// Provider for fetching upcoming featured content
final upcomingFeaturedProvider = FutureProvider<List<FeaturedContent>>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await SupabaseConfig.client
      .from('featured_content')
      .select()
      .gte('scheduled_date', today)
      .eq('is_active', true)
      .order('scheduled_date')
      .limit(14);

  return (response as List).map((json) => FeaturedContent.fromJson(json)).toList();
});
