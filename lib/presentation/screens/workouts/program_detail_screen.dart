import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/program.dart';
import '../../../providers/programs_provider.dart';
import '../../widgets/common/app_button.dart';

class ProgramDetailScreen extends ConsumerWidget {
  final String programId;

  const ProgramDetailScreen({
    super.key,
    required this.programId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programProvider(programId));

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: programAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageView(
          icon: PhosphorIcons.wifiSlash(),
          message: 'Could not load program.',
          onBack: () => context.pop(),
        ),
        data: (program) {
          if (program == null) {
            return _MessageView(
              icon: PhosphorIcons.barbell(),
              message: 'Program not found.',
              onBack: () => context.pop(),
            );
          }
          return _ProgramDetailContent(program: program);
        },
      ),
    );
  }
}

class _ProgramDetailContent extends ConsumerWidget {
  final Program program;

  const _ProgramDetailContent({required this.program});

  Future<void> _enroll(BuildContext context, WidgetRef ref) async {
    try {
      await EnrollmentService.enroll(program.id);
      ref.invalidate(programEnrollmentProvider(program.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enrolled in ${program.title}!'),
            backgroundColor: AppColors.pinkDark,
          ),
        );
      }
    } catch (e) {
      debugPrint('Enroll failed for program ${program.id}: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not start program. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openWorkout(
    BuildContext context,
    WidgetRef ref,
    ProgramWorkout programWorkout,
    ProgramEnrollment? enrollment,
    bool isCurrent,
  ) async {
    final workout = programWorkout.workout;
    if (workout != null) {
      context.push('/workouts/${workout.id}');
    } else if (programWorkout.isStructuredDay) {
      context.push('/program-day/${programWorkout.id}', extra: programWorkout);
    } else {
      return;
    }

    // Completing the current day unlocks the next one
    if (isCurrent && enrollment != null) {
      await EnrollmentService.advance(enrollment);
      ref.invalidate(programEnrollmentProvider(program.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(programWorkoutsProvider(program.id));
    final enrollmentAsync = ref.watch(programEnrollmentProvider(program.id));

    final enrollment = enrollmentAsync.valueOrNull;
    final isEnrolled = enrollment != null;
    final currentDay = enrollment?.currentSequence ?? 1;
    final workouts = workoutsAsync.valueOrNull ?? const <ProgramWorkout>[];

    return CustomScrollView(
      slivers: [
        // Hero header
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColors.pinkLight,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.sm,
                ),
                child: Icon(PhosphorIcons.arrowLeft(), size: 20, color: AppColors.gray900),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (program.coverImageUrl != null)
                  CachedNetworkImage(
                    imageUrl: program.coverImageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(color: AppColors.gray200),
                  )
                else
                  Container(color: AppColors.gray200),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: program.isInfinity ? AppColors.coral : AppColors.pinkDark,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              program.isInfinity
                                  ? 'INFINITY PROGRAM'
                                  : '${program.durationWeeks ?? '-'} WEEK PROGRAM',
                              style: AppTypography.captionSmall.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (program.isPremium) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Row(
                                children: [
                                  Icon(PhosphorIcons.crown(PhosphorIconsStyle.fill), size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'PREMIUM',
                                    style: AppTypography.captionSmall.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        program.title,
                        style: AppTypography.h1.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coach info
                if (program.coachName != null)
                  Row(
                    children: [
                      if (program.coachImageUrl != null)
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: program.coachImageUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              width: 48,
                              height: 48,
                              color: AppColors.gray200,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Coach', style: AppTypography.captionSmall),
                          Text(program.coachName!, style: AppTypography.cardTitle),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Stats row
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: PhosphorIcons.barbell(),
                        value: '${workouts.isNotEmpty ? workouts.length : program.totalWorkouts}',
                        label: 'Workouts',
                      ),
                      _StatItem(
                        icon: PhosphorIcons.calendar(),
                        value: program.isInfinity ? '∞' : '${program.durationWeeks ?? '-'}',
                        label: 'Weeks',
                      ),
                      _StatItem(
                        icon: PhosphorIcons.chartBar(),
                        value: program.difficulty.name.length > 3
                            ? program.difficulty.name.substring(0, 3).toUpperCase()
                            : program.difficulty.name.toUpperCase(),
                        label: 'Level',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                Text('About', style: AppTypography.sectionTitle),
                const SizedBox(height: 8),
                Text(
                  program.description,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
                ),

                const SizedBox(height: 24),

                // Enroll/Continue button
                if (!isEnrolled)
                  AppButton(
                    label: 'Start Program',
                    size: AppButtonSize.large,
                    variant: AppButtonVariant.glow,
                    onPressed: () => _enroll(context, ref),
                  )
                else
                  Column(
                    children: [
                      // Progress indicator
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.pinkDark.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(color: AppColors.pinkDark.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill), color: AppColors.pinkDark),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Day $currentDay${program.isFixed && workouts.isNotEmpty ? ' of ${workouts.length}' : ''}',
                                    style: AppTypography.cardTitle.copyWith(color: AppColors.pinkDark),
                                  ),
                                  if (program.isFixed && workouts.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: (currentDay / workouts.length).clamp(0.0, 1.0),
                                        backgroundColor: AppColors.pinkDark.withValues(alpha: 0.2),
                                        valueColor: const AlwaysStoppedAnimation(AppColors.pinkDark),
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

                const SizedBox(height: 24),

                // Workouts section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      program.isInfinity ? 'Daily Workouts' : 'Program Workouts',
                      style: AppTypography.sectionTitle,
                    ),
                    if (program.isInfinity)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.coral.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          'Unlocks daily',
                          style: AppTypography.captionSmall.copyWith(color: AppColors.coral),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),

                if (workoutsAsync.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (workouts.isEmpty)
                  Text(
                    'Workouts are being added to this program.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                  ),
              ],
            ),
          ),
        ),

        // Workouts list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final programWorkout = workouts[index];
              final isUnlocked = !isEnrolled || programWorkout.sequenceNumber <= currentDay;
              final isCurrent = isEnrolled && programWorkout.sequenceNumber == currentDay;
              final isCompleted = isEnrolled && programWorkout.sequenceNumber < currentDay;

              if (programWorkout.isRestLike) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: _RestDayItem(
                    dayNumber: programWorkout.sequenceNumber,
                    title: programWorkout.customTitle ?? 'Rest Day',
                  ),
                );
              }

              final workout = programWorkout.workout;
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: _WorkoutItem(
                  title: workout?.title ??
                      programWorkout.customTitle ??
                      'Gym Day',
                  subtitle: workout != null
                      ? '${workout.durationMinutes} min • ${workout.caloriesBurned} cal'
                      : '${programWorkout.dayExercises.length} exercises • Gym day',
                  isGymDay: workout == null,
                  dayNumber: programWorkout.sequenceNumber,
                  isUnlocked: isUnlocked,
                  isCurrent: isCurrent,
                  isCompleted: isCompleted,
                  onTap: isUnlocked
                      ? () => _openWorkout(context, ref, programWorkout, enrollment, isCurrent)
                      : null,
                ),
              );
            },
            childCount: workouts.length,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onBack;

  const _MessageView({
    required this.icon,
    required this.message,
    required this.onBack,
  });

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
                child: Icon(PhosphorIcons.arrowLeft(), size: 20, color: AppColors.gray900),
              ),
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(icon, size: 48, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.pinkDark, size: 24),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800)),
        Text(label, style: AppTypography.captionSmall),
      ],
    );
  }
}

class _RestDayItem extends StatelessWidget {
  final int dayNumber;
  final String title;

  const _RestDayItem({required this.dayNumber, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(PhosphorIcons.moonStars(), color: AppColors.mintDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Day $dayNumber', style: AppTypography.captionSmall),
                Text(title, style: AppTypography.cardTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isGymDay;
  final int dayNumber;
  final bool isUnlocked;
  final bool isCurrent;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _WorkoutItem({
    required this.title,
    required this.subtitle,
    this.isGymDay = false,
    required this.dayNumber,
    required this.isUnlocked,
    required this.isCurrent,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.pinkDark.withValues(alpha: 0.1)
              : isCompleted
                  ? AppColors.white.withValues(alpha: 0.7)
                  : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: isCurrent ? Border.all(color: AppColors.pinkDark, width: 2) : null,
        ),
        child: Row(
          children: [
            // Day number or status icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.pinkDark
                    : isCurrent
                        ? AppColors.pinkDark
                        : isUnlocked
                            ? AppColors.pink
                            : AppColors.gray200,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(PhosphorIcons.check(PhosphorIconsStyle.bold), color: AppColors.white, size: 20)
                    : !isUnlocked
                        ? Icon(PhosphorIcons.lock(), color: AppColors.gray400, size: 20)
                        : Text(
                            '$dayNumber',
                            style: AppTypography.h3.copyWith(
                              color: isCurrent ? AppColors.white : AppColors.pinkDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
              ),
            ),
            const SizedBox(width: 12),
            // Workout info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle.copyWith(
                      color: isUnlocked ? AppColors.gray900 : AppColors.gray400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.cardSubtitle.copyWith(
                      color: isUnlocked ? AppColors.gray500 : AppColors.gray300,
                    ),
                  ),
                ],
              ),
            ),
            // Play / open button
            if (isUnlocked && !isCompleted)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.pinkDark : AppColors.pink,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isGymDay
                      ? PhosphorIcons.barbell(PhosphorIconsStyle.fill)
                      : PhosphorIcons.play(PhosphorIconsStyle.fill),
                  color: isCurrent ? AppColors.white : AppColors.pinkDark,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
