import 'package:get/get.dart';

import '../../resumes/bindings/resumes_binding.dart';
import '../../resumes/controllers/resumes_controller.dart';
import '../controllers/resume_preview_controller.dart';

class ResumePreviewBinding extends Bindings {
  @override
  void dependencies() {
    ResumeBinding().dependencies();

    if (!Get.isRegistered<
        ResumePreviewController>()) {
      Get.lazyPut<
          ResumePreviewController>(
            () => ResumePreviewController(
          resumeController:
          Get.find<
              ResumeController>(),
        ),
      );
    }
  }
}