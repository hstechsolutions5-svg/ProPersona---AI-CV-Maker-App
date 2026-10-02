import 'package:flutter/material.dart';

import '../../app/routes/app_routes.dart';

class AppNavigationItem {
  const AppNavigationItem({
    required this.label,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    this.aliases = const <String>[],
  });

  final String label;
  final String route;

  final IconData icon;
  final IconData selectedIcon;

  final List<String> aliases;

  bool matches(String currentRoute) {
    if (_matchesPath(currentRoute, route)) {
      return true;
    }

    for (final alias in aliases) {
      if (_matchesPath(currentRoute, alias)) {
        return true;
      }
    }

    return false;
  }

  bool _matchesPath(String currentRoute, String targetRoute) {
    return currentRoute == targetRoute ||
        currentRoute.startsWith('$targetRoute/');
  }
}

abstract final class AppNavigationItems {
  static const AppNavigationItem dashboard = AppNavigationItem(
    label: 'Dashboard',
    route: AppRoutes.dashboard,
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
  );

  static const AppNavigationItem resumes = AppNavigationItem(
    label: 'Resumes',
    route: AppRoutes.resumes,
    icon: Icons.description_outlined,
    selectedIcon: Icons.description_rounded,
  );

  static const AppNavigationItem aiTools = AppNavigationItem(
    label: 'AI Tools',
    route: AppRoutes.aiTools,
    icon: Icons.auto_awesome_outlined,
    selectedIcon: Icons.auto_awesome_rounded,
  );

  static const AppNavigationItem profile = AppNavigationItem(
    label: 'Profile',
    route: AppRoutes.profile,
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    aliases: <String>[AppRoutes.settings, AppRoutes.subscription],
  );

  static const List<AppNavigationItem> primary = <AppNavigationItem>[
    dashboard,
    resumes,
    aiTools,
    profile,
  ];

  static int indexForRoute(String currentRoute) {
    for (var index = 0; index < primary.length; index++) {
      if (primary[index].matches(currentRoute)) {
        return index;
      }
    }

    // Settings and subscription are logically
    // grouped under Profile.
    return primary.indexOf(profile);
  }
}
