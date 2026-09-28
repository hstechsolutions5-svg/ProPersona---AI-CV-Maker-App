import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_theme.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';

class ProPersonaApp extends StatelessWidget {
  const ProPersonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ProPersona',

      debugShowCheckedModeBanner: false,

      initialBinding: InitialBinding(),

      initialRoute: AppPages.initial,

      getPages: AppPages.pages,

      unknownRoute: AppPages.unknownRoute,

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: ThemeMode.system,

      defaultTransition: Transition.fadeIn,

      transitionDuration: const Duration(milliseconds: 180),
    );
  }
}
