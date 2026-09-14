import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/service_provider.dart';
import '../../../providers/service_providers_provider.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  final ServiceProviderType? initialType;

  const ServicesScreen({
    super.key,
    this.initialType,
  });

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialType == ServiceProviderType.physiotherapist ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
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
                  Text('Expert Services', style: AppTypography.greetingLarge),
                ],
              ),
            ),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.gray900,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.gray600,
                labelStyle: AppTypography.buttonSmall,
                tabs: const [
                  Tab(text: 'Nutritionists'),
                  Tab(text: 'Physiotherapists'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _ProviderList(
                    role: 'nutritionist',
                    emptyMessage: 'No nutritionists available yet',
                  ),
                  _ProviderList(
                    role: 'physiotherapist',
                    emptyMessage: 'No physiotherapists available yet',
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

class _ProviderList extends ConsumerWidget {
  final String role;
  final String emptyMessage;

  const _ProviderList({
    required this.role,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async =>
          ref.invalidate(serviceProvidersByRoleProvider(role)),
      child: ref.watch(serviceProvidersByRoleProvider(role)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ListView(
              children: [
                const SizedBox(height: 80),
                Icon(PhosphorIcons.wifiSlash(),
                    size: 48, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'Could not load providers.\nPull down to try again.',
                  textAlign: TextAlign.center,
                  style:
                      AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                ),
              ],
            ),
            data: (providers) {
              if (providers.isEmpty) {
                return ListView(
                  children: [
                    const SizedBox(height: 80),
                    Icon(PhosphorIcons.users(),
                        size: 48, color: AppColors.gray300),
                    const SizedBox(height: 16),
                    Text(
                      emptyMessage,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.gray500),
                    ),
                  ],
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                itemCount: providers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return _ProviderCard(
                    provider: provider,
                    onTap: () => context.push('/services/${provider.id}'),
                  );
                },
              );
            },
          ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final ServiceProvider provider;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: CachedNetworkImage(
                imageUrl: provider.imageUrl ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.gray100),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.gray100,
                  child: Icon(PhosphorIcons.user(), color: AppColors.gray400),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider.name, style: AppTypography.cardTitle),
                  const SizedBox(height: 2),
                  Text(
                    provider.title ?? '',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
                  ),
                  const SizedBox(height: 8),
                  // Experience and rating (when reviews exist)
                  Row(
                    children: [
                      if (provider.reviewCount > 0) ...[
                        Icon(PhosphorIcons.star(PhosphorIconsStyle.fill), size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.rating}',
                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' (${provider.reviewCount})',
                          style: AppTypography.captionSmall.copyWith(color: AppColors.gray400),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (provider.yearsExperience > 0) ...[
                        Icon(PhosphorIcons.briefcase(), size: 14, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.yearsExperience} yrs experience',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // First specialty
                  Row(
                    children: [
                      if (provider.specializations.isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.pinkDark.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              provider.specializations.first,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.pinkDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(),
                      Icon(PhosphorIcons.arrowRight(), size: 20, color: AppColors.gray400),
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
