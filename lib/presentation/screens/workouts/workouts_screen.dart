import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/workout.dart';
import '../../../providers/programs_provider.dart';
import '../../../providers/workouts_provider.dart';
import '../../widgets/common/workout_card.dart';

/// Curated card imagery per training category (design assets, not data).
class _CategoryStyle {
  final String title;
  final String imageUrl;
  const _CategoryStyle(this.title, this.imageUrl);
}

const _categoryStyles = <TrainingCategory, _CategoryStyle>{
  TrainingCategory.strength: _CategoryStyle('Strength',
      'https://images.unsplash.com/photo-1550345332-09e3ac987658?w=300&h=220&fit=crop',),
  TrainingCategory.pilates: _CategoryStyle('Pilates',
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=300&h=220&fit=crop',),
  TrainingCategory.cardio: _CategoryStyle('Cardio',
      'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=300&h=220&fit=crop',),
  TrainingCategory.yoga: _CategoryStyle('Yoga',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=220&fit=crop',),
  TrainingCategory.hiit: _CategoryStyle('HIIT',
      'https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=300&h=220&fit=crop',),
  TrainingCategory.recovery: _CategoryStyle('Recovery',
      'https://images.unsplash.com/photo-1552196563-55cd4e45efb3?w=300&h=220&fit=crop',),
  TrainingCategory.barre: _CategoryStyle('Barre',
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=300&h=220&fit=crop',),
  TrainingCategory.prePostNatal: _CategoryStyle('Pre/Post Natal',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=220&fit=crop',),
  TrainingCategory.quickWorkouts: _CategoryStyle('Quick Workouts',
      'https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=300&h=220&fit=crop',),
};

class WorkoutsScreen extends ConsumerStatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  ConsumerState<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends ConsumerState<WorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.md,
                  AppSpacing.screenPadding,
                  20,
                ),
                child: const Text(
                  'Workouts',
                  style: AppTypography.greetingLarge,
                ),
              ),
              // Programs section
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Programs',
                      style: AppTypography.sectionTitle,
                    ),
                    GestureDetector(
                      onTap: () => context.push('/programs'),
                      child: Text(
                        'See All',
                        style: AppTypography.buttonSmall.copyWith(
                          color: AppColors.pinkDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Programs horizontal list
              SizedBox(
                height: 140,
                child: ref.watch(featuredProgramsProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(
                    child: Text(
                      'Could not load programs.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                    ),
                  ),
                  data: (programs) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    itemCount: programs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final program = programs[index];
                      return _ProgramMiniCard(
                        title: program.title,
                        type: program.isInfinity
                            ? 'INFINITY'
                            : '${program.durationWeeks ?? '-'} WEEKS',
                        imageUrl: program.thumbnailUrl ?? '',
                        isInfinity: program.isInfinity,
                        onTap: () => context.push('/programs/${program.id}'),
                      );
                    },
                  ),
                ),
              ),
              // Training Styles — categories with real workout counts; the
              // whole section (title included) hides when no category has
              // any workouts.
              ref.watch(workoutsProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (workouts) {
                  final counts = <TrainingCategory, int>{};
                  for (final w in workouts) {
                    counts[w.category] = (counts[w.category] ?? 0) + 1;
                  }
                  final cards = _categoryStyles.entries
                      .where((e) => (counts[e.key] ?? 0) > 0)
                      .map((e) {
                    final count = counts[e.key]!;
                    return WorkoutCardGrid(
                      title: e.value.title,
                      subtitle:
                          count == 1 ? '1 workout' : '$count workouts',
                      imageUrl: e.value.imageUrl,
                      onTap: () => context
                          .push('/workouts/category/${e.key.name}'),
                    );
                  }).toList();
                  if (cards.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Text(
                          'Training Styles',
                          style: AppTypography.sectionTitle,
                        ),
                      ),
                      const SizedBox(height: 14),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.0,
                        children: cards,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramMiniCard extends StatelessWidget {
  final String title;
  final String type;
  final String imageUrl;
  final bool isInfinity;
  final VoidCallback onTap;

  const _ProgramMiniCard({
    required this.title,
    required this.type,
    required this.imageUrl,
    this.isInfinity = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.gray200),
              )
            else
              Container(color: AppColors.gray200),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isInfinity ? AppColors.coral : AppColors.pinkDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      type,
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
