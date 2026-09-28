import 'package:flutter/material.dart';

import '../../core/responsive/device_type.dart';
import '../../core/responsive/responsive_builder.dart';
import 'adaptive_navigation.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget body;

  final List<AdaptiveNavigationDestination> destinations;

  final int selectedIndex;

  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return switch (deviceType) {
          DeviceType.mobile => _buildMobile(context),

          DeviceType.tablet => _buildRail(context, extended: false),

          DeviceType.desktop => _buildRail(context, extended: true),
        };
      },
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selectedIcon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRail(BuildContext context, {required bool extended}) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: extended,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: Text(destination.label),
                    ),
                  )
                  .toList(),
            ),
          ),

          const VerticalDivider(width: 1),

          Expanded(child: body),
        ],
      ),
    );
  }
}
