import 'package:flutter/material.dart';

import 'app_page_container.dart';
import 'app_shell.dart';

class AppShellPlaceholderView extends StatelessWidget {
  const AppShellPlaceholderView({
    required this.title,
    required this.route,
    this.description,
    super.key,
  });

  final String title;
  final String route;

  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppShell(
      title: title,
      currentRoute: route,
      child: AppPageContainer(
        child: SizedBox(
          height: 420,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.construction_rounded,
                  size: 44,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(height: 16),

                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description ??
                      '$title will be implemented in the next development phase.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
