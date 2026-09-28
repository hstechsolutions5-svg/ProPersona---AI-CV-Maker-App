import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import 'device_type.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth {
    return MediaQuery.sizeOf(this).width;
  }

  DeviceType get deviceType {
    return AppBreakpoints.resolve(screenWidth);
  }

  bool get isMobile {
    return deviceType == DeviceType.mobile;
  }

  bool get isTablet {
    return deviceType == DeviceType.tablet;
  }

  bool get isDesktop {
    return deviceType == DeviceType.desktop;
  }
}
