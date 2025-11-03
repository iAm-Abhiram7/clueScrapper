import 'package:flutter/material.dart';

/// Japanese-inspired color palette for ClueScraper
/// Inspired by Zen gardens, Japanese architecture, and Washi paper aesthetics
class AppColors extends ThemeExtension<AppColors> {
  // Primary Colors
  final Color graphite;
  final Color warmOffWhite;
  final Color indigoInk;

  // Support Colors
  final Color lightSage;
  final Color mutedSand;

  // Typography
  final Color darkCharcoal;

  // Semantic Colors
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Surface Colors
  final Color surface;
  final Color surfaceVariant;
  final Color background;

  const AppColors({
    required this.graphite,
    required this.warmOffWhite,
    required this.indigoInk,
    required this.lightSage,
    required this.mutedSand,
    required this.darkCharcoal,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.surface,
    required this.surfaceVariant,
    required this.background,
  });

  // Light theme colors
  factory AppColors.light() {
    return const AppColors(
      graphite: Color(0xFF2F2F2F),
      warmOffWhite: Color(0xFFF5F3EF),
      indigoInk: Color(0xFF3E5C76),
      lightSage: Color(0xFFB5C99A),
      mutedSand: Color(0xFFE0D8C3),
      darkCharcoal: Color(0xFF1B1B1B),
      success: Color(0xFF87A878),
      warning: Color(0xFFD4A574),
      error: Color(0xFFB85C5C),
      info: Color(0xFF5C8CA8),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFF5F3EF),
      background: Color(0xFFFAF9F7),
    );
  }

  // Dark theme colors (for future implementation)
  factory AppColors.dark() {
    return const AppColors(
      graphite: Color(0xFF1B1B1B),
      warmOffWhite: Color(0xFF2F2F2F),
      indigoInk: Color(0xFF5C7A94),
      lightSage: Color(0xFF8FA872),
      mutedSand: Color(0xFFC4B8A0),
      darkCharcoal: Color(0xFFE8E6E3),
      success: Color(0xFF87A878),
      warning: Color(0xFFD4A574),
      error: Color(0xFFB85C5C),
      info: Color(0xFF5C8CA8),
      surface: Color(0xFF1F1F1F),
      surfaceVariant: Color(0xFF2A2A2A),
      background: Color(0xFF151515),
    );
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? graphite,
    Color? warmOffWhite,
    Color? indigoInk,
    Color? lightSage,
    Color? mutedSand,
    Color? darkCharcoal,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? surface,
    Color? surfaceVariant,
    Color? background,
  }) {
    return AppColors(
      graphite: graphite ?? this.graphite,
      warmOffWhite: warmOffWhite ?? this.warmOffWhite,
      indigoInk: indigoInk ?? this.indigoInk,
      lightSage: lightSage ?? this.lightSage,
      mutedSand: mutedSand ?? this.mutedSand,
      darkCharcoal: darkCharcoal ?? this.darkCharcoal,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      background: background ?? this.background,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      graphite: Color.lerp(graphite, other.graphite, t)!,
      warmOffWhite: Color.lerp(warmOffWhite, other.warmOffWhite, t)!,
      indigoInk: Color.lerp(indigoInk, other.indigoInk, t)!,
      lightSage: Color.lerp(lightSage, other.lightSage, t)!,
      mutedSand: Color.lerp(mutedSand, other.mutedSand, t)!,
      darkCharcoal: Color.lerp(darkCharcoal, other.darkCharcoal, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }
}

// Extension for easy access to app colors
extension AppColorsExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
