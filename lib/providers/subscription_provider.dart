import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../core/config/revenuecat_config.dart';
import '../core/config/supabase_config.dart';

/// Subscription state derived from RevenueCat (store subscriptions).
///
/// When RevenueCat is not configured (e.g. local dev without API keys),
/// state falls back to the Supabase profile's subscription fields so
/// legacy signup trials keep working.
class SubscriptionState {
  final bool isPremium;
  final bool isTrialActive;
  final int trialDaysRemaining;
  final String? planName;
  final DateTime? expiresAt;
  final String? managementUrl;
  final bool isLoading;
  final bool isPurchasing;
  final String? error;

  const SubscriptionState({
    this.isPremium = false,
    this.isTrialActive = false,
    this.trialDaysRemaining = 0,
    this.planName,
    this.expiresAt,
    this.managementUrl,
    this.isLoading = false,
    this.isPurchasing = false,
    this.error,
  });

  SubscriptionState copyWith({
    bool? isPremium,
    bool? isTrialActive,
    int? trialDaysRemaining,
    String? planName,
    DateTime? expiresAt,
    String? managementUrl,
    bool? isLoading,
    bool? isPurchasing,
    String? error,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      trialDaysRemaining: trialDaysRemaining ?? this.trialDaysRemaining,
      planName: planName ?? this.planName,
      expiresAt: expiresAt ?? this.expiresAt,
      managementUrl: managementUrl ?? this.managementUrl,
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      error: error,
    );
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState(isLoading: true)) {
    _init();
  }

  void _init() {
    if (RevenueCatConfig.isConfigured) {
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
      refresh();
    } else {
      _loadFromProfile();
    }
  }

  @override
  void dispose() {
    if (RevenueCatConfig.isConfigured) {
      Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    }
    super.dispose();
  }

  /// Re-fetch the latest customer info from RevenueCat.
  Future<void> refresh() async {
    if (!RevenueCatConfig.isConfigured) {
      await _loadFromProfile();
      return;
    }
    try {
      final info = await Purchases.getCustomerInfo();
      _onCustomerInfoUpdated(info);
    } catch (e) {
      debugPrint('Failed to fetch customer info: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    final entitlement =
        info.entitlements.active[RevenueCatConfig.premiumEntitlement];

    if (entitlement == null) {
      state = const SubscriptionState();
      return;
    }

    final isTrial = entitlement.periodType == PeriodType.trial;
    final expiresAt = entitlement.expirationDate != null
        ? DateTime.tryParse(entitlement.expirationDate!)
        : null;

    state = SubscriptionState(
      isPremium: !isTrial,
      isTrialActive: isTrial,
      trialDaysRemaining: _daysUntil(expiresAt),
      planName: _planNameFromProduct(entitlement.productIdentifier),
      expiresAt: expiresAt,
      managementUrl: info.managementURL,
    );
  }

  /// Purchase a package from the current offering. Returns true on success.
  Future<bool> purchase(Package package) async {
    if (state.isPurchasing) return false;
    state = state.copyWith(isPurchasing: true, error: null);

    try {
      final info = await Purchases.purchasePackage(package);
      _onCustomerInfoUpdated(info);
      state = state.copyWith(isPurchasing: false);
      return true;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      state = state.copyWith(
        isPurchasing: false,
        error: code == PurchasesErrorCode.purchaseCancelledError
            ? null
            : e.message ?? 'Purchase failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(isPurchasing: false, error: 'Purchase failed');
      return false;
    }
  }

  /// Restore previous purchases (required by App Review). Returns true when
  /// an active premium entitlement was restored.
  Future<bool> restore() async {
    if (state.isPurchasing) return false;
    state = state.copyWith(isPurchasing: true, error: null);

    try {
      final info = await Purchases.restorePurchases();
      _onCustomerInfoUpdated(info);
      state = state.copyWith(isPurchasing: false);
      return info.entitlements.active
          .containsKey(RevenueCatConfig.premiumEntitlement);
    } on PlatformException catch (e) {
      state = state.copyWith(
        isPurchasing: false,
        error: e.message ?? 'Restore failed',
      );
      return false;
    }
  }

  /// Fallback when RevenueCat is not configured: derive state from the
  /// Supabase profile (covers legacy signup trials and dev environments).
  Future<void> _loadFromProfile() async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      state = const SubscriptionState();
      return;
    }

    try {
      final profile = await SupabaseConfig.client
          .from('profiles')
          .select('subscription_status, subscription_tier, trial_end_date, '
              'subscription_end_date')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        state = const SubscriptionState();
        return;
      }

      final status = profile['subscription_status'] as String?;
      final trialEnd = profile['trial_end_date'] != null
          ? DateTime.tryParse(profile['trial_end_date'] as String)
          : null;
      final isTrialActive = status == 'trial' &&
          trialEnd != null &&
          trialEnd.isAfter(DateTime.now());

      state = SubscriptionState(
        isPremium: status == 'active',
        isTrialActive: isTrialActive,
        trialDaysRemaining: isTrialActive ? _daysUntil(trialEnd) : 0,
        expiresAt: profile['subscription_end_date'] != null
            ? DateTime.tryParse(profile['subscription_end_date'] as String)
            : trialEnd,
      );
    } catch (e) {
      debugPrint('Failed to load subscription from profile: $e');
      state = const SubscriptionState();
    }
  }

  static int _daysUntil(DateTime? date) {
    if (date == null) return 0;
    final days = date.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  static String? _planNameFromProduct(String productId) {
    final id = productId.toLowerCase();
    if (id.contains('yearly') || id.contains('annual')) return 'Yearly';
    if (id.contains('monthly')) return 'Monthly';
    if (id.contains('lifetime')) return 'Lifetime';
    return null;
  }
}

/// The current offering (subscription packages) from RevenueCat, or null
/// when RevenueCat is not configured or has no offering.
final currentOfferingProvider = FutureProvider<Offering?>((ref) async {
  if (!RevenueCatConfig.isConfigured) return null;
  try {
    final offerings = await Purchases.getOfferings();
    return offerings.current;
  } catch (e) {
    debugPrint('Failed to fetch offerings: $e');
    return null;
  }
});
