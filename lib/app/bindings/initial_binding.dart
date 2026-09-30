import 'package:get/get.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/logger_service.dart';
import '../../features/authentication/bindings/authentication_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _registerCoreServices();

    AuthenticationBinding().dependencies();
  }

  void _registerCoreServices() {
    final logger = Get.isRegistered<LoggerService>()
        ? Get.find<LoggerService>()
        : LoggerService();

    if (!Get.isRegistered<LoggerService>()) {
      Get.put<LoggerService>(logger, permanent: true);
    }

    if (!Get.isRegistered<LocalStorageService>()) {
      Get.put<LocalStorageService>(LocalStorageService(), permanent: true);
    }

    if (!Get.isRegistered<ConnectivityService>()) {
      Get.put<ConnectivityService>(
        ConnectivityService(logger: logger),
        permanent: true,
      );
    }
  }
}
