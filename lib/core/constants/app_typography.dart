import 'package:flutter/material.dart';
import 'app_colors.dart';

/// LA GYM App Typography
/// Font: Manrope (main), Dancing Script (accent)
class AppTypography {
  AppTypography._();

  static const String fontFamilyMain = 'Manrope';
  static const String fontFamilyScript = 'DancingScript';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.gray900,
    height: 1.3,
  );

  // Material-style naming aliases
  static const TextStyle headlineLarge = h1;
  static const TextStyle headlineMedium = h2;
  static const TextStyle headlineSmall = h3;

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.gray900,
    height: 1.1,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.gray900,
    height: 1.2,
  );
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
    height: 1.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
    height: 1.3,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
    height: 1.3,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.gray900,
    height: 1.3,
  );

  static const TextStyle labelLarge = buttonMedium;
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.gray600,
    height: 1.3,
  );
  static const TextStyle labelSmall = label;

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.gray900,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray900,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.gray600,
    height: 1.4,
  );

  // Captions
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray400,
    height: 1.4,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.gray400,
    height: 1.4,
  );

  // Labels
  static const TextStyle label = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.gray400,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle labelUppercase = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.gray400,
    letterSpacing: 0.5,
    height: 1.3,
  );

  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.25,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.25,
  );

  // Special styles
  static const TextStyle logo = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: AppColors.gray900,
    letterSpacing: -1,
  );

  static const TextStyle logoNeon = TextStyle(
    fontFamily: fontFamilyScript,
    fontSize: 64,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 2,
  );

  static const TextStyle signature = TextStyle(
    fontFamily: fontFamilyScript,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.gray600,
    letterSpacing: 0.5,
  );

  // Card titles
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.gray900,
    height: 1.3,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.gray400,
    height: 1.3,
  );

  // Section titles
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.gray900,
    height: 1.3,
  );

  // Navigation
  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Greeting
  static const TextStyle greetingSmall = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.gray400,
  );

  static const TextStyle greetingLarge = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.gray900,
  );

  // Stats
  static const TextStyle statValue = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.pinkDark,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.gray400,
  );

  // Timer
  static const TextStyle timer = TextStyle(
    fontFamily: fontFamilyMain,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.pinkDark,
  );
}
