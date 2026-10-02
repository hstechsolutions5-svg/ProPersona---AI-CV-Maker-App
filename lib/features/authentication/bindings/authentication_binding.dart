import 'package:get/get.dart';

import '../../../core/services/logger_service.dart';
import '../../../shared/repositories/firebase_user_profile_repository.dart';
import '../../../shared/repositories/user_profile_repository.dart';
import '../controllers/authentication_controller.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/firebase_authentication_repository.dart';
import '../services/session_service.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(
        FirebaseAuthenticationRepository(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<UserProfileRepository>()) {
      Get.put<UserProfileRepository>(
        FirebaseUserProfileRepository(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(
        SessionService(
          authRepository: Get.find<AuthRepository>(),
          userProfileRepository: Get.find<UserProfileRepository>(),
          logger: Get.find<LoggerService>(),
        ),
        permanent: true,
      );
    }

    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(
          authRepository: Get.find<AuthRepository>(),
          userProfileRepository: Get.find<UserProfileRepository>(),
          sessionService: Get.find<SessionService>(),
          logger: Get.find<LoggerService>(),
        ),
        fenix: true,
      );
    }
  }
}
