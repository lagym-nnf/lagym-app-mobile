import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/workout.dart';
import 'exercise_detail_sheet.dart';
import 'rest_timer_sheet.dart';

/// Exercise list that renders consecutive entries sharing a superset group
/// inside a bracketed container, with dropset badges per exercise.
/// Tapping an exercise opens the detail sheet with the body map.
class ExerciseGroupList extends StatelessWidget {
  final List<Exercise> exercises;

  const ExerciseGroupList({super.key, required this.exercises});

  List<List<Exercise>> _buildSegments() {
    final segments = <List<Exercise>>[];
    for (final exercise in exercises) {
      if (segments.isNotEmpty &&
          exercise.supersetGroup != null &&
          segments.last.last.supersetGroup == exercise.supersetGroup) {
        segments.last.add(exercise);
      } else {
        segments.add([exercise]);
      }
    }
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final segments = _buildSegments();

    return Column(
      children: [
        for (final segment in segments)
          if (segment.length >= 2)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.fromLTRB(10, 8, 0, 2),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: const Border(
                  left: BorderSide(color: AppColors.coral, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 6),
                    child: Row(
                      children: [
                        Icon(PhosphorIcons.arrowsClockwise(),
                            size: 14, color: AppColors.coral),
                        const SizedBox(width: 4),
                        Text(
                          'SUPERSET • no rest between exercises',
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.coral,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (final exercise in segment)
                    _ExerciseRow(exercise: exercise),
                ],
              ),
            )
          else
            _ExerciseRow(exercise: segment.first),
      ],
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseRow({required this.exercise});

  String get _subtitle {
    final parts = <String>[];
    switch (exercise.setType) {
      case SetType.amrap:
        parts.add(
            'max reps in ${((exercise.durationSeconds ?? 60) / 60).round()} min');
      case SetType.emom:
        parts.add('${exercise.sets ?? '?'} min');
        if (exercise.repsDisplay != null) {
          parts.add('${exercise.repsDisplay!}/min');
        }
      case SetType.repDropset:
        if (exercise.repScheme != null) parts.add('${exercise.repScheme} reps');
        if ((exercise.restSeconds ?? 0) > 0) {
          parts.add('${exercise.restSeconds}s rest');
        }
      default:
        if (exercise.sets != null) parts.add('${exercise.sets} sets');
        if (exercise.repsDisplay != null) parts.add(exercise.repsDisplay!);
        if (exercise.durationSeconds != null) {
          parts.add('${exercise.durationSeconds}s');
        }
        if ((exercise.restSeconds ?? 0) > 0) {
          parts.add('${exercise.restSeconds}s rest');
        }
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showExerciseDetailSheet(context, exercise),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: exercise.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: exercise.thumbnailUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const _ExercisePlaceholder(),
                    )
                  : const _ExercisePlaceholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name, style: AppTypography.cardTitle),
                  const SizedBox(height: 2),
                  Text(_subtitle, style: AppTypography.cardSubtitle),
                  if (exercise.setTypeLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.softCoral.withValues(alpha: 0.25),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          exercise.setTypeLabel!,
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.deepRose,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if ((exercise.restSeconds ?? 0) > 0) ...[
              GestureDetector(
                onTap: () => showRestTimerSheet(
                  context,
                  seconds: exercise.restSeconds!,
                  title: 'Rest · ${exercise.name}',
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.pinkLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.timer(),
                    size: 18,
                    color: AppColors.pinkDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              PhosphorIcons.caretRight(),
              size: 18,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExercisePlaceholder extends StatelessWidget {
  const _ExercisePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.pink,
      child: Icon(
        PhosphorIcons.barbell(),
        color: AppColors.pinkDark,
        size: 22,
      ),
    );
  }
}
