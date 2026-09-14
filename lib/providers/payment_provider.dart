import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/order.dart';
import '../domain/entities/product.dart';
import '../services/payment_service.dart';

/// Checkout state
class CheckoutState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final String? orderId;

  const CheckoutState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.orderId,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    String? orderId,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      orderId: orderId ?? this.orderId,
    );
  }
}

/// Checkout notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier() : super(const CheckoutState());

  final _paymentService = PaymentService.instance;

  /// Process checkout with cart items and shipping address
  Future<bool> processCheckout({
    required List<CartItem> items,
    required ShippingAddress shippingAddress,
  }) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      // Create payment intent
      final result = await _paymentService.createShopPaymentIntent(
        items: items,
        shippingAddress: shippingAddress,
      );

      // Present payment sheet
      final success = await _paymentService.presentPaymentSheet(
        result.clientSecret,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          orderId: result.orderId,
        );
        return true;
      } else {
        // User cancelled
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Reset checkout state
  void reset() {
    state = const CheckoutState();
  }
}

/// Checkout provider
final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier();
});
