import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/constants.dart';

/// Hero workout card for featured workouts
class WorkoutCardHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int durationMinutes;
  final int calories;
  final VoidCallback? onTap;

  const WorkoutCardHero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.durationMinutes,
    required this.calories,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSpacing.cardHeightLarge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.gray100,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.gray100,
                child: const Icon(Icons.error),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _MetaBadge(
                        icon: PhosphorIcons.clock(),
                        label: '$durationMinutes min',
                      ),
                      const SizedBox(width: 12),
                      _MetaBadge(
                        icon: PhosphorIcons.flame(),
                        label: '$calories Cal',
                      ),
                    ],
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

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.white,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid workout card for category display
class WorkoutCardGrid extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  const WorkoutCardGrid({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSpacing.cardHeightMedium,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.sm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.gray100,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.gray100,
                child: const Icon(Icons.error),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.white,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
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

/// Horizontal card for lists
class HorizontalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const HorizontalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = AppColors.pinkDark,
    this.iconBgColor = AppColors.pink,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.cardSubtitle,
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              color: AppColors.gray400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
