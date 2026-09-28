import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_component_theme.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return _buildTheme(Brightness.light);
  }

  static ThemeData get dark {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,

          secondary: AppColors.secondary,
          onSecondary: Colors.white,

          error: AppColors.error,

          surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,

          onSurface: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,

          outline: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,

      textTheme: AppTypography.textTheme(brightness),

      cardTheme: AppComponentTheme.cardTheme(brightness),

      inputDecorationTheme: AppComponentTheme.inputDecoration(brightness),

      filledButtonTheme: AppComponentTheme.filledButtonTheme(),

      elevatedButtonTheme: AppComponentTheme.elevatedButtonTheme(),

      outlinedButtonTheme: AppComponentTheme.outlinedButtonTheme(brightness),

      textButtonTheme: AppComponentTheme.textButtonTheme(),

      navigationBarTheme: AppComponentTheme.navigationBarTheme(brightness),

      navigationRailTheme: AppComponentTheme.navigationRailTheme(brightness),

      dialogTheme: AppComponentTheme.dialogTheme(brightness),

      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),

      splashFactory: InkSparkle.splashFactory,
    );
  }
}
