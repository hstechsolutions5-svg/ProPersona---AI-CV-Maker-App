import 'package:get/get.dart';

import '../../resumes/bindings/resumes_binding.dart';
import '../../resumes/controllers/resumes_controller.dart';
import '../controllers/resume_builder_controller.dart';

class ResumeBuilderBinding extends Bindings {
  @override
  void dependencies() {
    ResumeBinding().dependencies();

    if (!Get.isRegistered<ResumeBuilderController>()) {
      Get.lazyPut<ResumeBuilderController>(
        () => ResumeBuilderController(
          resumeController: Get.find<ResumeController>(),
        ),
      );
    }
  }
}
