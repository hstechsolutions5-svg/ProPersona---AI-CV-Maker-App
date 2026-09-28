import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─────────────────────────────────────────────
  // Brand
  // ─────────────────────────────────────────────

  static const Color primary = Color(0xFF4057D6);
  static const Color primaryDark = Color(0xFF24348F);
  static const Color secondary = Color(0xFF4D8DFF);

  // ─────────────────────────────────────────────
  // Semantic
  // ─────────────────────────────────────────────

  static const Color success = Color(0xFF18A86B);
  static const Color warning = Color(0xFFE5A11A);
  static const Color error = Color(0xFFDC4C4C);
  static const Color info = Color(0xFF3A86FF);

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFEEF2F8);

  static const Color textPrimary = Color(0xFF18202E);
  static const Color textSecondary = Color(0xFF667085);

  static const Color lightBorder = Color(0xFFE2E7F0);

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────

  static const Color darkBackground = Color(0xFF10131A);
  static const Color darkSurface = Color(0xFF181D27);
  static const Color darkSurfaceMuted = Color(0xFF212735);

  static const Color darkTextPrimary = Color(0xFFF4F7FB);
  static const Color darkTextSecondary = Color(0xFFA9B4C5);

  static const Color darkBorder = Color(0xFF2B3443);

  // ─────────────────────────────────────────────
  // ATS Score Colors
  // ─────────────────────────────────────────────

  static Color atsScore(int score) {
    final normalized = score.clamp(0, 100);

    if (normalized >= 85) {
      return success;
    }

    if (normalized >= 70) {
      return info;
    }

    if (normalized >= 50) {
      return warning;
    }

    return error;
  }

  static String atsScoreLabel(int score) {
    final normalized = score.clamp(0, 100);

    if (normalized >= 85) {
      return 'Excellent';
    }

    if (normalized >= 70) {
      return 'Good';
    }

    if (normalized >= 50) {
      return 'Needs Improvement';
    }

    return 'Needs Attention';
  }
}
