import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'text_styles.dart';

/// Main theme configuration for ClueScraper
/// Implements minimalist Japanese-inspired design with Zen aesthetics
class AppTheme {
  static ThemeData lightTheme() {
    final appColors = AppColors.light();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: appColors.indigoInk,
        secondary: appColors.lightSage,
        tertiary: appColors.mutedSand,
        surface: appColors.surface,
        error: appColors.error,
        onPrimary: appColors.warmOffWhite,
        onSecondary: appColors.darkCharcoal,
        onSurface: appColors.darkCharcoal,
        onError: appColors.warmOffWhite,
        surfaceContainerHighest: appColors.surfaceVariant,
      ),

      // Scaffold
      scaffoldBackgroundColor: appColors.background,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appColors.surface,
        foregroundColor: appColors.darkCharcoal,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: appColors.darkCharcoal,
        ),
        iconTheme: IconThemeData(color: appColors.graphite),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 1,
        color: appColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: appColors.graphite.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: appColors.indigoInk,
          foregroundColor: appColors.warmOffWhite,
          disabledBackgroundColor: appColors.mutedSand,
          disabledForegroundColor: appColors.graphite.withValues(alpha: 0.38),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appColors.indigoInk,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColors.indigoInk,
          side: BorderSide(color: appColors.indigoInk, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.indigoInk, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: appColors.graphite.withValues(alpha: 0.7),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: appColors.graphite.withValues(alpha: 0.5),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: appColors.error),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appColors.surface,
        selectedItemColor: appColors.indigoInk,
        unselectedItemColor: appColors.graphite.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColors.indigoInk,
        foregroundColor: appColors.warmOffWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: appColors.graphite.withValues(alpha: 0.12),
        space: 1,
        thickness: 1,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: appColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: appColors.darkCharcoal,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: appColors.graphite,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.graphite,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: appColors.warmOffWhite,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appColors.indigoInk,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: appColors.graphite, size: 24),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: appColors.darkCharcoal,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: appColors.darkCharcoal,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: appColors.darkCharcoal,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: appColors.darkCharcoal,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: appColors.darkCharcoal,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: appColors.darkCharcoal,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: appColors.darkCharcoal,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: appColors.darkCharcoal,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: appColors.graphite,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: appColors.graphite),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: appColors.graphite,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: appColors.graphite),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: appColors.graphite,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: appColors.graphite,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: appColors.graphite,
        ),
      ),

      // Extensions
      extensions: <ThemeExtension<dynamic>>[appColors],
    );
  }

  // Dark theme for future implementation
  static ThemeData darkTheme() {
    final appColors = AppColors.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: appColors.indigoInk,
        secondary: appColors.lightSage,
        tertiary: appColors.mutedSand,
        surface: appColors.surface,
        error: appColors.error,
      ),
      scaffoldBackgroundColor: appColors.background,
      extensions: <ThemeExtension<dynamic>>[appColors],
      // TODO: Complete dark theme configuration in future phases
    );
  }
}
