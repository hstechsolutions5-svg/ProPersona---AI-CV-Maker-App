import 'package:get/get.dart';

import '../../authentication/services/session_service.dart';
import '../../resumes/bindings/resumes_binding.dart';
import '../../resumes/controllers/resumes_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    ResumeBinding().dependencies();

    Get.lazyPut<DashboardController>(
      () => DashboardController(
        sessionService: Get.find<SessionService>(),
        resumeController: Get.find<ResumeController>(),
      ),
    );
  }
}
