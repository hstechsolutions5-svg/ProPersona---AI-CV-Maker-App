import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final primaryColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      displayMedium: GoogleFonts.inter(
        fontSize: 36,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      displaySmall: GoogleFonts.inter(
        fontSize: 32,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),

      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        height: 1.35,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
