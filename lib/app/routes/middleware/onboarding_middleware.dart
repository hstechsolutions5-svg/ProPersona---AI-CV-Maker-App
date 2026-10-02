import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/authentication/services/session_service.dart';
import '../app_routes.dart';

class OnboardingMiddleware extends GetMiddleware {
  @override
  int? get priority => -20;

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<SessionService>()) {
      return const RouteSettings(name: AppRoutes.splash);
    }

    final session = Get.find<SessionService>();

    if (session.isInitializing || session.hasError || !session.hasProfile) {
      return const RouteSettings(name: AppRoutes.splash);
    }

    // ─────────────────────────────────────
    // Legal consent required
    // ─────────────────────────────────────

    if (session.needsLegalConsent) {
      if (route == AppRoutes.legalConsent) {
        return null;
      }

      return const RouteSettings(name: AppRoutes.legalConsent);
    }

    // ─────────────────────────────────────
    // Onboarding required
    // ─────────────────────────────────────

    if (session.needsOnboarding) {
      if (route == AppRoutes.pathSelector) {
        return null;
      }

      return const RouteSettings(name: AppRoutes.pathSelector);
    }

    // ─────────────────────────────────────
    // User is fully onboarded
    // ─────────────────────────────────────

    if (session.canEnterApplication) {
      // Prevent fully onboarded users
      // from reopening onboarding routes.

      if (route == AppRoutes.pathSelector || route == AppRoutes.legalConsent) {
        return const RouteSettings(name: AppRoutes.dashboard);
      }

      return null;
    }

    return const RouteSettings(name: AppRoutes.splash);
  }
}
