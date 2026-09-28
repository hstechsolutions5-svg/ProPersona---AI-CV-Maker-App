import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingMiddleware extends GetMiddleware {
  OnboardingMiddleware() : super(priority: -20);

  @override
  RouteSettings? redirect(String? route) {
    // Future behaviour:
    //
    // if (!session.onboardingCompleted) {
    //   return const RouteSettings(
    //     name: AppRoutes.pathSelector,
    //   );
    // }

    return null;
  }
}
