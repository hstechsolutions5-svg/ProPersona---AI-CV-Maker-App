import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

abstract final class AppComponentTheme {
  static InputDecorationThemeData inputDecoration(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final hint = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return InputDecorationThemeData(
      filled: true,
      fillColor: surface,

      hintStyle: TextStyle(color: hint),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

      border: OutlineInputBorder(
        borderRadius: AppRadius.medium,
        borderSide: BorderSide(color: border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.medium,
        borderSide: BorderSide(color: border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.medium,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.medium,
        borderSide: const BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.medium,
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  static CardThemeData cardTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return CardThemeData(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.large,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
    );
  }

  static FilledButtonThemeData filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
    );
  }

  static ElevatedButtonThemeData elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark
            ? AppColors.darkTextPrimary
            : AppColors.textPrimary,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static NavigationBarThemeData navigationBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return NavigationBarThemeData(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,

      indicatorColor: AppColors.primary.withValues(alpha: 0.12),

      elevation: 0,

      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  static NavigationRailThemeData navigationRailTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return NavigationRailThemeData(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,

      indicatorColor: AppColors.primary.withValues(alpha: 0.12),

      selectedIconTheme: const IconThemeData(color: AppColors.primary),

      selectedLabelTextStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static DialogThemeData dialogTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return DialogThemeData(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,

      surfaceTintColor: Colors.transparent,

      shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
    );
  }
}
