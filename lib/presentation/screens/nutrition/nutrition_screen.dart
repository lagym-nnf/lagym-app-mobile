import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/constants.dart';
import '../../../domain/entities/recipe.dart';
import '../../../providers/recipes_provider.dart';
import '../../widgets/common/image_card.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});
  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen> {
  int _selectedFilter = 0;

  // Label shown in the chip → recipes.category value (null = no filter)
  static const _filters = <(String, String?)>[
    ('All', null),
    ('Breakfast', 'breakfast'),
    ('Lunch', 'lunch'),
    ('Dinner', 'dinner'),
    ('Snacks', 'snack'),
  ];

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nutrition', style: AppTypography.greetingLarge),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.sm,
                    ),
                    child: Icon(PhosphorIcons.magnifyingGlass(), color: AppColors.gray900, size: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = index == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.gray900 : AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(_filters[index].$1, style: AppTypography.buttonSmall.copyWith(color: selected ? AppColors.white : AppColors.gray600)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Recipes', style: AppTypography.sectionTitle),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(recipesProvider),
                child: recipesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => _EmptyState(
                    icon: PhosphorIcons.wifiSlash(),
                    message: 'Could not load recipes.\nPull down to try again.',
                  ),
                  data: (recipes) {
                    final category = _filters[_selectedFilter].$2;
                    final filtered = category == null
                        ? recipes
                        : recipes.where((r) => r.category == category).toList();

                    if (filtered.isEmpty) {
                      return _EmptyState(
                        icon: PhosphorIcons.cookingPot(),
                        message: 'No recipes here yet.\nCheck back soon!',
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final recipe = filtered[index];
                        return RecipeImageCard(
                          title: recipe.title,
                          calories: recipe.caloriesPerServing != null
                              ? '${recipe.caloriesPerServing} cal'
                              : '',
                          time: '${recipe.totalTimeMinutes} min',
                          imageUrl: recipe.thumbnailUrl ?? '',
                          onTap: () => context.push('/nutrition/${recipe.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    // ListView so RefreshIndicator keeps working on the empty state
    return ListView(
      children: [
        const SizedBox(height: 80),
        Icon(icon, size: 48, color: AppColors.gray300),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
        ),
      ],
    );
  }
}
