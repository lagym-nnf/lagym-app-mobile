import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../domain/entities/training_plan.dart';
import '../../../domain/entities/coach.dart';
import '../../widgets/common/app_button.dart';

/// Screen displaying the user's personalized training plan from their coach
class MyTrainingPlanScreen extends ConsumerStatefulWidget {
  const MyTrainingPlanScreen({super.key});

  @override
  ConsumerState<MyTrainingPlanScreen> createState() =>
      _MyTrainingPlanScreenState();
}

class _MyTrainingPlanScreenState extends ConsumerState<MyTrainingPlanScreen> {
  DateTime _selectedWeekStart = _getWeekStart(DateTime.now());
  TrainingPlan? _plan;
  Coach? _coach;
  List<TrainingPlanWorkout> _workouts = [];

  static DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Fetch from Supabase
    // Mock data for now
    setState(() {
      _coach = const Coach(
        id: '1',
        name: 'Iva Opačak',
        title: 'Head Coach & Co-Founder',
        avatarUrl: null,
        specialties: ['Strength', 'Conditioning'],
        isPrivateCoach: true,
      );

      _plan = TrainingPlan(
        id: '1',
        coachId: '1',
        clientUserId: 'user1',
        title: 'Strength Building Program',
        description:
            'A 4-week program focused on building lean muscle and functional strength.',
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 21)),
        durationWeeks: 4,
        status: TrainingPlanStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      );

      _workouts = [
        TrainingPlanWorkout(
          id: '1',
          trainingPlanId: '1',
          workoutId: 'w1',
          scheduledDate: _selectedWeekStart,
          weekNumber: 2,
          dayOfWeek: 1,
          coachNotes: 'Focus on form today. Take your time with the warm-up.',
          isCompleted: true,
          completedAt: _selectedWeekStart,
          createdAt: DateTime.now(),
          workoutTitle: 'Upper Body Strength',
          workoutDurationMinutes: 45,
          workoutType: 'setsReps',
        ),
        TrainingPlanWorkout(
          id: '2',
          trainingPlanId: '1',
          workoutId: 'w2',
          scheduledDate: _selectedWeekStart.add(const Duration(days: 1)),
          weekNumber: 2,
          dayOfWeek: 2,
          coachNotes: 'Active recovery day - don\'t skip the stretching!',
          isCompleted: true,
          completedAt: _selectedWeekStart.add(const Duration(days: 1)),
          createdAt: DateTime.now(),
          workoutTitle: 'Recovery & Mobility',
          workoutDurationMinutes: 30,
          workoutType: 'followAlong',
        ),
        TrainingPlanWorkout(
          id: '3',
          trainingPlanId: '1',
          workoutId: 'w3',
          scheduledDate: _selectedWeekStart.add(const Duration(days: 2)),
          weekNumber: 2,
          dayOfWeek: 3,
          coachNotes: null,
          isCompleted: false,
          createdAt: DateTime.now(),
          workoutTitle: 'Lower Body Power',
          workoutDurationMinutes: 50,
          workoutType: 'setsReps',
        ),
        TrainingPlanWorkout(
          id: '4',
          trainingPlanId: '1',
          workoutId: 'w4',
          scheduledDate: _selectedWeekStart.add(const Duration(days: 4)),
          weekNumber: 2,
          dayOfWeek: 5,
          coachNotes: 'Push yourself today! You\'ve got this.',
          isCompleted: false,
          createdAt: DateTime.now(),
          workoutTitle: 'Full Body HIIT',
          workoutDurationMinutes: 35,
          workoutType: 'followAlong',
        ),
        TrainingPlanWorkout(
          id: '5',
          trainingPlanId: '1',
          workoutId: 'w5',
          scheduledDate: _selectedWeekStart.add(const Duration(days: 5)),
          weekNumber: 2,
          dayOfWeek: 6,
          coachNotes: 'End the week strong with this core-focused session.',
          isCompleted: false,
          createdAt: DateTime.now(),
          workoutTitle: 'Core & Stability',
          workoutDurationMinutes: 40,
          workoutType: 'setsReps',
        ),
      ];
    });
  }

  void _previousWeek() {
    setState(() {
      _selectedWeekStart =
          _selectedWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
    });
  }

  List<TrainingPlanWorkout> _getWorkoutsForDay(int dayIndex) {
    final date = _selectedWeekStart.add(Duration(days: dayIndex));
    return _workouts.where((w) {
      return w.scheduledDate.year == date.year &&
          w.scheduledDate.month == date.month &&
          w.scheduledDate.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_plan == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Training Plan'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No Active Training Plan',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Request private coaching to get a\npersonalized training plan.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Find a Coach',
                onPressed: () => context.push('/coaches'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Training Plan'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Plan Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _plan!.title,
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'with ${_coach?.name}',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildProgressIndicator(),
                  ],
                ),
                if (_plan!.description != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _plan!.description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Week Navigation
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousWeek,
                  color: AppColors.textPrimary,
                ),
                Text(
                  '${DateFormat('MMM d').format(_selectedWeekStart)} - ${DateFormat('MMM d').format(_selectedWeekStart.add(const Duration(days: 6)))}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextWeek,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),

          // Weekly Calendar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = _selectedWeekStart.add(Duration(days: index));
                final dayWorkouts = _getWorkoutsForDay(index);
                final isToday = _isToday(date);

                return _DayCard(
                  date: date,
                  isToday: isToday,
                  workouts: dayWorkouts,
                  onWorkoutTap: (workout) {
                    context.push('/workouts/${workout.workoutId}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = _plan!.getProgressPercentage();
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            strokeWidth: 6,
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _DayCard extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final List<TrainingPlanWorkout> workouts;
  final void Function(TrainingPlanWorkout) onWorkoutTap;

  const _DayCard({
    required this.date,
    required this.isToday,
    required this.workouts,
    required this.onWorkoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE').format(date);
    final dayNumber = DateFormat('d').format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isToday ? AppColors.primary : AppColors.border,
          width: isToday ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusMd - 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Center(
                    child: Text(
                      dayNumber,
                      style: AppTypography.titleMedium.copyWith(
                        color:
                            isToday ? AppColors.textLight : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isToday)
                      Text(
                        'Today',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                if (workouts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      '${workouts.length} workout${workouts.length > 1 ? 's' : ''}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Workouts
          if (workouts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Rest day',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...workouts.map((workout) => _WorkoutTile(
                  workout: workout,
                  onTap: () => onWorkoutTap(workout),
                )),
        ],
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  final TrainingPlanWorkout workout;
  final VoidCallback onTap;

  const _WorkoutTile({
    required this.workout,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            // Completion indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: workout.isCompleted
                    ? Colors.green
                    : AppColors.border,
                shape: BoxShape.circle,
              ),
              child: workout.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),

            // Workout info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.workoutTitle ?? 'Workout',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      decoration: workout.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs / 2),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs / 2),
                      Text(
                        '${workout.workoutDurationMinutes} min',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm / 2),
                        ),
                        child: Text(
                          workout.workoutType == 'followAlong'
                              ? 'Follow Along'
                              : 'Sets & Reps',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (workout.coachNotes != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs / 2),
                        Expanded(
                          child: Text(
                            workout.coachNotes!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
