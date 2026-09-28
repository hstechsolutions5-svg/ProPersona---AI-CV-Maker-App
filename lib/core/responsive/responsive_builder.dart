import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import 'device_type.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(
      BuildContext context,
      DeviceType deviceType,
      BoxConstraints constraints,
    );

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({required this.builder, super.key});

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = AppBreakpoints.resolve(constraints.maxWidth);

        return builder(context, deviceType, constraints);
      },
    );
  }
}
