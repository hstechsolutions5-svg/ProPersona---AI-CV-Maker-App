import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/app_navigation_item.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({required this.currentRoute, super.key});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final items = AppNavigationItems.primary;

    final selectedIndex = AppNavigationItems.indexForRoute(currentRoute);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        final destination = items[index];

        if (destination.matches(currentRoute)) {
          return;
        }

        Get.offAllNamed(destination.route);
      },
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          ),
      ],
    );
  }
}

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    required this.currentRoute,
    required this.extended,
    super.key,
  });

  final String currentRoute;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final items = AppNavigationItems.primary;

    final selectedIndex = AppNavigationItems.indexForRoute(currentRoute);

    // final theme = Theme.of(context);

    return NavigationRail(
      extended: extended,
      minWidth: 72,
      minExtendedWidth: 232,
      selectedIndex: selectedIndex,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      leading: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: _NavigationLogo(extended: extended),
      ),
      onDestinationSelected: (index) {
        final destination = items[index];

        if (destination.matches(currentRoute)) {
          return;
        }

        Get.offAllNamed(destination.route);
      },
      destinations: [
        for (final item in items)
          NavigationRailDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: Text(item.label),
          ),
      ],
    );
  }
}

class _NavigationLogo extends StatelessWidget {
  const _NavigationLogo({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final logo = Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'P',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
        ),
      ),
    );

    if (!extended) {
      return logo;
    }

    return SizedBox(
      width: 190,
      child: Row(
        children: [
          logo,

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'ProPersona',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
