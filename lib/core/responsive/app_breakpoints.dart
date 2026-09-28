import 'device_type.dart';

abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static const double maxContentWidth = 1440;

  static DeviceType resolve(double width) {
    if (width < mobile) {
      return DeviceType.mobile;
    }

    if (width <= tablet) {
      return DeviceType.tablet;
    }

    return DeviceType.desktop;
  }

  static bool isMobile(double width) {
    return resolve(width) == DeviceType.mobile;
  }

  static bool isTablet(double width) {
    return resolve(width) == DeviceType.tablet;
  }

  static bool isDesktop(double width) {
    return resolve(width) == DeviceType.desktop;
  }
}
