import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/recipe.dart';

/// Provider for fetching all recipes
final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final response = await SupabaseConfig.client
      .from('recipes')
      .select()
      .eq('is_active', true)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Recipe.fromJson(json)).toList();
});

/// Provider for fetching a single recipe by ID
final recipeProvider = FutureProvider.family<Recipe?, String>((ref, id) async {
  final response = await SupabaseConfig.client
      .from('recipes')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) return null;
  return Recipe.fromJson(response);
});

/// Provider for fetching the latest recipes (the recipes table has no
/// is_featured column; featuring is done via the featured_content table)
final featuredRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final response = await SupabaseConfig.client
      .from('recipes')
      .select()
      .eq('is_active', true)
      .order('created_at', ascending: false)
      .limit(5);

  return (response as List).map((json) => Recipe.fromJson(json)).toList();
});

/// Provider for fetching recipes by category
/// ('breakfast', 'lunch', 'dinner', 'snack', 'smoothie', 'dessert')
final recipesByCategoryProvider = FutureProvider.family<List<Recipe>, String>((ref, category) async {
  final response = await SupabaseConfig.client
      .from('recipes')
      .select()
      .eq('is_active', true)
      .eq('category', category)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Recipe.fromJson(json)).toList();
});

/// Provider for fetching recipes by dietary tag
final recipesByDietaryTagProvider = FutureProvider.family<List<Recipe>, String>((ref, tag) async {
  final response = await SupabaseConfig.client
      .from('recipes')
      .select()
      .eq('is_active', true)
      .contains('dietary_tags', [tag])
      .order('created_at', ascending: false);

  return (response as List).map((json) => Recipe.fromJson(json)).toList();
});

/// Provider for recipe of the day
final recipeOfTheDayProvider = FutureProvider<Recipe?>((ref) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  // Check featured_content for today's recipe
  final featuredResponse = await SupabaseConfig.client
      .from('featured_content')
      .select('content_id')
      .eq('content_type', 'recipe')
      .eq('scheduled_date', today)
      .eq('is_active', true)
      .maybeSingle();

  if (featuredResponse != null) {
    final recipeResponse = await SupabaseConfig.client
        .from('recipes')
        .select()
        .eq('id', featuredResponse['content_id'])
        .maybeSingle();

    if (recipeResponse != null) {
      return Recipe.fromJson(recipeResponse);
    }
  }

  // Fallback to the most recent active recipe
  final fallbackResponse = await SupabaseConfig.client
      .from('recipes')
      .select()
      .eq('is_active', true)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (fallbackResponse != null) {
    return Recipe.fromJson(fallbackResponse);
  }

  return null;
});
