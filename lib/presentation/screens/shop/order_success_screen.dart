import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';

class OrderSuccessScreen extends ConsumerWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  size: 60,
                  color: AppColors.mintDark,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Order Confirmed!',
                style: AppTypography.h1,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Thank you for your purchase',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.gray500),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Order ID
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(PhosphorIcons.receipt(), color: AppColors.gray500, size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID',
                          style: AppTypography.captionSmall.copyWith(color: AppColors.gray500),
                        ),
                        Text(
                          orderId.substring(0, 8).toUpperCase(),
                          style: AppTypography.cardTitle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'You will receive an email confirmation shortly.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Continue Shopping button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/shop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: AppTypography.buttonMedium.copyWith(color: AppColors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Go Home button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.gray300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Go to Home',
                    style: AppTypography.buttonMedium.copyWith(color: AppColors.gray700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
