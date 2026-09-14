import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/youtube_utils.dart';
import '../../../domain/entities/workout.dart';
import '../../../providers/workouts_provider.dart';
import '../../../providers/exercises_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/workouts/exercise_group_list.dart';
import '../../widgets/youtube_player_widget.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutProvider(workoutId));

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: workoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageView(onBack: () => context.pop()),
        data: (workout) {
          if (workout == null) {
            return _MessageView(onBack: () => context.pop());
          }
          return _WorkoutDetailContent(workout: workout);
        },
      ),
    );
  }
}

class _WorkoutDetailContent extends ConsumerWidget {
  final Workout workout;

  const _WorkoutDetailContent({required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSetsReps = workout.type == WorkoutType.setsReps;
    final exercisesAsync = isSetsReps
        ? ref.watch(workoutExercisesProvider(workout.id))
        : null;
    final exercises = exercisesAsync?.valueOrNull ?? const <Exercise>[];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: PhosphorIcons.arrowLeft(),
                    onTap: () => context.pop(),
                  ),
                  const Text(
                    'Workout',
                    style: AppTypography.cardTitle,
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
          ),
          // Hero image
          if (workout.thumbnailUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                child: CachedNetworkImage(
                  imageUrl: workout.thumbnailUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: AppColors.gray200,
                  ),
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: AppTypography.h2,
                ),
                if (workout.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    workout.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: PhosphorIcons.clock(),
                        value: '${workout.durationMinutes}m',
                        label: 'Duration',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: PhosphorIcons.flame(),
                        value: '${workout.caloriesBurned}',
                        label: 'Calories',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: PhosphorIcons.chartBar(),
                        value: workout.difficulty.name.length > 3
                            ? workout.difficulty.name
                                .substring(0, 3)
                                .toUpperCase()
                            : workout.difficulty.name.toUpperCase(),
                        label: 'Level',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Start button for video workouts — plays the workout's
                // video; hidden when the admin hasn't set one.
                if (!isSetsReps && workout.videoUrl != null) ...[
                  AppButton(
                    label: 'Start Workout',
                    size: AppButtonSize.large,
                    onPressed: () {
                      final url = workout.videoUrl!;
                      if (YouTubeUtils.isYouTubeUrl(url)) {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => YouTubeFullScreenPlayer(
                              youtubeUrl: url,
                              title: workout.title,
                            ),
                          ),
                        );
                      } else {
                        launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication,);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                // Exercises section for sets & reps workouts
                if (isSetsReps) ...[
                  Text(
                    'Exercises (${exercises.length})',
                    style: AppTypography.sectionTitle,
                  ),
                  const SizedBox(height: 14),
                  if (exercisesAsync?.isLoading ?? false)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (exercises.isEmpty)
                    Text(
                      'Exercises are being added to this workout.',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.gray500),
                    )
                  else
                    ExerciseGroupList(exercises: exercises),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final VoidCallback onBack;

  const _MessageView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: _CircleButton(
              icon: PhosphorIcons.arrowLeft(),
              onTap: onBack,
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(PhosphorIcons.barbell(),
                    size: 48, color: AppColors.gray300,),
                const SizedBox(height: 16),
                Text(
                  'Could not load workout.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: AppShadows.sm,
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.gray900,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.pinkDark,
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.cardTitle.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: AppTypography.captionSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
