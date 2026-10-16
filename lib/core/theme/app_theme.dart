import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

abstract final class AppTheme {
  static const String _englishFont = 'Inter';
  static const String _arabicFont = 'Tajawal';

  static String _fontFor(Locale locale) =>
      locale.languageCode == 'ar' ? _arabicFont : _englishFont;

  static ThemeData light(Locale locale) {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textInverse,
      primaryContainer: AppColors.primarySubtle,
      onPrimaryContainer: AppColors.primaryStrong,
      secondary: AppColors.donate,
      onSecondary: AppColors.onDonate,
      secondaryContainer: AppColors.donateSubtle,
      onSecondaryContainer: AppColors.onDonateSubtle,
      error: AppColors.danger,
      onError: AppColors.textInverse,
      errorContainer: AppColors.dangerSubtle,
      onErrorContainer: AppColors.onDangerSubtle,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
    );
    return _build(scheme, locale, AppColors.background);
  }

  static ThemeData dark(Locale locale) {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.textInverse,
      primaryContainer: AppColors.darkSurface,
      onPrimaryContainer: AppColors.darkTextPrimary,
      secondary: AppColors.donate,
      onSecondary: AppColors.onDonate,
      error: AppColors.danger,
      onError: AppColors.textInverse,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
    );
    return _build(scheme, locale, AppColors.darkBackground);
  }

  static ThemeData _build(
    ColorScheme scheme,
    Locale locale,
    Color background,
  ) {
    final font = _fontFor(locale);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: font,
      textTheme: AppTextTheme.build(
        fontFamily: font,
        primary: scheme.onSurface,
        secondary: scheme.onSurfaceVariant,
      ),
    );
  }
}