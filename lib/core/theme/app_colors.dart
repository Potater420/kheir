import 'package:flutter/material.dart';

/// Color tokens from the Figma foundations page.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryStrong = Color(0xFF095A54);
  static const Color primarySubtle = Color(0xFFE8F3EF);
  // Text on a brand-colored background (splash screen), softer than white.
  static const Color onBrandMuted = Color(0xFFE0F1E9);

  // Donate (amber). Never put white text on it, use onDonate.
  static const Color donate = Color(0xFFF59E0B);
  static const Color onDonate = Color(0xFF422B08);
  static const Color donateSubtle = Color(0xFFFFF3D8);
  static const Color onDonateSubtle = Color(0xFF713F12);

  // Status
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerSubtle = Color(0xFFFEF2F2);
  static const Color onDangerSubtle = Color(0xFFB91C1C);
  static const Color success = Color(0xFF16A34A);
  static const Color successSubtle = Color(0xFFEAF8EE);
  static const Color onSuccessSubtle = Color(0xFF166534);

  // Light mode
  static const Color background = Color(0xFFFAFAF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDEE7E3);
  static const Color textPrimary = Color(0xFF17332F);
  static const Color textSecondary = Color(0xFF62736F);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Dark mode
  static const Color darkBackground = Color(0xFF0D2422);
  static const Color darkSurface = Color(0xFF183532);
  static const Color darkTextPrimary = Color(0xFFEDF7F3);
  static const Color darkTextSecondary = Color(0xFFB4CCC4);
  // Not read from Figma yet: verify against the dark screens later.
  static const Color darkBorder = Color(0xFF2A4A46);
}