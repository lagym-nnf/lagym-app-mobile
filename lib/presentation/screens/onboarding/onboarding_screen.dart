import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/user_profile.dart';
import '../../router/app_router.dart';
import '../../widgets/common/app_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  final _selectedGoals = <FitnessGoal>{};
  WorkoutLocation? _selectedLocation;
  FitnessLevel? _selectedLevel;

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    // Persist onboarding answers; navigation proceeds even if the write
    // fails (profile can be completed later from settings).
    try {
      final user = SupabaseConfig.currentUser;
      if (user != null) {
        // Upsert: OAuth sign-ins don't create a profile row at signup,
        // so this may be the first write for this user.
        await SupabaseConfig.client.from('profiles').upsert({
          'id': user.id,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'],
          'fitness_goals': _selectedGoals.map((g) => g.name).toList(),
          'workout_location': _selectedLocation?.name,
          'fitness_level': _selectedLevel?.name,
          'onboarding_completed': true,
        }, onConflict: 'id');
      }
    } catch (e) {
      AppLogger.error('Failed to save onboarding data', e);
    }

    if (!mounted) return;
    // Land on home with the paywall on top: new users see the 3-day free
    // trial offer immediately, and dismissing it reveals the home screen.
    context.go(AppRoutes.home);
    context.push(AppRoutes.subscription);
  }

  bool get _canContinue {
    switch (_currentStep) {
      case 0:
        return _selectedGoals.isNotEmpty;
      case 1:
        return _selectedLocation != null;
      case 2:
        return _selectedLevel != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? AppColors.pinkDark
                            : AppColors.gray200,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStepContent(),
              ),
            ),
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: AppButton(
                label: _currentStep == 2 ? 'Start Your Journey' : 'Continue',
                onPressed: _canContinue ? _nextStep : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _GoalsStep(
          key: const ValueKey(0),
          selectedGoals: _selectedGoals,
          onGoalToggled: (goal) {
            setState(() {
              if (_selectedGoals.contains(goal)) {
                _selectedGoals.remove(goal);
              } else {
                _selectedGoals.add(goal);
              }
            });
          },
        );
      case 1:
        return _LocationStep(
          key: const ValueKey(1),
          selectedLocation: _selectedLocation,
          onLocationSelected: (location) {
            setState(() {
              _selectedLocation = location;
            });
          },
        );
      case 2:
        return _LevelStep(
          key: const ValueKey(2),
          selectedLevel: _selectedLevel,
          onLevelSelected: (level) {
            setState(() {
              _selectedLevel = level;
            });
          },
        );
      default:
        return const SizedBox();
    }
  }
}

class _GoalsStep extends StatelessWidget {
  final Set<FitnessGoal> selectedGoals;
  final ValueChanged<FitnessGoal> onGoalToggled;

  const _GoalsStep({
    super.key,
    required this.selectedGoals,
    required this.onGoalToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your fitness goal?",
            style: AppTypography.h1,
          ),
          const SizedBox(height: 8),
          Text(
            'Select all that apply',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
          ),
          const SizedBox(height: 32),
          _GoalOption(
            icon: PhosphorIcons.barbell(),
            label: 'Build Strength',
            isSelected: selectedGoals.contains(FitnessGoal.buildStrength),
            onTap: () => onGoalToggled(FitnessGoal.buildStrength),
          ),
          const SizedBox(height: 12),
          _GoalOption(
            icon: PhosphorIcons.flame(),
            label: 'Lose Weight',
            isSelected: selectedGoals.contains(FitnessGoal.loseWeight),
            onTap: () => onGoalToggled(FitnessGoal.loseWeight),
          ),
          const SizedBox(height: 12),
          _GoalOption(
            icon: PhosphorIcons.heart(),
            label: 'Stay Healthy',
            isSelected: selectedGoals.contains(FitnessGoal.stayHealthy),
            onTap: () => onGoalToggled(FitnessGoal.stayHealthy),
          ),
          const SizedBox(height: 12),
          _GoalOption(
            icon: PhosphorIcons.sparkle(),
            label: 'Tone Up',
            isSelected: selectedGoals.contains(FitnessGoal.toneUp),
            onTap: () => onGoalToggled(FitnessGoal.toneUp),
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.pinkDark : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.pinkDark,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.pinkDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.check(),
                  color: AppColors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationStep extends StatelessWidget {
  final WorkoutLocation? selectedLocation;
  final ValueChanged<WorkoutLocation> onLocationSelected;

  const _LocationStep({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where do you workout?',
            style: AppTypography.h1,
          ),
          const SizedBox(height: 8),
          Text(
            "We'll customize your experience",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
          ),
          const SizedBox(height: 32),
          _LocationOption(
            imageUrl:
                'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=300&h=200&fit=crop',
            label: 'At the Gym',
            subtitle: 'Full equipment access',
            isSelected: selectedLocation == WorkoutLocation.gym,
            onTap: () => onLocationSelected(WorkoutLocation.gym),
          ),
          const SizedBox(height: 12),
          _LocationOption(
            imageUrl:
                'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=300&h=200&fit=crop',
            label: 'At Home',
            subtitle: 'Minimal equipment',
            isSelected: selectedLocation == WorkoutLocation.home,
            onTap: () => onLocationSelected(WorkoutLocation.home),
          ),
          const SizedBox(height: 12),
          _LocationOption(
            imageUrl:
                'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=300&h=200&fit=crop',
            label: 'Home Gym',
            subtitle: 'Personal setup',
            isSelected: selectedLocation == WorkoutLocation.homeGym,
            onTap: () => onLocationSelected(WorkoutLocation.homeGym),
          ),
        ],
      ),
    );
  }
}

class _LocationOption extends StatelessWidget {
  final String imageUrl;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationOption({
    required this.imageUrl,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(
            color: isSelected ? AppColors.pinkDark : Colors.transparent,
            width: 3,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
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
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.captionSmall.copyWith(
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

class _LevelStep extends StatelessWidget {
  final FitnessLevel? selectedLevel;
  final ValueChanged<FitnessLevel> onLevelSelected;

  const _LevelStep({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your level?",
            style: AppTypography.h1,
          ),
          const SizedBox(height: 8),
          Text(
            "We'll match your workouts",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
          ),
          const SizedBox(height: 32),
          _LevelOption(
            icon: PhosphorIcons.circle(),
            label: 'Beginner',
            subtitle: 'New to fitness',
            isSelected: selectedLevel == FitnessLevel.beginner,
            onTap: () => onLevelSelected(FitnessLevel.beginner),
          ),
          const SizedBox(height: 12),
          _LevelOption(
            icon: PhosphorIcons.circleDashed(),
            label: 'Intermediate',
            subtitle: 'Workout regularly',
            isSelected: selectedLevel == FitnessLevel.intermediate,
            onTap: () => onLevelSelected(FitnessLevel.intermediate),
          ),
          const SizedBox(height: 12),
          _LevelOption(
            icon: PhosphorIcons.target(),
            label: 'Advanced',
            subtitle: 'Experienced athlete',
            isSelected: selectedLevel == FitnessLevel.advanced,
            onTap: () => onLevelSelected(FitnessLevel.advanced),
          ),
        ],
      ),
    );
  }
}

class _LevelOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pinkLight : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.pinkDark : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.pink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.pinkDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.cardTitle.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.captionSmall,
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
