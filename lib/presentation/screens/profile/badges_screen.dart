import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/badge.dart' as badges;

// User stats: no activity-tracking backend yet, so everyone starts at the
// beginning — real values arrive once workout/challenge completion lands.
final userStatsProvider = StateProvider<badges.UserStats>((ref) => const badges.UserStats(
  totalWorkouts: 0,
  currentStreak: 0,
  longestStreak: 0,
  challengesCompleted: 0,
  totalMinutes: 0,
  totalCalories: 0,
  currentLevel: 1,
  currentXp: 0,
  xpToNextLevel: 100,
));

// Earned badges: none until completion tracking exists.
final earnedBadgesProvider = StateProvider<List<String>>((ref) => const []);

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final earnedBadgeIds = ref.watch(earnedBadgesProvider);

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
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
                        child: Icon(PhosphorIcons.arrowLeft(), size: 20, color: AppColors.gray900),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('Rewards', style: AppTypography.greetingLarge),
                  ],
                ),
              ),
            ),

            // Level card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.pinkDark, AppColors.coral],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    boxShadow: AppShadows.md,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Level badge
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'LVL',
                                    style: AppTypography.captionSmall.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  Text(
                                    '${stats.currentLevel}',
                                    style: AppTypography.h1.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Level ${stats.currentLevel}',
                                      style: AppTypography.h3.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '${stats.currentXp}/${stats.xpToNextLevel} XP',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: stats.levelProgress,
                                    minHeight: 10,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation(AppColors.white),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${stats.xpToNextLevel - stats.currentXp} XP to Level ${stats.currentLevel + 1}',
                                  style: AppTypography.captionSmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _MiniStat(
                        icon: PhosphorIcons.barbell(),
                        value: '${stats.totalWorkouts}',
                        label: 'Workouts',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MiniStat(
                        icon: PhosphorIcons.flame(),
                        value: '${stats.currentStreak}',
                        label: 'Day Streak',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MiniStat(
                        icon: PhosphorIcons.trophy(),
                        value: '${earnedBadgeIds.length}/${badges.allBadges.where((b) => !b.isSecret).length}',
                        label: 'Badges',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badges section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                child: Text('All Badges', style: AppTypography.sectionTitle),
              ),
            ),

            // Badge categories
            for (final category in badges.BadgeCategory.values) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
                  child: Text(
                    _getCategoryName(category),
                    style: AppTypography.cardTitle.copyWith(color: AppColors.gray600),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final categoryBadges = badges.allBadges.where((b) => b.category == category).toList();
                      if (index >= categoryBadges.length) return null;

                      final badge = categoryBadges[index];
                      final isEarned = earnedBadgeIds.contains(badge.id);
                      final isSecret = badge.isSecret && !isEarned;

                      return _BadgeCard(
                        badge: badge,
                        isEarned: isEarned,
                        isSecret: isSecret,
                        onTap: () => _showBadgeDetails(context, badge, isEarned, stats),
                      );
                    },
                    childCount: badges.allBadges.where((b) => b.category == category).length,
                  ),
                ),
              ),
            ],

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(badges.BadgeCategory category) {
    switch (category) {
      case badges.BadgeCategory.workouts:
        return 'Workout Milestones';
      case badges.BadgeCategory.streaks:
        return 'Streak Achievements';
      case badges.BadgeCategory.challenges:
        return 'Challenge Champions';
      case badges.BadgeCategory.milestones:
        return 'Fitness Milestones';
      case badges.BadgeCategory.special:
        return 'Secret Badges';
    }
  }

  void _showBadgeDetails(BuildContext context, badges.Achievement badge, bool isEarned, badges.UserStats stats) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Badge icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isEarned ? AppColors.gold : AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getBadgeIcon(badge.iconName),
                size: 50,
                color: isEarned ? AppColors.goldDark : AppColors.gray400,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              badge.name,
              style: AppTypography.h2.copyWith(
                color: isEarned ? AppColors.gray900 : AppColors.gray500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Reward
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isEarned ? AppColors.mint : AppColors.gray100,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIcons.star(PhosphorIconsStyle.fill),
                    size: 18,
                    color: isEarned ? AppColors.mintDark : AppColors.gray400,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isEarned ? '+${badge.xpReward} XP Earned' : '${badge.xpReward} XP Reward',
                    style: AppTypography.bodySmall.copyWith(
                      color: isEarned ? AppColors.mintDark : AppColors.gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (!isEarned) ...[
              const SizedBox(height: 20),

              // Progress
              _BadgeProgress(badge: badge, stats: stats),
            ],

            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.pinkDark, size: 20),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.cardTitle),
          Text(label, style: AppTypography.captionSmall),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final badges.Achievement badge;
  final bool isEarned;
  final bool isSecret;
  final VoidCallback onTap;

  const _BadgeCard({
    required this.badge,
    required this.isEarned,
    required this.isSecret,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: isEarned
              ? Border.all(color: AppColors.gold, width: 2)
              : null,
        ),
        child: Opacity(
          opacity: isEarned ? 1.0 : 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isEarned ? AppColors.gold : AppColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSecret ? PhosphorIcons.question() : _getBadgeIcon(badge.iconName),
                  color: isEarned ? AppColors.goldDark : AppColors.gray400,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  isSecret ? '???' : badge.name,
                  style: AppTypography.captionSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEarned ? AppColors.gray900 : AppColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeProgress extends StatelessWidget {
  final badges.Achievement badge;
  final badges.UserStats stats;

  const _BadgeProgress({required this.badge, required this.stats});

  @override
  Widget build(BuildContext context) {
    int current = 0;
    int required = badge.requirement;

    switch (badge.category) {
      case badges.BadgeCategory.workouts:
        current = stats.totalWorkouts;
        break;
      case badges.BadgeCategory.streaks:
        current = stats.longestStreak;
        break;
      case badges.BadgeCategory.challenges:
        current = stats.challengesCompleted;
        break;
      case badges.BadgeCategory.milestones:
        if (badge.id.contains('calories')) {
          current = stats.totalCalories;
        } else if (badge.id.contains('minutes')) {
          current = stats.totalMinutes;
        }
        break;
      case badges.BadgeCategory.special:
        current = 0;
        break;
    }

    final progress = (current / required).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppTypography.cardTitle),
              Text(
                '$current / $required',
                style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.gray200,
              valueColor: const AlwaysStoppedAnimation(AppColors.pinkDark),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _getBadgeIcon(String iconName) {
  switch (iconName) {
    case 'star':
      return PhosphorIcons.star(PhosphorIconsStyle.fill);
    case 'barbell':
      return PhosphorIcons.barbell(PhosphorIconsStyle.fill);
    case 'medal':
      return PhosphorIcons.medal(PhosphorIconsStyle.fill);
    case 'trophy':
      return PhosphorIcons.trophy(PhosphorIconsStyle.fill);
    case 'crown':
      return PhosphorIcons.crown(PhosphorIconsStyle.fill);
    case 'flame':
      return PhosphorIcons.flame(PhosphorIconsStyle.fill);
    case 'lightning':
      return PhosphorIcons.lightning(PhosphorIconsStyle.fill);
    case 'fire':
      return PhosphorIcons.fire(PhosphorIconsStyle.fill);
    case 'clock':
      return PhosphorIcons.clock(PhosphorIconsStyle.fill);
    case 'sun':
      return PhosphorIcons.sun(PhosphorIconsStyle.fill);
    case 'moon':
      return PhosphorIcons.moon(PhosphorIconsStyle.fill);
    default:
      return PhosphorIcons.trophy(PhosphorIconsStyle.fill);
  }
}
