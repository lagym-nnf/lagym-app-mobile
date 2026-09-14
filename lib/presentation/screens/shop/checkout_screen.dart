import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/product.dart';
import '../../../providers/payment_provider.dart';
import 'shop_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  String _selectedCountry = 'ES';

  final _countries = {
    'ES': 'Spain',
    'DE': 'Germany',
    'FR': 'France',
    'IT': 'Italy',
    'PT': 'Portugal',
    'NL': 'Netherlands',
    'BE': 'Belgium',
    'AT': 'Austria',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final checkoutState = ref.watch(checkoutProvider);

    // Listen for checkout success
    ref.listen(checkoutProvider, (previous, next) {
      if (next.isSuccess && next.orderId != null) {
        // Clear cart and navigate to success
        cartNotifier.clearCart();
        context.go('/orders/${next.orderId}');
      }
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.pinkLight,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIcons.shoppingBag(), size: 64, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: AppTypography.h3.copyWith(color: AppColors.gray500),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/shop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkDark,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Browse Shop',
                    style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                  Text('Checkout', style: AppTypography.greetingLarge),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Summary', style: AppTypography.cardTitle),
                            const SizedBox(height: 16),
                            ...cart.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Qty: ${item.quantity}',
                                          style: AppTypography.captionSmall.copyWith(color: AppColors.gray500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${item.total.toStringAsFixed(2)}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal', style: AppTypography.bodyMedium),
                                Text(
                                  '\$${cartNotifier.subtotal.toStringAsFixed(2)}',
                                  style: AppTypography.h3,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Shipping Address
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shipping Address', style: AppTypography.cardTitle),
                            const SizedBox(height: 16),

                            // Full Name
                            _buildTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              hint: 'John Doe',
                              validator: (v) => v?.isEmpty ?? true ? 'Name is required' : null,
                            ),

                            const SizedBox(height: 16),

                            // Address Line 1
                            _buildTextField(
                              controller: _line1Controller,
                              label: 'Address Line 1',
                              hint: 'Street address',
                              validator: (v) => v?.isEmpty ?? true ? 'Address is required' : null,
                            ),

                            const SizedBox(height: 16),

                            // Address Line 2
                            _buildTextField(
                              controller: _line2Controller,
                              label: 'Address Line 2 (Optional)',
                              hint: 'Apartment, suite, etc.',
                            ),

                            const SizedBox(height: 16),

                            // City and State
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cityController,
                                    label: 'City',
                                    hint: 'City',
                                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _stateController,
                                    label: 'State/Province',
                                    hint: 'State',
                                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Postal Code and Country
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _postalCodeController,
                                    label: 'Postal Code',
                                    hint: '12345',
                                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Country',
                                        style: AppTypography.captionSmall.copyWith(
                                          color: AppColors.gray600,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.gray50,
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                          border: Border.all(color: AppColors.gray200),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedCountry,
                                            isExpanded: true,
                                            items: _countries.entries
                                                .map((e) => DropdownMenuItem(
                                                      value: e.key,
                                                      child: Text(e.value),
                                                    ))
                                                .toList(),
                                            onChanged: (v) => setState(() => _selectedCountry = v!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Payment Info
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        ),
                        child: Row(
                          children: [
                            Icon(PhosphorIcons.shieldCheck(PhosphorIconsStyle.fill),
                                color: AppColors.mintDark, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Secure Payment',
                                    style: AppTypography.cardTitle.copyWith(color: AppColors.mintDark),
                                  ),
                                  Text(
                                    'Your payment is processed securely by Stripe',
                                    style: AppTypography.captionSmall.copyWith(color: AppColors.mintDark),
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
            ),

            // Pay Button
            Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: checkoutState.isLoading ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkDark,
                    disabledBackgroundColor: AppColors.gray300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: checkoutState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          ),
                        )
                      : Text(
                          'Pay \$${cartNotifier.subtotal.toStringAsFixed(2)}',
                          style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionSmall.copyWith(
            color: AppColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.gray400),
            filled: true,
            fillColor: AppColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.pinkDark, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = ref.read(cartProvider);
    final shippingAddress = ShippingAddress(
      name: _nameController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim().isEmpty ? null : _line2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _selectedCountry,
    );

    await ref.read(checkoutProvider.notifier).processCheckout(
      items: cart,
      shippingAddress: shippingAddress,
    );
  }
}
