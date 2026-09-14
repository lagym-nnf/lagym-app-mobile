import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/constants/constants.dart';
import '../../../providers/subscriptions_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../services/auth_service.dart';
import '../../router/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final subscription = ref.watch(userSubscriptionProvider).valueOrNull;

    final fullName = (profile?['full_name'] as String?)?.trim();
    final avatarUrl = profile?['avatar_url'] as String?;
    final planName =
        (subscription?['subscription_plans'] as Map<String, dynamic>?)?['name']
            as String?;

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.bottomNavHeight + 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Profile header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.white, width: 3), boxShadow: AppShadows.md),
                      child: ClipOval(
                        child: avatarUrl != null
                            ? CachedNetworkImage(
                                imageUrl: avatarUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    _InitialsAvatar(name: fullName),
                              )
                            : _InitialsAvatar(name: fullName),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(fullName ?? 'LA GYM Member', style: AppTypography.h2),
                    const SizedBox(height: 4),
                    Text(planName ?? 'Member', style: AppTypography.captionSmall),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Settings groups
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _SettingsGroup(items: [
                      _SettingsItem(icon: PhosphorIcons.chartBar(), label: 'My Progress', color: AppColors.pinkDark, bgColor: AppColors.pink, onTap: () => context.push(AppRoutes.progress)),
                      _SettingsItem(icon: PhosphorIcons.trophy(), label: 'Rewards & Badges', color: AppColors.goldDark, bgColor: AppColors.gold, onTap: () => context.push(AppRoutes.badges)),
                      _SettingsItem(icon: PhosphorIcons.crown(), label: 'Subscription', color: AppColors.purpleDark, bgColor: AppColors.purple, onTap: () => context.push(AppRoutes.subscription)),
                      _SettingsItem(icon: PhosphorIcons.shoppingBag(), label: 'Shop', color: AppColors.coral, bgColor: AppColors.pink, onTap: () => context.push(AppRoutes.shop)),
                      _SettingsItem(icon: PhosphorIcons.heart(), label: 'Health Apps', color: AppColors.mintDark, bgColor: AppColors.mint, onTap: () => context.push(AppRoutes.healthSettings)),
                    ],),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () async {
                        await ref.read(authServiceProvider).signOut();
                        if (context.mounted) context.go(AppRoutes.welcome);
                      },
                      child: Text('Log Out', style: AppTypography.buttonMedium.copyWith(color: AppColors.pinkDark)),
                    ),
                    TextButton(
                      onPressed: () => _confirmDeleteAccount(context, ref),
                      child: Text(
                        'Delete Account',
                        style: AppTypography.buttonMedium
                            .copyWith(color: AppColors.gray500),
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

  Future<void> _confirmDeleteAccount(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        title: const Text('Delete account?'),
        content: const Text(
          'This permanently deletes your account, your subscription record, '
          'program progress and all personal data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await SupabaseConfig.client.rpc('delete_user');
      await ref.read(authServiceProvider).signOut();
      if (context.mounted) context.go(AppRoutes.welcome);
    } catch (e) {
      debugPrint('Account deletion failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Could not delete your account. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String? name;
  const _InitialsAvatar({this.name});
  @override
  Widget build(BuildContext context) {
    final initials = (name == null || name!.isEmpty)
        ? '?'
        : name!
            .split(RegExp(r'\s+'))
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join();
    return Container(
      color: AppColors.pink,
      alignment: Alignment.center,
      child: Text(initials, style: AppTypography.h2.copyWith(color: AppColors.pinkDark)),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppSpacing.radiusXl), boxShadow: AppShadows.sm),
      child: Column(children: items),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, bgColor;
  final VoidCallback onTap;
  const _SettingsItem({required this.icon, required this.label, required this.color, required this.bgColor, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)), child: Icon(icon, color: color, size: 18)),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.cardTitle)),
            Icon(PhosphorIcons.caretRight(), color: AppColors.gray400, size: 16),
          ],
        ),
      ),
    );
  }
}
