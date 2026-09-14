import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/muscles.dart';
import '../../../domain/entities/program.dart';
import '../../../domain/entities/workout.dart';
import '../../../providers/programs_provider.dart';
import '../../widgets/workouts/body_map.dart';
import '../../widgets/workouts/exercise_group_list.dart';

/// A structured gym day from a program: exercise list with supersets and
/// dropsets, plus an overview body map of all muscles worked that day.
class StructuredWorkoutScreen extends ConsumerWidget {
  final String programWorkoutId;
  final ProgramWorkout? initial;

  const StructuredWorkoutScreen({
    super.key,
    required this.programWorkoutId,
    this.initial,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayAsync = ref.watch(programWorkoutProvider(programWorkoutId));
    final day = dayAsync.valueOrNull ?? initial;

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: day == null
          ? (dayAsync.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _NotFoundView(onBack: () => context.pop()))
          : _StructuredDayContent(day: day),
    );
  }
}

class _StructuredDayContent extends StatelessWidget {
  final ProgramWorkout day;

  const _StructuredDayContent({required this.day});

  @override
  Widget build(BuildContext context) {
    final exercises = day.dayExercises
        .map((e) => e.exerciseWithContext)
        .whereType<Exercise>()
        .toList();
    final muscles = exercises
        .expand((e) => e.targetMuscles)
        .toSet();
    final supersetCount = day.dayExercises
        .map((e) => e.supersetGroup)
        .where((g) => g != null)
        .toSet()
        .length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.sm,
                      ),
                      child: Icon(PhosphorIcons.arrowLeft(),
                          size: 20, color: AppColors.gray900),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Day ${day.sequenceNumber}',
                      style: AppTypography.cardTitle),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.customTitle ?? 'Gym Day',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: PhosphorIcons.barbell(),
                        label: '${exercises.length} exercises',
                      ),
                      if (supersetCount > 0)
                        _InfoChip(
                          icon: PhosphorIcons.arrowsClockwise(),
                          label:
                              '$supersetCount superset${supersetCount > 1 ? 's' : ''}',
                        ),
                    ],
                  ),
                  if (day.notes != null && day.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Text(
                        day.notes!,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                  if (muscles.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Muscles worked today',
                        style: AppTypography.sectionTitle),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Column(
                        children: [
                          BodyMap(highlighted: muscles, height: 200),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6,
                            runSpacing: 6,
                            children: muscles
                                .map((slug) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF08A76)
                                            .withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusFull),
                                      ),
                                      child: Text(
                                        Muscles.label(slug),
                                        style: AppTypography.captionSmall
                                            .copyWith(
                                          color: AppColors.deepRose,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Exercises', style: AppTypography.sectionTitle),
                  const SizedBox(height: 14),
                  ExerciseGroupList(exercises: exercises),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.pinkDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelMedium
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  final VoidCallback onBack;

  const _NotFoundView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.sm,
                ),
                child: Icon(PhosphorIcons.arrowLeft(),
                    size: 20, color: AppColors.gray900),
              ),
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(PhosphorIcons.barbell(),
                    size: 48, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'Workout not found.',
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
