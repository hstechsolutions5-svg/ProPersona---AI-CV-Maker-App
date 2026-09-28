import 'package:flutter/material.dart';

import '../responsive/responsive_builder.dart';
import '../responsive/responsive_value.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({required this.child, super.key, this.maxWidth = 1440});

  final Widget child;

  final double maxWidth;

  static const _padding = ResponsiveValue<double>(
    mobile: 16,
    tablet: 24,
    desktop: 32,
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final padding = _padding.resolve(deviceType);

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(padding: EdgeInsets.all(padding), child: child),
          ),
        );
      },
    );
  }
}
