import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/constants.dart';

/// Small square card with image background for quick actions
class QuickActionImageCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback? onTap;

  const QuickActionImageCard({
    super.key,
    required this.label,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 8,
              right: 8,
              child: Text(
                label,
                style: AppTypography.captionSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal card with image background
class HorizontalImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? badge;
  final VoidCallback? onTap;

  const HorizontalImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
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
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pinkDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        badge!,
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
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

/// Habit check card with image background
class HabitImageCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final bool isCompleted;
  final VoidCallback? onTap;

  const HabitImageCard({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: AppShadows.sm,
          border: isCompleted
              ? Border.all(color: AppColors.mintDark, width: 3)
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            if (isCompleted)
              Container(
                color: AppColors.mintDark.withValues(alpha: 0.4),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.mintDark
                          : AppColors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? PhosphorIcons.check() : PhosphorIcons.circle(),
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
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

/// Promotional program card for carousel
class PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? tag;
  final VoidCallback? onTap;

  const PromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pinkDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        tag!,
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTypography.h2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
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

/// Category card with image background
class CategoryImageCard extends StatelessWidget {
  final String title;
  final String workoutCount;
  final String imageUrl;
  final VoidCallback? onTap;

  const CategoryImageCard({
    super.key,
    required this.title,
    required this.workoutCount,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
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
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.4, 1.0],
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
                    style: AppTypography.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workoutCount,
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

/// Team member card for coaches, nutritionists, etc.
class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final String? specialty;
  final VoidCallback? onTap;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    this.specialty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(
                color: AppColors.gray200,
                child: Icon(PhosphorIcons.user(), size: 40, color: AppColors.gray400),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (specialty != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        specialty!,
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.white,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recipe card with image background
class RecipeImageCard extends StatelessWidget {
  final String title;
  final String calories;
  final String time;
  final String imageUrl;
  final VoidCallback? onTap;

  const RecipeImageCard({
    super.key,
    required this.title,
    required this.calories,
    required this.time,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(PhosphorIcons.flame(), color: AppColors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        calories,
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(PhosphorIcons.clock(), color: AppColors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
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

/// Challenge card with image background
class ChallengeImageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isCompleted;
  final bool isToday;
  final VoidCallback? onTap;

  const ChallengeImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isCompleted = false,
    this.isToday = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.sm,
          border: isToday
              ? Border.all(color: AppColors.pinkDark, width: 3)
              : isCompleted
                  ? Border.all(color: AppColors.mintDark, width: 3)
                  : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.gray100),
              errorWidget: (context, url, error) => Container(color: AppColors.gray200),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            if (isCompleted)
              Container(color: AppColors.mintDark.withValues(alpha: 0.3)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pinkDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        'TODAY',
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.mintDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(PhosphorIcons.check(), color: AppColors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'COMPLETED',
                            style: AppTypography.captionSmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
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
