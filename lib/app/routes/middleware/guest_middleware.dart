import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/authentication/services/session_service.dart';
import '../app_routes.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => -30;

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<SessionService>()) {
      return const RouteSettings(name: AppRoutes.splash);
    }

    final session = Get.find<SessionService>();

    if (session.isInitializing || session.hasError) {
      return const RouteSettings(name: AppRoutes.splash);
    }

    if (session.isUnauthenticated) {
      return null;
    }

    // Authenticated users should go back
    // through the centralized resolver.
    return const RouteSettings(name: AppRoutes.splash);
  }
}
