import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/constants.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String workoutId;

  const VideoPlayerScreen({
    super.key,
    required this.workoutId,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  bool _isPlaying = false;
  final double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray900,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Video background (placeholder image)
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&h=500&fit=crop',
            fit: BoxFit.cover,
          ),
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.3, 0.5, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            PhosphorIcons.x(),
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        'Dumbbell Squats',
                        style: AppTypography.cardTitle.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 36),
                    ],
                  ),
                ),
                // Center play button
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying
                          ? PhosphorIcons.pause(PhosphorIconsStyle.fill)
                          : PhosphorIcons.play(PhosphorIconsStyle.fill),
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                ),
                const Spacer(),
                // Bottom controls
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Progress bar
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.pinkDark,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0:42',
                            style: AppTypography.captionSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            '2:00',
                            style: AppTypography.captionSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Exercise info card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CURRENT EXERCISE',
                                  style: AppTypography.labelUppercase,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Dumbbell Squats',
                                  style: AppTypography.h3.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Set 2 of 3 - 12 reps',
                                  style: AppTypography.captionSmall,
                                ),
                              ],
                            ),
                            Text(
                              '0:42',
                              style: AppTypography.timer,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Control buttons
                      Row(
                        children: [
                          Expanded(
                            child: _ControlButton(
                              icon: PhosphorIcons.skipBack(),
                              label: 'Previous',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ControlButton(
                              icon: _isPlaying
                                  ? PhosphorIcons.pause()
                                  : PhosphorIcons.play(),
                              label: _isPlaying ? 'Pause' : 'Play',
                              isPrimary: true,
                              onTap: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ControlButton(
                              icon: PhosphorIcons.skipForward(),
                              label: 'Next',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Up next
                      Text.rich(
                        TextSpan(
                          text: 'Up Next: ',
                          style: AppTypography.captionSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          children: [
                            TextSpan(
                              text: 'Romanian Deadlift',
                              style: AppTypography.captionSmall.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color:
              isPrimary ? AppColors.pinkDark : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.captionSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
