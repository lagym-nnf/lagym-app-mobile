import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../domain/entities/coach.dart';
import '../../../providers/team_members_provider.dart';
import '../../widgets/common/app_button.dart';

/// Detailed view of a coach with request coaching functionality
class CoachDetailScreen extends ConsumerStatefulWidget {
  final String coachId;

  const CoachDetailScreen({
    super.key,
    required this.coachId,
  });

  @override
  ConsumerState<CoachDetailScreen> createState() => _CoachDetailScreenState();
}

class _CoachDetailScreenState extends ConsumerState<CoachDetailScreen> {
  bool _isLoading = false;
  bool _hasActiveRequest = false;
  final bool _isCurrentClient = false;

  void _showRequestBottomSheet(Coach coach) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RequestCoachingSheet(
        coach: coach,
        onSubmit: (message) => _submitRequest(message, coach),
      ),
    );
  }

  Future<void> _submitRequest(String message, Coach coach) async {
    setState(() => _isLoading = true);

    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) throw Exception('Not logged in');

      // The detail screen shows a team_members row, but coaching_requests
      // references the separate coaches table — resolve by name.
      final coachRow = await SupabaseConfig.client
          .from('coaches')
          .select('id')
          .eq('name', coach.name)
          .maybeSingle();
      if (coachRow == null) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${coach.name} isn\'t accepting coaching requests yet.'),
              backgroundColor: AppColors.pinkDark,
            ),
          );
        }
        return;
      }

      await SupabaseConfig.client.from('coaching_requests').insert({
        'user_id': user.id,
        'coach_id': coachRow['id'],
        'message': message.trim().isEmpty ? null : message.trim(),
        'status': 'pending',
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Request sent to ${coach.name}! You\'ll be notified when they respond.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _hasActiveRequest = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coachAsync = ref.watch(teamMemberProvider(widget.coachId));

    return coachAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error loading team member: $error')),
      ),
      data: (coach) {
        if (coach == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Team member not found')),
          );
        }
        return _buildCoachDetail(context, coach);
      },
    );
  }

  Widget _buildCoachDetail(BuildContext context, Coach coach) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image with AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: coach.avatarUrl != null
                  ? CachedNetworkImage(
                      imageUrl: coach.avatarUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.accent.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          coach.name.split(' ').map((n) => n[0]).take(2).join(),
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          // Coach Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Title
                  Text(
                    coach.name,
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    coach.title ?? '',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Stats Row
                  Row(
                    children: [
                      _StatItem(
                        icon: Icons.star,
                        value: coach.rating?.toStringAsFixed(1) ?? 'N/A',
                        label: 'Rating',
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      _StatItem(
                        icon: Icons.fitness_center,
                        value: coach.experienceYears?.toString() ?? '5+',
                        label: 'Years Exp.',
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      if (coach.certifications.isNotEmpty)
                        _StatItem(
                          icon: Icons.verified,
                          value: coach.certifications.length.toString(),
                          label: 'Certs',
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Specialties
                  if (coach.specialties.isNotEmpty) ...[
                    Text(
                      'Specialties',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: coach.specialties.map((specialty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Text(
                            specialty,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Certifications
                  if (coach.certifications.isNotEmpty) ...[
                    Text(
                      'Certifications',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: coach.certifications.map((cert) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(
                            cert,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Bio
                  if (coach.bio != null && coach.bio!.isNotEmpty) ...[
                    Text(
                      'About',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      coach.bio!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // What you get section
                  _WhatYouGetSection(),

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _buildBottomButton(coach),
        ),
      ),
    );
  }

  Widget _buildBottomButton(Coach coach) {
    if (_isCurrentClient) {
      return AppButton(
        label: 'View My Training Plan',
        onPressed: () {
          // Navigate to training plan
        },
      );
    }

    if (_hasActiveRequest) {
      return AppButton(
        label: 'Request Pending',
        onPressed: null,
        variant: AppButtonVariant.secondary,
      );
    }

    if (!coach.acceptsNewClients) {
      return AppButton(
        label: 'Not Accepting New Clients',
        onPressed: null,
        variant: AppButtonVariant.secondary,
      );
    }

    return AppButton(
      label: 'Request Private Coaching',
      onPressed: () => _showRequestBottomSheet(coach),
      isLoading: _isLoading,
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
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _WhatYouGetSection extends StatelessWidget {
  final List<_BenefitItem> items = const [
    _BenefitItem(
      icon: Icons.calendar_month,
      title: 'Weekly Training Plans',
      description: 'Customized workouts scheduled for your week',
    ),
    _BenefitItem(
      icon: Icons.edit_note,
      title: 'Coach Notes',
      description: 'Personal guidance and tips for each workout',
    ),
    _BenefitItem(
      icon: Icons.sync,
      title: 'Progress Reviews',
      description: 'Regular check-ins and plan adjustments',
    ),
    _BenefitItem(
      icon: Icons.support_agent,
      title: 'Priority Support',
      description: 'Direct communication with your coach',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What You Get',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs / 2),
                        Text(
                          item.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _BenefitItem {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _RequestCoachingSheet extends StatefulWidget {
  final Coach coach;
  final Future<void> Function(String message) onSubmit;

  const _RequestCoachingSheet({
    required this.coach,
    required this.onSubmit,
  });

  @override
  State<_RequestCoachingSheet> createState() => _RequestCoachingSheetState();
}

class _RequestCoachingSheetState extends State<_RequestCoachingSheet> {
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await widget.onSubmit(_messageController.text);
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Request Coaching from ${widget.coach.name}',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tell ${widget.coach.name.split(' ').first} about your fitness goals and what you\'re looking for in private coaching.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Message Input
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Hi ${widget.coach.name.split(' ').first}, I\'m interested in private coaching because...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Send Request',
                onPressed: _submit,
                isLoading: _isSubmitting,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Note
            Text(
              'Your coach will review your request and respond within 24-48 hours.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
