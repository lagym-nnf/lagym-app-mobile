import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../services/health_service.dart';
import '../../widgets/common/app_button.dart';

class HealthSettingsScreen extends ConsumerWidget {
  const HealthSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthDataProvider);
    final healthNotifier = ref.read(healthDataProvider.notifier);

    final healthAppName = Platform.isIOS ? 'Apple Health' : 'Google Fit';
    final healthAppIcon = Platform.isIOS ? PhosphorIcons.appleLogo() : PhosphorIcons.googleLogo();

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                  Text('Health Integration', style: AppTypography.greetingLarge),
                ],
              ),

              const SizedBox(height: 32),

              // Connection card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  boxShadow: AppShadows.sm,
                ),
                child: Column(
                  children: [
                    // Health app icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: healthData.isConnected
                            ? AppColors.mint
                            : AppColors.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        healthAppIcon,
                        size: 40,
                        color: healthData.isConnected
                            ? AppColors.mintDark
                            : AppColors.gray400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(healthAppName, style: AppTypography.h2),
                    const SizedBox(height: 8),

                    // Connection status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: healthData.isConnected
                            ? AppColors.mintDark.withValues(alpha: 0.1)
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            healthData.isConnected
                                ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                                : PhosphorIcons.xCircle(),
                            size: 16,
                            color: healthData.isConnected
                                ? AppColors.mintDark
                                : AppColors.gray500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            healthData.isConnected ? 'Connected' : 'Not Connected',
                            style: AppTypography.bodySmall.copyWith(
                              color: healthData.isConnected
                                  ? AppColors.mintDark
                                  : AppColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      healthData.isConnected
                          ? 'Your health data is syncing with LA GYM. Steps, weight, and workouts are automatically tracked.'
                          : 'Connect to $healthAppName to sync your health data, including steps, weight, and workouts.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Connect/Disconnect button
                    AppButton(
                      label: healthData.isConnected ? 'Disconnect' : 'Connect',
                      variant: healthData.isConnected
                          ? AppButtonVariant.outline
                          : AppButtonVariant.glow,
                      onPressed: () async {
                        if (healthData.isConnected) {
                          healthNotifier.disconnect();
                        } else {
                          final connected = await healthNotifier.connect();
                          if (!connected && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not connect to $healthAppName. Please check permissions.'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),

              if (healthData.isConnected) ...[
                const SizedBox(height: 24),

                // Today's data
                Text('Today\'s Data', style: AppTypography.sectionTitle),
                const SizedBox(height: 14),

                _HealthDataCard(
                  icon: PhosphorIcons.footprints(),
                  label: 'Steps',
                  value: healthData.steps?.toString() ?? '--',
                  color: AppColors.coral,
                ),
                const SizedBox(height: 12),

                _HealthDataCard(
                  icon: PhosphorIcons.scales(),
                  label: 'Weight',
                  value: healthData.weight != null
                      ? '${healthData.weight!.toStringAsFixed(1)} kg'
                      : '--',
                  color: AppColors.pinkDark,
                ),
                const SizedBox(height: 12),

                _HealthDataCard(
                  icon: PhosphorIcons.flame(),
                  label: 'Active Calories',
                  value: healthData.activeCalories != null
                      ? '${healthData.activeCalories!.toInt()} cal'
                      : '--',
                  color: AppColors.goldDark,
                ),
                const SizedBox(height: 12),

                _HealthDataCard(
                  icon: PhosphorIcons.timer(),
                  label: 'Workout Minutes',
                  value: healthData.workoutMinutes != null
                      ? '${healthData.workoutMinutes} min'
                      : '--',
                  color: AppColors.mintDark,
                ),

                const SizedBox(height: 16),

                // Last synced
                if (healthData.lastSynced != null)
                  Center(
                    child: Text(
                      'Last synced: ${_formatTime(healthData.lastSynced!)}',
                      style: AppTypography.captionSmall.copyWith(color: AppColors.gray400),
                    ),
                  ),

                const SizedBox(height: 16),

                // Refresh button
                Center(
                  child: TextButton.icon(
                    onPressed: () => healthNotifier.refresh(),
                    icon: Icon(PhosphorIcons.arrowsClockwise(), size: 18),
                    label: const Text('Refresh'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.pinkDark,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Info section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.pink.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Row(
                  children: [
                    Icon(PhosphorIcons.info(), color: AppColors.pinkDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your health data stays on your device and is only used to enhance your LA GYM experience.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.gray700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }
}

class _HealthDataCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _HealthDataCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.cardSubtitle),
                Text(value, style: AppTypography.cardTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
