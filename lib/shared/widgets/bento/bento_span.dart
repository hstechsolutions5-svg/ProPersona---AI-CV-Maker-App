import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_value.dart';

class BentoSpan {
  const BentoSpan({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final int mobile;
  final int tablet;
  final int desktop;

  int resolve(DeviceType deviceType) {
    return ResponsiveValue<int>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).resolve(deviceType);
  }
}
