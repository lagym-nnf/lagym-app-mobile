import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/constants.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../providers/team_members_provider.dart';
import '../../../providers/workouts_provider.dart';
import '../../../providers/programs_provider.dart';
import '../../../providers/habits_provider.dart';
import '../../../providers/challenges_provider.dart';
import '../../../providers/recipes_provider.dart';
import '../../../providers/quotes_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/workout_card.dart';
import '../../widgets/common/image_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Map<String, bool> _completedHabits = {};

  String _getRoleLabel(String? role) {
    switch (role) {
      case 'coach':
        return 'Coach';
      case 'nutritionist':
        return 'Nutritionist';
      case 'physiotherapist':
        return 'Physiotherapist';
      default:
        return 'Team Member';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentProfileProvider);
            ref.invalidate(teamMembersProvider);
            ref.invalidate(todaysWorkoutProvider);
            ref.invalidate(featuredProgramsProvider);
            ref.invalidate(habitConfigsProvider);
            ref.invalidate(todaysChallengeProvider);
            ref.invalidate(recipeOfTheDayProvider);
            ref.invalidate(todaysQuoteProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(now.greeting, style: AppTypography.greetingSmall),
                            const SizedBox(height: 2),
                            Text(
                              ref.watch(userFirstNameProvider).valueOrNull ?? 'there',
                              style: AppTypography.greetingLarge,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.profile),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.sm,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Builder(builder: (context) {
                            final avatarUrl =
                                ref.watch(currentProfileProvider).valueOrNull?['avatar_url'] as String?;
                            if (avatarUrl == null) {
                              return Container(
                                color: AppColors.gray100,
                                child: const Icon(Icons.person),
                              );
                            }
                            return CachedNetworkImage(
                              imageUrl: avatarUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: AppColors.gray100),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.gray100,
                                child: const Icon(Icons.person),
                              ),
                            );
                          },),
                        ),
                      ),
                    ],
                  ),
                ),

                // Meet Our Team Section
                _buildTeamSection(context),

                // Daily Habits section
                _buildHabitsSection(context),

                // Today's Workout section
                _buildTodaysWorkoutSection(context),

                // Featured Programs Section
                _buildFeaturedProgramsSection(context),

                // Daily Challenge section
                _buildDailyChallengeSection(context),

                // Recipe of the Day section
                _buildRecipeSection(context),

                // Motivational Quote
                _buildQuoteSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Meet Our Team', style: AppTypography.sectionTitle),
              TextButton(
                onPressed: () => context.push('/coaches'),
                child: Text('See All', style: AppTypography.buttonSmall.copyWith(color: AppColors.pinkDark)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ref.watch(teamMembersProvider).when(
            data: (teamMembers) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return TeamMemberCard(
                  name: member.name,
                  role: member.title ?? _getRoleLabel(member.role),
                  specialty: member.specialties.isNotEmpty ? member.specialties.first : null,
                  imageUrl: member.avatarUrl ?? '',
                  onTap: () => context.push('/coaches/${member.id}'),
                );
              },
            ),
            loading: () => _buildShimmerList(3, 140),
            error: (error, stack) => const Center(
              child: Text('Error loading team', style: AppTypography.bodySmall),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context) {
    final habitsAsync = ref.watch(habitConfigsProvider);
    // Hide the whole section when no habits are configured in the admin.
    if (habitsAsync.valueOrNull?.isEmpty ?? false) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sectionSpacing,
            AppSpacing.screenPadding,
            14,
          ),
          child: Text('Daily Habits', style: AppTypography.sectionTitle),
        ),
        habitsAsync.when(
          data: (habits) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: habits.take(4).map((habit) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - AppSpacing.screenPadding * 2 - 12) / 2,
                    child: HabitImageCard(
                      label: habit.displayText,
                      imageUrl: _getHabitImage(habit.icon),
                      isCompleted: _completedHabits[habit.id] ?? false,
                      onTap: () => setState(() => _completedHabits[habit.id] = !(_completedHabits[habit.id] ?? false)),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Row(
              children: [
                Expanded(child: Container(height: 100, decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(16)))),
                const SizedBox(width: 12),
                Expanded(child: Container(height: 100, decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(16)))),
              ],
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTodaysWorkoutSection(BuildContext context) {
    final workoutAsync = ref.watch(todaysWorkoutProvider);
    // Hide the section when no workout is scheduled for today.
    final workout = workoutAsync.valueOrNull;
    if (!workoutAsync.isLoading && workout == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sectionSpacing,
            AppSpacing.screenPadding,
            14,
          ),
          child: Text("Today's Workout", style: AppTypography.sectionTitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: workout != null
              ? WorkoutCardHero(
                  title: workout.title,
                  subtitle: workout.description,
                  imageUrl: workout.thumbnailUrl ?? '',
                  durationMinutes: workout.durationMinutes,
                  calories: workout.caloriesBurned,
                  onTap: () => context.push('/workouts/${workout.id}'),
                )
              : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProgramsSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sectionSpacing,
            AppSpacing.screenPadding,
            14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Featured Programs', style: AppTypography.sectionTitle),
              TextButton(
                onPressed: () => context.push('/programs'),
                child: Text('See All', style: AppTypography.buttonSmall.copyWith(color: AppColors.pinkDark)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ref.watch(featuredProgramsProvider).when(
            data: (programs) {
              if (programs.isEmpty) return const SizedBox.shrink();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final program = programs[index];
                  return PromoCard(
                    title: program.title,
                    subtitle: program.description,
                    imageUrl: program.thumbnailUrl ?? '',
                    tag: index == 0 ? 'POPULAR' : null,
                    onTap: () => context.push('/programs/${program.id}'),
                  );
                },
              );
            },
            loading: () => _buildShimmerList(2, 280),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChallengeSection(BuildContext context) {
    final challengeAsync = ref.watch(todaysChallengeProvider);
    final challenge = challengeAsync.valueOrNull;
    // Hide the section when no challenge is scheduled for today.
    if (!challengeAsync.isLoading && challenge == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sectionSpacing,
            AppSpacing.screenPadding,
            14,
          ),
          child: Text('Daily Challenge', style: AppTypography.sectionTitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: challenge != null
              ? HorizontalImageCard(
                  title: challenge.title,
                  subtitle: challenge.description ?? '${challenge.targetDisplay} • ${challenge.points} pts',
                  imageUrl: challenge.thumbnailUrl ?? '',
                  badge: 'TODAY',
                  onTap: () => context.go(AppRoutes.challenges),
                )
              : Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildRecipeSection(BuildContext context) {
    final recipeAsync = ref.watch(recipeOfTheDayProvider);
    final recipe = recipeAsync.valueOrNull;
    // Hide the section when no recipe is scheduled for today.
    if (!recipeAsync.isLoading && recipe == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sectionSpacing,
            AppSpacing.screenPadding,
            14,
          ),
          child: Text('Recipe of the Day', style: AppTypography.sectionTitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: recipe != null
              ? HorizontalImageCard(
                  title: recipe.title,
                  subtitle: [
                    if (recipe.caloriesPerServing != null) '${recipe.caloriesPerServing} cal',
                    if (recipe.proteinGrams != null) '${recipe.proteinGrams}g protein',
                    '${recipe.totalTimeMinutes} min',
                  ].join(' \u2022 '),
                  imageUrl: recipe.thumbnailUrl ?? '',
                  onTap: () => context.push('/nutrition/${recipe.id}'),
                )
              : Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildQuoteSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sectionSpacing,
        AppSpacing.screenPadding,
        0,
      ),
      child: ref.watch(todaysQuoteProvider).when(
        data: (quote) {
          final quoteText = quote?.text ?? '"Your only limit is you."';
          final author = quote?.author ?? 'LA GYM';
          return _buildQuoteCard(quoteText, author);
        },
        loading: () => _buildQuoteCard('"Your only limit is you."', 'LA GYM'),
        error: (_, __) => _buildQuoteCard('"Your only limit is you."', 'LA GYM'),
      ),
    );
  }

  Widget _buildQuoteCard(String quoteText, String author) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppShadows.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400&h=200&fit=crop',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.pinkDark.withValues(alpha: 0.9),
                  AppColors.coral.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        quoteText.startsWith('"') ? quoteText : '"$quoteText"',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '- $author',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  PhosphorIcons.sparkle(PhosphorIconsStyle.fill),
                  color: AppColors.white.withValues(alpha: 0.8),
                  size: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList(int count, double width) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: count,
      itemBuilder: (context, index) => Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String _getHabitImage(String icon) {
    switch (icon) {
      case 'droplet':
        return 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=200&h=150&fit=crop';
      case 'footprints':
        return 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=200&h=150&fit=crop';
      case 'moon':
        return 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=200&h=150&fit=crop';
      case 'apple':
        return 'https://images.unsplash.com/photo-1568702846914-96b305d2uj38?w=200&h=150&fit=crop';
      case 'dumbbell':
        return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&h=150&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=200&h=150&fit=crop';
    }
  }
}
