import 'package:get/get.dart';

import '../../../core/services/logger_service.dart';
import '../../../shared/repositories/user_profile_repository.dart';
import '../../authentication/services/session_service.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(
        userProfileRepository: Get.find<UserProfileRepository>(),
        sessionService: Get.find<SessionService>(),
        logger: Get.find<LoggerService>(),
      ),
    );
  }
}
