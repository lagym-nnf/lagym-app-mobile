import 'package:flutter/material.dart';

/// LA GYM App Shadow Styles
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get sm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get md => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get lg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get button => [
        BoxShadow(
          color: const Color(0xFFEC4899).withValues(alpha: 0.4),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFFEC4899).withValues(alpha: 0.3),
          blurRadius: 30,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get bottomNav => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];

  // Neon text shadow for logo
  static List<Shadow> get neonText => [
        const Shadow(
          color: Colors.white,
          blurRadius: 5,
        ),
        const Shadow(
          color: Colors.white,
          blurRadius: 10,
        ),
        const Shadow(
          color: Color(0xFFFF6B9D),
          blurRadius: 20,
        ),
        const Shadow(
          color: Color(0xFFFF6B9D),
          blurRadius: 40,
        ),
        const Shadow(
          color: Color(0xFFFF6B9D),
          blurRadius: 60,
        ),
      ];
}
