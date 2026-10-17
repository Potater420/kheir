import 'package:flutter/material.dart';

/// Type scale from Figma: 32 display / 24 page / 20 section / 16 body /
/// 13 metadata / 11 tabs. Line height 145%, no letter spacing for Arabic.
abstract final class AppTextTheme {
  static TextTheme build({
    required String fontFamily,
    required Color primary,
    required Color secondary,
  }) {
    TextStyle style(
      double size,
      FontWeight weight, {
      Color? color,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: 1.45,
        color: color ?? primary,
      );
    }

    return TextTheme(
      displaySmall: style(32, FontWeight.w700),
      headlineSmall: style(24, FontWeight.w700),
      titleLarge: style(20, FontWeight.w700),
      titleMedium: style(16, FontWeight.w700),
      bodyLarge: style(16, FontWeight.w400),
      bodyMedium: style(15, FontWeight.w400),
      bodySmall: style(13, FontWeight.w400, color: secondary),
      labelLarge: style(16, FontWeight.w700),
      labelMedium: style(13, FontWeight.w700),
      labelSmall: style(11, FontWeight.w500, color: secondary),
    );
  }
}