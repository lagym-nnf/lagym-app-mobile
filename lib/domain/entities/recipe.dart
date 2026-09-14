/// Recipe entity
class Recipe {
  final String id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final int? caloriesPerServing;
  final int? proteinGrams;
  final int? carbsGrams;
  final int? fatGrams;
  final int? fiberGrams;
  final List<RecipeIngredient> ingredients;
  final List<String> instructions;
  final List<String> dietaryTags;

  /// Meal category: 'breakfast', 'lunch', 'dinner', 'snack', 'smoothie',
  /// 'dessert', 'main' (column `category` in the recipes table).
  final String? category;
  final String? cuisineType;
  final String difficulty;
  final bool isPremium;
  final bool isActive;
  final bool isFeatured;
  final DateTime? createdAt;

  const Recipe({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.prepTimeMinutes = 0,
    this.cookTimeMinutes = 0,
    this.servings = 1,
    this.caloriesPerServing,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.fiberGrams,
    this.ingredients = const [],
    this.instructions = const [],
    this.dietaryTags = const [],
    this.category,
    this.cuisineType,
    this.difficulty = 'easy',
    this.isPremium = false,
    this.isActive = true,
    this.isFeatured = false,
    this.createdAt,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      prepTimeMinutes: json['prep_time_minutes'] as int? ?? 0,
      cookTimeMinutes: json['cook_time_minutes'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      caloriesPerServing: json['calories_per_serving'] as int?,
      proteinGrams: json['protein_grams'] as int?,
      carbsGrams: json['carbs_grams'] as int?,
      fatGrams: json['fat_grams'] as int?,
      fiberGrams: json['fiber_grams'] as int?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
      dietaryTags: (json['dietary_tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: (json['category'] ?? json['meal_type']) as String?,
      cuisineType: json['cuisine_type'] as String?,
      difficulty: json['difficulty'] as String? ?? 'easy',
      isPremium: json['is_premium'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}

/// Recipe ingredient
class RecipeIngredient {
  final String name;
  final String amount;
  final String? unit;
  final String? notes;

  const RecipeIngredient({
    required this.name,
    required this.amount,
    this.unit,
    this.notes,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      unit: json['unit'] as String?,
      notes: json['notes'] as String?,
    );
  }

  String get displayText {
    final parts = <String>[amount];
    if (unit != null && unit!.isNotEmpty) parts.add(unit!);
    parts.add(name);
    if (notes != null && notes!.isNotEmpty) parts.add('($notes)');
    return parts.join(' ');
  }
}
