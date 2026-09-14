import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/service_provider.dart';
import '../../../providers/service_providers_provider.dart';
import '../../widgets/common/app_button.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String providerId;

  const ServiceDetailScreen({
    super.key,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(serviceProviderProvider(providerId));

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: providerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageView(
          icon: PhosphorIcons.wifiSlash(),
          message: 'Could not load provider.',
          onBack: () => context.pop(),
        ),
        data: (provider) {
          if (provider == null) {
            return _MessageView(
              icon: PhosphorIcons.user(),
              message: 'Provider not found.',
              onBack: () => context.pop(),
            );
          }
          return _ProviderDetailContent(provider: provider);
        },
      ),
    );
  }
}

class _ProviderDetailContent extends StatelessWidget {
  final ServiceProvider provider;

  const _ProviderDetailContent({required this.provider});

  String get _typeLabel {
    switch (provider.type) {
      case ServiceProviderType.nutritionist:
        return 'NUTRITIONIST';
      case ServiceProviderType.physiotherapist:
        return 'PHYSIOTHERAPIST';
      case ServiceProviderType.coach:
        return 'COACH';
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero header
        SliverAppBar(
          expandedHeight: 300,
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
                if (provider.imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: provider.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.gray200,
                      child: Icon(PhosphorIcons.user(), size: 64, color: AppColors.gray400),
                    ),
                  )
                else
                  Container(
                    color: AppColors.gray200,
                    child: Icon(PhosphorIcons.user(), size: 64, color: AppColors.gray400),
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
                  bottom: 20,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: provider.type == ServiceProviderType.nutritionist
                              ? AppColors.mint
                              : AppColors.coral,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          _typeLabel,
                          style: AppTypography.captionSmall.copyWith(
                            color: provider.type == ServiceProviderType.nutritionist
                                ? AppColors.mintDark
                                : AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        provider.name,
                        style: AppTypography.h1.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (provider.title != null)
                        Text(
                          provider.title!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
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
                      if (provider.yearsExperience > 0)
                        _StatItem(
                          icon: PhosphorIcons.briefcase(),
                          value: '${provider.yearsExperience}',
                          label: 'Years exp.',
                        ),
                      _StatItem(
                        icon: PhosphorIcons.sparkle(),
                        value: '${provider.specializations.length}',
                        label: 'Specialties',
                      ),
                      _StatItem(
                        icon: PhosphorIcons.certificate(),
                        value: '${provider.qualifications.length}',
                        label: 'Certifications',
                      ),
                    ],
                  ),
                ),

                // About
                if (provider.bio != null && provider.bio!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('About', style: AppTypography.sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    provider.bio!,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
                  ),
                ],

                // Specializations
                if (provider.specializations.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Specializations', style: AppTypography.sectionTitle),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.specializations.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(s, style: AppTypography.bodySmall),
                    )).toList(),
                  ),
                ],

                // Qualifications
                if (provider.qualifications.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Qualifications', style: AppTypography.sectionTitle),
                  const SizedBox(height: 12),
                  ...provider.qualifications.map((q) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(PhosphorIcons.sealCheck(PhosphorIconsStyle.fill),
                            size: 20, color: AppColors.mintDark),
                        const SizedBox(width: 10),
                        Expanded(child: Text(q, style: AppTypography.bodyMedium)),
                      ],
                    ),
                  )),
                ],

                // Contact / booking
                const SizedBox(height: 24),
                Text('Book a Session', style: AppTypography.sectionTitle),
                const SizedBox(height: 8),
                Text(
                  'Get in touch to schedule your session with ${provider.name.split(' ').first}.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
                ),
                const SizedBox(height: 16),

                if (provider.email == null && provider.phone == null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Center(
                      child: Text(
                        'Ask at the gym front desk to book a session.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                      ),
                    ),
                  )
                else ...[
                  if (provider.email != null)
                    AppButton(
                      label: 'Email ${provider.name.split(' ').first}',
                      size: AppButtonSize.large,
                      variant: AppButtonVariant.glow,
                      onPressed: () => _openUrl(
                        'mailto:${provider.email}?subject=Session booking request',
                      ),
                    ),
                  if (provider.email != null && provider.phone != null)
                    const SizedBox(height: 12),
                  if (provider.phone != null)
                    AppButton(
                      label: 'Call ${provider.phone}',
                      size: AppButtonSize.large,
                      onPressed: () => _openUrl('tel:${provider.phone}'),
                    ),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
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
