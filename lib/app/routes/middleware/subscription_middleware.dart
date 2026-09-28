import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionMiddleware extends GetMiddleware {
  SubscriptionMiddleware() : super(priority: -10);

  @override
  RouteSettings? redirect(String? route) {
    // Future behaviour for premium routes:
    //
    // if (!subscription.hasPremiumAccess) {
    //   return const RouteSettings(
    //     name: AppRoutes.subscription,
    //   );
    // }

    return null;
  }
}
