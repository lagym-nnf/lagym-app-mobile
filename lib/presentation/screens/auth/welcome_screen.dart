import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/constants.dart';
import '../../router/app_router.dart';
import '../../widgets/common/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray900,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hero image
          Image.asset(
            'assets/images/splash-screen.png',
            fit: BoxFit.cover,
          ),
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.heroOverlayGradient,
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 220,
                  ),
                  const Spacer(),
                  // Signatures (above buttons, near the legs)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mija Lonjak',
                        style: GoogleFonts.dancingScript(
                          fontSize: 18,
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Lara Arači',
                          style: GoogleFonts.dancingScript(
                            fontSize: 18,
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Iva Opačak',
                        style: GoogleFonts.dancingScript(
                          fontSize: 18,
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  AppButton(
                    label: 'Get Started',
                    variant: AppButtonVariant.glow,
                    size: AppButtonSize.large,
                    onPressed: () => context.push(AppRoutes.signup),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.login),
                    child: Text(
                      'Already have an account? Log in',
                      style: AppTypography.buttonSmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

