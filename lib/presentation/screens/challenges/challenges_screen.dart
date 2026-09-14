import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/constants.dart';
import '../../../domain/entities/daily_challenge.dart';
import '../../../providers/challenges_provider.dart';
import '../../widgets/common/image_card.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysChallenge = ref.watch(todaysChallengeProvider);
    final upcomingChallenges = ref.watch(upcomingChallengesProvider);
    final pastChallenges = ref.watch(pastChallengesProvider);

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Challenges', style: AppTypography.greetingLarge),
                    Icon(PhosphorIcons.trophy(), color: AppColors.gray900),
                  ],
                ),
              ),

              // Today's challenge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: todaysChallenge.when(
                  data: (challenge) => challenge != null
                      ? _TodaysChallengeCard(challenge: challenge)
                      : const _NoChallengeCard(),
                  loading: () => const _ChallengePlaceholder(height: 260),
                  error: (_, __) => const _NoChallengeCard(),
                ),
              ),

              // Upcoming challenges
              upcomingChallenges.maybeWhen(
                data: (challenges) {
                  final upcoming = challenges
                      .where((c) => !_isToday(c.scheduledDate))
                      .toList();
                  if (upcoming.isEmpty) return const SizedBox.shrink();
                  return _ChallengeSection(
                    title: 'Coming Up',
                    children: upcoming
                        .map((c) => ChallengeImageCard(
                              title: _dayLabel(c.scheduledDate),
                              subtitle: '${c.title} · ${c.targetDisplay}',
                              imageUrl: c.thumbnailUrl ?? '',
                              onTap: () {},
                            ),)
                        .toList(),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),

              // Past challenges
              pastChallenges.maybeWhen(
                data: (challenges) {
                  if (challenges.isEmpty) return const SizedBox.shrink();
                  return _ChallengeSection(
                    title: 'Past Challenges',
                    children: challenges
                        .take(7)
                        .map((c) => ChallengeImageCard(
                              title: DateFormat('EEEE, MMM d')
                                  .format(c.scheduledDate),
                              subtitle: '${c.title} · ${c.targetDisplay}',
                              imageUrl: c.thumbnailUrl ?? '',
                              onTap: () {},
                            ),)
                        .toList(),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return DateFormat('EEEE').format(date);
  }
}

class _ChallengeSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ChallengeSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
          child: Text(title, style: AppTypography.sectionTitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TodaysChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;

  const _TodaysChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppShadows.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (challenge.thumbnailUrl != null)
            CachedNetworkImage(
              imageUrl: challenge.thumbnailUrl!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  const ColoredBox(color: AppColors.gray900),
            )
          else
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.pinkDark, AppColors.coral],
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.pinkDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    "TODAY'S CHALLENGE",
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  challenge.title,
                  textAlign: TextAlign.center,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _HeroChip(
                      icon: PhosphorIcons.target(),
                      label: challenge.targetDisplay,
                    ),
                    const SizedBox(width: 10),
                    _HeroChip(
                      icon: PhosphorIcons.clock(),
                      label: '',
                      child: const _TimeLeftToday(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? child;

  const _HeroChip({required this.icon, required this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 18),
          const SizedBox(width: 6),
          child ??
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
        ],
      ),
    );
  }
}

/// Live countdown of the time left to complete today's challenge (until
/// midnight local time).
class _TimeLeftToday extends StatefulWidget {
  const _TimeLeftToday();

  @override
  State<_TimeLeftToday> createState() => _TimeLeftTodayState();
}

class _TimeLeftTodayState extends State<_TimeLeftToday> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final left = midnight.difference(now);
    final h = left.inHours.toString().padLeft(2, '0');
    final m = (left.inMinutes % 60).toString().padLeft(2, '0');
    final s = (left.inSeconds % 60).toString().padLeft(2, '0');
    return Text(
      '$h:$m:$s',
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _NoChallengeCard extends StatelessWidget {
  const _NoChallengeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.pinkLight,
              shape: BoxShape.circle,
            ),
            child: Icon(PhosphorIcons.trophy(), color: AppColors.pinkDark),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('No challenge today', style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(
                  'Check back tomorrow for a new challenge.',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengePlaceholder extends StatelessWidget {
  final double height;

  const _ChallengePlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
    );
  }
}
