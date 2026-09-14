import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/muscles.dart';
import '../../../core/utils/youtube_utils.dart';
import '../../../domain/entities/workout.dart';
import '../youtube_player_widget.dart';
import 'body_map.dart';
import 'rest_timer_sheet.dart';

/// Bottom sheet with the exercise's details and the worked muscle groups
/// highlighted on the body map.
void showExerciseDetailSheet(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ExerciseDetailSheet(exercise: exercise),
  );
}

class ExerciseDetailSheet extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailSheet({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (exercise.thumbnailUrl != null ||
                  exercise.videoUrl != null) ...[
                _MediaHeader(exercise: exercise),
                const SizedBox(height: 20),
              ],
              Text(exercise.name, style: AppTypography.h2),
              if (exercise.description != null &&
                  exercise.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  exercise.description!,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // sets/reps/duration read differently for AMRAP (time cap),
                  // EMOM (sets = minutes) and rep dropsets (scheme sets the
                  // reps), so their badge + description carry the details.
                  if (exercise.setType == SetType.normal ||
                      exercise.setType == SetType.dropset ||
                      exercise.setType == SetType.onTime) ...[
                    if (exercise.sets != null)
                      _StatChip(label: '${exercise.sets} sets'),
                    if (exercise.repsDisplay != null)
                      _StatChip(label: exercise.repsDisplay!),
                    if (exercise.durationSeconds != null)
                      _StatChip(label: '${exercise.durationSeconds}s'),
                  ],
                  if (exercise.setType != SetType.amrap &&
                      exercise.setType != SetType.emom &&
                      (exercise.restSeconds ?? 0) > 0)
                    GestureDetector(
                      onTap: () => showRestTimerSheet(
                        context,
                        seconds: exercise.restSeconds!,
                        title: 'Rest · ${exercise.name}',
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.pinkLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(PhosphorIcons.timer(),
                                size: 14, color: AppColors.pinkDark),
                            const SizedBox(width: 4),
                            Text(
                              '${exercise.restSeconds}s rest',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.pinkDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (exercise.setTypeLabel != null)
                    _StatChip(
                      label: exercise.setTypeLabel!,
                      background: AppColors.softCoral.withValues(alpha: 0.25),
                      foreground: AppColors.deepRose,
                    ),
                ],
              ),
              if (exercise.setTypeDescription != null) ...[
                const SizedBox(height: 12),
                Text(
                  exercise.setTypeDescription!,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
              if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.pinkLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    exercise.notes!,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
              if (exercise.targetMuscles.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('Muscles worked', style: AppTypography.h3),
                const SizedBox(height: 12),
                BodyMap(highlighted: exercise.targetMuscles.toSet()),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: exercise.targetMuscles
                      .map((slug) => _StatChip(
                            label: Muscles.label(slug),
                            background:
                                const Color(0xFFF08A76).withValues(alpha: 0.18),
                            foreground: AppColors.deepRose,
                          ),)
                      .toList(),
                ),
              ],
              if (exercise.instructions.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('Instructions', style: AppTypography.h3),
                const SizedBox(height: 12),
                ...exercise.instructions.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${entry.key + 1}',
                                style: AppTypography.captionSmall
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: AppTypography.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
              if (exercise.tips.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Tips', style: AppTypography.h3),
                const SizedBox(height: 12),
                ...exercise.tips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 18, color: AppColors.goldDark,),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(tip, style: AppTypography.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Exercise thumbnail; when the exercise has a video the image gets a play
/// overlay and opens the full-screen player (YouTube) or the browser.
class _MediaHeader extends StatelessWidget {
  final Exercise exercise;

  const _MediaHeader({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final videoUrl = exercise.videoUrl;
    final videoId =
        videoUrl != null ? YouTubeUtils.extractVideoId(videoUrl) : null;
    // Fall back to the YouTube thumbnail when no image was uploaded.
    final thumbnailUrl = exercise.thumbnailUrl ??
        (videoId != null ? YouTubeUtils.getThumbnailUrl(videoId) : null);

    final image = thumbnailUrl != null
        ? CachedNetworkImage(
            imageUrl: thumbnailUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              height: 180,
              color: AppColors.gray900,
            ),
          )
        : Container(
            height: 180,
            width: double.infinity,
            color: AppColors.gray900,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: videoUrl == null
          ? image
          : GestureDetector(
              onTap: () => _openVideo(context, videoUrl),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  image,
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.deepRose,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _openVideo(BuildContext context, String url) {
    if (YouTubeUtils.isYouTubeUrl(url)) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => YouTubeFullScreenPlayer(
            youtubeUrl: url,
            title: exercise.name,
          ),
        ),
      );
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _StatChip({
    required this.label,
    this.background = AppColors.gray100,
    this.foreground = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium
            .copyWith(color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}
