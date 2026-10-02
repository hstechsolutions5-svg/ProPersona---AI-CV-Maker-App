import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import 'app_account_menu.dart';
import 'app_navigation.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.child,
    this.currentRoute,
    this.actions = const <Widget>[],
    this.floatingActionButton,
    super.key,
  });

  final String title;
  final String? currentRoute;

  final Widget child;

  final List<Widget> actions;

  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final route = currentRoute ?? Get.currentRoute;

    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return switch (deviceType) {
          DeviceType.mobile => _buildMobile(context, route),

          DeviceType.tablet => _buildRailLayout(
            context,
            route,
            extended: false,
          ),

          DeviceType.desktop => _buildRailLayout(
            context,
            route,
            extended: true,
          ),
        };
      },
    );
  }

  Widget _buildMobile(BuildContext context, String route) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
        actions: [...actions, const AppAccountMenu(), const SizedBox(width: 8)],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: AppBottomNavigation(currentRoute: route),
    );
  }

  Widget _buildRailLayout(
    BuildContext context,
    String route, {
    required bool extended,
  }) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Row(
          children: [
            AppNavigationRail(currentRoute: route, extended: extended),

            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),

            Expanded(
              child: Column(
                children: [
                  _DesktopHeader(title: title, actions: actions),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outlineVariant,
                  ),

                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.title, required this.actions});

  final String title;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            ...actions,

            if (actions.isNotEmpty) const SizedBox(width: 8),

            const AppAccountMenu(),
          ],
        ),
      ),
    );
  }
}
