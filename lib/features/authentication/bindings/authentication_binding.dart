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
    _registerAuthRepository();
    _registerUserProfileRepository();
    _registerSessionService();
    _registerAuthController();
  }

  void _registerAuthRepository() {
    if (Get.isRegistered<AuthRepository>()) {
      return;
    }

    Get.put<AuthRepository>(
      FirebaseAuthenticationRepository(),
      permanent: true,
    );
  }

  void _registerUserProfileRepository() {
    if (Get.isRegistered<UserProfileRepository>()) {
      return;
    }

    Get.put<UserProfileRepository>(
      FirebaseUserProfileRepository(),
      permanent: true,
    );
  }

  void _registerSessionService() {
    if (Get.isRegistered<SessionService>()) {
      return;
    }

    Get.put<SessionService>(
      SessionService(
        authRepository: Get.find<AuthRepository>(),
        userProfileRepository: Get.find<UserProfileRepository>(),
        logger: Get.find<LoggerService>(),
      ),
      permanent: true,
    );
  }

  void _registerAuthController() {
    if (Get.isRegistered<AuthController>()) {
      return;
    }

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
