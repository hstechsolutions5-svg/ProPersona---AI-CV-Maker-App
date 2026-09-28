import 'package:get/get.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/logger_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final logger = LoggerService();

    Get.put<LoggerService>(logger, permanent: true);

    Get.put<LocalStorageService>(LocalStorageService(), permanent: true);

    Get.put<ConnectivityService>(
      ConnectivityService(logger: logger),
      permanent: true,
    );
  }
}
