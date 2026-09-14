import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../domain/entities/coach.dart';
import '../../../providers/team_members_provider.dart';

/// Screen displaying the team members for private coaching
class CoachesScreen extends ConsumerWidget {
  const CoachesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamMembersAsync = ref.watch(allTeamMembersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Our Team'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: teamMembersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading team: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(allTeamMembersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (coaches) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Meet Our Team',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Get personalized support from our expert coaches, nutritionist, and physiotherapist.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Coach Cards
              ...List.generate(
                coaches.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: _CoachCard(
                    coach: coaches[index],
                    onTap: () {
                      context.push('/coaches/${coaches[index].id}');
                    },
                  ),
                ),
              ),

              // Benefits Section
              const SizedBox(height: AppSpacing.lg),
              const _BenefitsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  final Coach coach;
  final VoidCallback onTap;

  const _CoachCard({
    required this.coach,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusLg),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: coach.avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: coach.avatarUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.accent.withOpacity(0.2),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            _CoachPlaceholder(name: coach.name),
                      )
                    : _CoachPlaceholder(name: coach.name),
              ),
            ),

            // Coach Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.name,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    coach.title ?? '',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Specialties
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: coach.specialties.map((specialty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          specialty,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Bio Preview
                  Text(
                    coach.bio ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Availability indicator
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: coach.acceptsNewClients
                              ? Colors.green
                              : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        coach.acceptsNewClients
                            ? 'Accepting new clients'
                            : 'Limited availability',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
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

class _CoachPlaceholder extends StatelessWidget {
  final String name;

  const _CoachPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.accent.withOpacity(0.3),
      child: Center(
        child: Text(
          name.split(' ').map((n) => n[0]).take(2).join(),
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.primary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection();

  static const List<_Benefit> benefits = [
    _Benefit(
      icon: Icons.person_outline,
      title: 'Personalized Plans',
      description: 'Custom training plans tailored to your goals',
    ),
    _Benefit(
      icon: Icons.chat_bubble_outline,
      title: 'Direct Communication',
      description: 'Stay connected with your coach',
    ),
    _Benefit(
      icon: Icons.trending_up,
      title: 'Progress Tracking',
      description: 'Monitor your improvements over time',
    ),
    _Benefit(
      icon: Icons.calendar_today_outlined,
      title: 'Flexible Scheduling',
      description: 'Workouts that fit your lifestyle',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Private Coaching?',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
          ),
          itemCount: benefits.length,
          itemBuilder: (context, index) {
            final benefit = benefits[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    benefit.icon,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    benefit.title,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    benefit.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Benefit {
  final IconData icon;
  final String title;
  final String description;

  const _Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });
}
