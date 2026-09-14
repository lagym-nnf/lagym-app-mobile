import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/constants.dart';
import '../../../domain/entities/recipe.dart';
import '../../../providers/recipes_provider.dart';
import '../profile/subscription_screen.dart' show PaywallGate;

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  int _selectedTab = 0; // 0 = Ingredients, 1 = Instructions

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeProvider(widget.recipeId));

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: recipeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _NotFound(onBack: () => context.pop()),
        data: (recipe) {
          if (recipe == null) return _NotFound(onBack: () => context.pop());
          return _buildContent(context, recipe);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero image
          Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: recipe.thumbnailUrl != null
                    ? CachedNetworkImage(imageUrl: recipe.thumbnailUrl!, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.gray200,
                        child: Icon(PhosphorIcons.cookingPot(), size: 64, color: AppColors.gray400),
                      ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleBtn(icon: PhosphorIcons.arrowLeft(), onTap: () => context.pop()),
                      _CircleBtn(icon: PhosphorIcons.bookmark(), onTap: () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.pinkLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: AppTypography.h2),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (recipe.caloriesPerServing != null) ...[
                      _MetaItem(icon: PhosphorIcons.flame(), label: '${recipe.caloriesPerServing} cal'),
                      const SizedBox(width: 16),
                    ],
                    _MetaItem(icon: PhosphorIcons.clock(), label: '${recipe.totalTimeMinutes} min'),
                    if (recipe.proteinGrams != null) ...[
                      const SizedBox(width: 16),
                      _MetaItem(icon: PhosphorIcons.egg(), label: '${recipe.proteinGrams}g protein'),
                    ],
                  ],
                ),
                if (recipe.description != null && recipe.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    recipe.description!,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
                  ),
                ],
                const SizedBox(height: 24),
                // Premium recipes show the paywall instead of the content
                if (recipe.isPremium)
                  PaywallGate(
                    featureName: 'Premium Recipes',
                    child: _RecipeBody(
                      recipe: recipe,
                      selectedTab: _selectedTab,
                      onTabChanged: (tab) => setState(() => _selectedTab = tab),
                    ),
                  )
                else
                  _RecipeBody(
                    recipe: recipe,
                    selectedTab: _selectedTab,
                    onTabChanged: (tab) => setState(() => _selectedTab = tab),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeBody extends StatelessWidget {
  final Recipe recipe;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _RecipeBody({
    required this.recipe,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs
        Row(
          children: [
            _TabChip(
              label: 'Ingredients',
              selected: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
            const SizedBox(width: 8),
            _TabChip(
              label: 'Instructions',
              selected: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (selectedTab == 0) ...[
          if (recipe.ingredients.isEmpty)
            Text(
              'No ingredients listed.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
            )
          else
            ...recipe.ingredients.map((i) => _IngredientItem(text: i.displayText)),
        ] else ...[
          if (recipe.instructions.isEmpty)
            Text(
              'No instructions listed.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
            )
          else
            ...recipe.instructions.asMap().entries.map(
                  (e) => _InstructionItem(step: e.key + 1, text: e.value),
                ),
        ],
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.gray900 : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTypography.buttonSmall.copyWith(
            color: selected ? AppColors.white : AppColors.gray600,
          ),
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  final VoidCallback onBack;
  const _NotFound({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: _CircleBtn(icon: PhosphorIcons.arrowLeft(), onTap: onBack, dark: true),
          ),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(PhosphorIcons.cookingPot(), size: 48, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'Recipe not found',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;
  const _CircleBtn({required this.icon, required this.onTap, this.dark = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: dark ? AppColors.white : Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          boxShadow: dark ? AppShadows.sm : null,
        ),
        child: Icon(icon, color: dark ? AppColors.gray900 : AppColors.white, size: 20),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.pinkDark, size: 16),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.captionSmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.gray600)),
      ],
    );
  }
}

class _IngredientItem extends StatelessWidget {
  final String text;
  const _IngredientItem({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(PhosphorIcons.circle(), color: AppColors.gray300, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final int step;
  final String text;
  const _InstructionItem({required this.step, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.pinkDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: AppTypography.captionSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }
}
