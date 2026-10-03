import 'package:get/get.dart';

import '../../../core/services/logger_service.dart';
import '../../authentication/services/session_service.dart';
import '../controllers/resumes_controller.dart';
import '../repositories/firebase_resumes_repository.dart';
import '../repositories/resumes_repository.dart';

class ResumeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ResumeRepository>()) {
      Get.lazyPut<ResumeRepository>(
        () => FirebaseResumeRepository(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ResumeController>()) {
      Get.lazyPut<ResumeController>(
        () => ResumeController(
          resumeRepository: Get.find<ResumeRepository>(),
          sessionService: Get.find<SessionService>(),
          logger: Get.find<LoggerService>(),
        ),
        fenix: true,
      );
    }
  }
}
