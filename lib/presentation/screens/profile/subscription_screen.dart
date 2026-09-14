import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../providers/subscription_provider.dart';

const String kTermsOfUseUrl = AppUrls.termsOfUse;
const String kPrivacyPolicyUrl = AppUrls.privacyPolicy;

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  String? _selectedPackageId;

  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(subscriptionProvider);
    final offeringAsync = ref.watch(currentOfferingProvider);

    // Surface purchase/restore errors
    ref.listen(subscriptionProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                    const Spacer(),
                    // Manage subscription button (if subscribed)
                    if (subscription.isPremium || subscription.isTrialActive)
                      GestureDetector(
                        onTap: () => _openManageSubscription(subscription.managementUrl),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            boxShadow: AppShadows.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(PhosphorIcons.gear(), size: 16, color: AppColors.gray700),
                              const SizedBox(width: 6),
                              Text(
                                'Manage',
                                style: AppTypography.buttonSmall.copyWith(color: AppColors.gray700),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Crown icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.goldDark, AppColors.gold],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(PhosphorIcons.crown(PhosphorIconsStyle.fill), color: AppColors.white, size: 40),
                    ),
                    const SizedBox(height: 20),

                    Text('Unlock Full Access', style: AppTypography.h1, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      'Get unlimited workouts, recipes, and coaching',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
                      textAlign: TextAlign.center,
                    ),

                    // Trial banner
                    if (subscription.isTrialActive) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: Row(
                          children: [
                            Icon(PhosphorIcons.clock(), color: AppColors.mintDark),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Free Trial Active',
                                    style: AppTypography.cardTitle.copyWith(color: AppColors.mintDark),
                                  ),
                                  Text(
                                    '${subscription.trialDaysRemaining} days remaining',
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.mintDark),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Premium active banner
                    if (subscription.isPremium) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.goldDark, AppColors.gold],
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: Row(
                          children: [
                            Icon(PhosphorIcons.crown(PhosphorIconsStyle.fill), color: AppColors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Premium Active',
                                    style: AppTypography.cardTitle.copyWith(color: AppColors.white),
                                  ),
                                  Text(
                                    '${subscription.planName ?? 'Plan'} - Renews ${_formatDate(subscription.expiresAt)}',
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Features
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Premium includes:', style: AppTypography.cardTitle),
                          const SizedBox(height: 16),
                          ...[
                            ('Unlimited workout programs', PhosphorIcons.barbell()),
                            ('Full recipe library', PhosphorIcons.cookingPot()),
                            ('1-on-1 coaching access', PhosphorIcons.users()),
                            ('Advanced progress tracking', PhosphorIcons.chartLine()),
                            ('Daily challenges & rewards', PhosphorIcons.trophy()),
                            ('AI fitness assistant', PhosphorIcons.robot()),
                          ].map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.mint,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(item.$2, color: AppColors.mintDark, size: 16),
                              ),
                              const SizedBox(width: 14),
                              Text(item.$1, style: AppTypography.bodyMedium),
                            ]),
                          )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Plans from the store (RevenueCat offering)
                    offeringAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => _buildUnavailablePlans(),
                      data: (offering) {
                        final packages = _subscriptionPackages(offering);
                        if (packages.isEmpty) return _buildUnavailablePlans();

                        // Default selection: yearly (best value), else first
                        _selectedPackageId ??= packages
                            .firstWhere(
                              (p) => p.packageType == PackageType.annual,
                              orElse: () => packages.first,
                            )
                            .identifier;

                        final selectedPackage = packages.firstWhere(
                          (p) => p.identifier == _selectedPackageId,
                          orElse: () => packages.first,
                        );

                        return Column(
                          children: [
                            Row(
                              children: packages.take(2).map((package) {
                                final isSelected = _selectedPackageId == package.identifier;
                                final isAnnual = package.packageType == PackageType.annual;
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: package == packages.first ? 6 : 0,
                                      left: package == packages.first ? 0 : 6,
                                    ),
                                    child: _PlanCard(
                                      title: isAnnual ? 'Yearly' : 'Monthly',
                                      price: package.storeProduct.priceString,
                                      note: isAnnual ? '/year' : '/month',
                                      savings: isAnnual ? 'Save 40%' : null,
                                      isSelected: isSelected,
                                      isPopular: isAnnual,
                                      onTap: () => setState(() => _selectedPackageId = package.identifier),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (!subscription.isPremium && !subscription.isTrialActive) ...[
                              const SizedBox(height: 24),

                              // Subscribe button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: subscription.isPurchasing
                                      ? null
                                      : () => _purchase(selectedPackage),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.pinkDark,
                                    disabledBackgroundColor: AppColors.gray300,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                    ),
                                  ),
                                  child: subscription.isPurchasing
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                                          ),
                                        )
                                      : Text(
                                          'Start 3-Day Free Trial',
                                          style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _trialDisclosure(selectedPackage),
                                style: AppTypography.captionSmall.copyWith(color: AppColors.gray400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        );
                      },
                    ),

                    // Restore purchases (required by App Review)
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: subscription.isPurchasing ? null : _restorePurchases,
                      child: Text(
                        'Restore Purchases',
                        style: AppTypography.buttonSmall.copyWith(color: AppColors.gray500),
                      ),
                    ),

                    // Legal links (required on the paywall by App Review)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _openUrl(kTermsOfUseUrl),
                          child: Text(
                            'Terms of Use',
                            style: AppTypography.captionSmall.copyWith(
                              color: AppColors.gray500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          '  ·  ',
                          style: AppTypography.captionSmall.copyWith(color: AppColors.gray400),
                        ),
                        GestureDetector(
                          onTap: () => _openUrl(kPrivacyPolicyUrl),
                          child: Text(
                            'Privacy Policy',
                            style: AppTypography.captionSmall.copyWith(
                              color: AppColors.gray500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Payment methods info
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(PhosphorIcons.appleLogo(), size: 20, color: AppColors.gray500),
                          const SizedBox(width: 8),
                          Icon(PhosphorIcons.googleLogo(), size: 20, color: AppColors.gray500),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Billed securely via the App Store / Google Play',
                              style: AppTypography.captionSmall.copyWith(color: AppColors.gray500),
                              textAlign: TextAlign.center,
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
        ),
      ),
    );
  }

  /// Monthly + annual packages from the current offering, monthly first to
  /// match the card layout.
  List<Package> _subscriptionPackages(Offering? offering) {
    if (offering == null) return const [];
    final packages = offering.availablePackages
        .where((p) =>
            p.packageType == PackageType.monthly ||
            p.packageType == PackageType.annual)
        .toList();
    packages.sort((a, b) =>
        (a.packageType == PackageType.monthly ? 0 : 1) -
        (b.packageType == PackageType.monthly ? 0 : 1));
    return packages;
  }

  Widget _buildUnavailablePlans() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          Icon(PhosphorIcons.storefront(), color: AppColors.gray400, size: 32),
          const SizedBox(height: 12),
          Text(
            'Subscriptions are currently unavailable',
            style: AppTypography.cardTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again later.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _trialDisclosure(Package package) {
    final price = package.storeProduct.priceString;
    final period =
        package.packageType == PackageType.annual ? 'year' : 'month';
    return '3 days free, then $price/$period. Cancel anytime in your '
        'store account settings before the trial ends.';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _purchase(Package package) async {
    final success =
        await ref.read(subscriptionProvider.notifier).purchase(package);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome to Premium!')),
      );
    }
  }

  Future<void> _restorePurchases() async {
    final restored =
        await ref.read(subscriptionProvider.notifier).restore();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(restored
              ? 'Purchases restored'
              : 'No previous purchases found'),
        ),
      );
    }
  }

  Future<void> _openManageSubscription(String? managementUrl) async {
    if (managementUrl != null) {
      await _openUrl(managementUrl);
    } else {
      // Subscription not managed by this store account (e.g. web/Stripe
      // subscription, or subscribed on another platform).
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Manage your subscription from the account it was purchased with.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _PlanCard extends StatelessWidget {
  final String title, price, note;
  final String? savings;
  final bool isSelected, isPopular;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.note,
    this.savings,
    required this.isSelected,
    this.isPopular = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(
            color: isSelected ? AppColors.pinkDark : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.md : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isPopular)
              Positioned(
                top: -30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.pinkDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      'Best Value',
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                // Radio indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.pinkDark : AppColors.gray300,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.pinkDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTypography.captionSmall.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  note,
                  style: AppTypography.captionSmall.copyWith(color: AppColors.gray400),
                ),
                if (savings != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      savings!,
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.mintDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Paywall widget that can wrap premium content
class PaywallGate extends ConsumerWidget {
  final Widget child;
  final String? featureName;

  const PaywallGate({
    super.key,
    required this.child,
    this.featureName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);

    if (subscription.isPremium || subscription.isTrialActive) {
      return child;
    }

    return GestureDetector(
      onTap: () => context.push('/profile/subscription'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.gold),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.lock(), color: AppColors.goldDark, size: 32),
            const SizedBox(height: 12),
            Text(
              featureName != null ? 'Unlock $featureName' : 'Premium Feature',
              style: AppTypography.cardTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start your free trial to access this feature',
              style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.pinkDark, AppColors.coral],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                'Try Free',
                style: AppTypography.buttonSmall.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
