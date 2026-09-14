import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// Stripe configuration and initialization
class StripeConfig {
  StripeConfig._();

  static String get publishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// Initialize Stripe with publishable key
  static Future<void> initialize() async {
    if (publishableKey.isEmpty) {
      debugPrint('Warning: STRIPE_PUBLISHABLE_KEY is not set');
      return;
    }

    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.lagym.app';

    // Enable Apple Pay and Google Pay
    Stripe.instance.applySettings();
  }

  /// Check if Stripe is properly configured
  static bool get isConfigured => publishableKey.isNotEmpty;
}
