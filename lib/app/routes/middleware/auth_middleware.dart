import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware() : super(priority: -30);

  @override
  RouteSettings? redirect(String? route) {
    // Authentication enforcement will be
    // connected once AuthController /
    // session state is implemented.
    //
    // Do NOT access Firebase directly here.
    //
    // Future behaviour:
    //
    // if (!session.isAuthenticated) {
    //   return const RouteSettings(
    //     name: AppRoutes.login,
    //   );
    // }

    return null;
  }
}
