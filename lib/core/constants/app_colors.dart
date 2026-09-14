import 'package:flutter/material.dart';

/// LA GYM App Color Palette
/// Based on the design system from LA_GYM_COLOR_PALETTE.md and styles.css
class AppColors {
  AppColors._();

  // Semantic colors (used throughout the app)
  static const Color primary = pinkDark;
  static const Color accent = coral;
  static const Color surface = white;
  static const Color background = gray50;
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textLight = gray400;
  static const Color border = gray200;
  static const Color divider = gray100;

  // Primary Colors
  static const Color pink = Color(0xFFFBCFE8);
  static const Color pinkLight = Color(0xFFFDF2F8);
  static const Color pinkDark = Color(0xFFEC4899);
  static const Color coral = Color(0xFFF472B6);

  // Original palette from design docs
  static const Color softCoral = Color(0xFFF5A692);
  static const Color deepRose = Color(0xFFD4726A);
  static const Color blushPink = Color(0xFFFCD5CE);
  static const Color creamWhite = Color(0xFFFFF8F5);

  // Secondary
  static const Color mint = Color(0xFFD1FAE5);
  static const Color mintDark = Color(0xFF34D399);
  static const Color gold = Color(0xFFFDE68A);
  static const Color goldDark = Color(0xFFF59E0B);
  static const Color purple = Color(0xFFE9D5FF);
  static const Color purpleDark = Color(0xFFA855F7);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Status Colors
  static const Color success = Color(0xFF7CB69D);
  static const Color warning = Color(0xFFE6B980);
  static const Color info = Color(0xFF8AACC8);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkLight, Color(0xFFFEE2E2)],
  );

  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pink, coral],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkDark, coral],
  );

  static const LinearGradient welcomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blushPink, creamWhite],
  );

  // Hero overlay gradient
  static LinearGradient heroOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black.withValues(alpha: 0.3),
      Colors.black.withValues(alpha: 0.1),
      Colors.black.withValues(alpha: 0.1),
      Colors.black.withValues(alpha: 0.6),
      Colors.black.withValues(alpha: 0.85),
    ],
    stops: const [0.0, 0.3, 0.5, 0.8, 1.0],
  );

  // Card overlay gradient
  static LinearGradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.black.withValues(alpha: 0.75),
    ],
  );
}
