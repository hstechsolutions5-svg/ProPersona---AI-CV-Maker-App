import 'package:flutter/material.dart';

import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_spacing.dart';

class AppPageContainer extends StatelessWidget {
  const AppPageContainer({required this.child, this.padding, super.key});

  final Widget child;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final effectivePadding =
            padding ??
            switch (deviceType) {
              DeviceType.mobile => const EdgeInsets.all(AppSpacing.lg),

              DeviceType.tablet ||
              DeviceType.desktop => const EdgeInsets.all(AppSpacing.xxl),
            };

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Padding(padding: effectivePadding, child: child),
          ),
        );
      },
    );
  }
}
