import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode, Color;
import 'package:flutter_stripe/flutter_stripe.dart';

import '../core/config/stripe_config.dart';
import '../core/config/supabase_config.dart';
import '../domain/entities/order.dart';
import '../domain/entities/product.dart';

/// Payment service for shop (physical goods) payments via Stripe.
/// Subscriptions are handled by RevenueCat — see providers/subscription_provider.dart.
class PaymentService {
  static final PaymentService _instance = PaymentService._();
  static PaymentService get instance => _instance;

  PaymentService._();

  late final Dio _dio;
  bool _initialized = false;

  /// Initialize the payment service
  void initialize() {
    if (_initialized) return;

    _dio = Dio(BaseOptions(
      baseUrl: StripeConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _initialized = true;
  }

  /// Get the current auth token
  Future<String?> _getAuthToken() async {
    return SupabaseConfig.currentSession?.accessToken;
  }

  /// Get authorization headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Create a PaymentIntent for shop checkout
  Future<PaymentIntentResult> createShopPaymentIntent({
    required List<CartItem> items,
    required ShippingAddress shippingAddress,
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await _dio.post(
        '/stripe/payment-intents',
        options: Options(headers: headers),
        data: {
          'items': items
              .map((item) => {
                    'productId': item.product.id,
                    'quantity': item.quantity,
                    'selectedSize': item.selectedSize,
                    'selectedColor': item.selectedColor,
                  })
              .toList(),
          'shippingAddress': shippingAddress.toJson(),
        },
      );

      return PaymentIntentResult(
        clientSecret: response.data['clientSecret'] as String,
        orderId: response.data['orderId'] as String,
        amount: response.data['amount'] as int,
      );
    } on DioException catch (e) {
      debugPrint('Error creating payment intent: ${e.response?.data}');
      throw Exception(
        e.response?.data['error'] ?? 'Failed to create payment intent',
      );
    }
  }

  /// Present the Stripe Payment Sheet
  Future<bool> presentPaymentSheet(String clientSecret) async {
    try {
      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'LA GYM',
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFFE91E63),
            ),
          ),
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'ES',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'ES',
            testEnv: true, // Set to false for production
          ),
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User cancelled the payment
        return false;
      }
      debugPrint('Stripe error: ${e.error.message}');
      throw Exception(e.error.message ?? 'Payment failed');
    }
  }

}

/// Result from creating a payment intent
class PaymentIntentResult {
  final String clientSecret;
  final String orderId;
  final int amount;

  const PaymentIntentResult({
    required this.clientSecret,
    required this.orderId,
    required this.amount,
  });

  double get amountInMajorUnits => amount / 100;
}


