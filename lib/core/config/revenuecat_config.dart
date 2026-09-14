import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat configuration and initialization.
///
/// Handles in-app subscription purchases (App Store / Play Store).
/// Stripe remains in use for the merch shop (physical goods only).
class RevenueCatConfig {
  RevenueCatConfig._();

  /// Entitlement identifier configured in the RevenueCat dashboard.
  static const String premiumEntitlement = 'premium';

  static String get _iosApiKey => dotenv.env['REVENUECAT_API_KEY_IOS'] ?? '';
  static String get _androidApiKey =>
      dotenv.env['REVENUECAT_API_KEY_ANDROID'] ?? '';

  static String get _apiKey {
    if (kIsWeb) return '';
    if (Platform.isIOS || Platform.isMacOS) return _iosApiKey;
    if (Platform.isAndroid) return _androidApiKey;
    return '';
  }

  /// True when a real (non-placeholder) API key is available for this platform.
  static bool get isConfigured {
    final key = _apiKey;
    return key.isNotEmpty && !key.startsWith('your-');
  }

  /// Initialize the RevenueCat SDK. Safe to call when unconfigured (no-op).
  static Future<void> initialize() async {
    if (!isConfigured) {
      debugPrint('Warning: RevenueCat API key is not set for this platform');
      return;
    }

    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  /// Identify the RevenueCat customer as the Supabase user, so webhook
  /// events carry the Supabase user id as app_user_id.
  static Future<void> logIn(String supabaseUserId) async {
    if (!isConfigured) return;
    try {
      final currentId = await Purchases.appUserID;
      if (currentId != supabaseUserId) {
        await Purchases.logIn(supabaseUserId);
      }
    } catch (e) {
      debugPrint('RevenueCat logIn failed: $e');
    }
  }

  /// Reset to an anonymous RevenueCat customer on sign-out.
  static Future<void> logOut() async {
    if (!isConfigured) return;
    try {
      final isAnonymous = await Purchases.isAnonymous;
      if (!isAnonymous) {
        await Purchases.logOut();
      }
    } catch (e) {
      debugPrint('RevenueCat logOut failed: $e');
    }
  }
}
