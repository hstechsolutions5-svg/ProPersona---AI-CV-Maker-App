import 'package:get/get.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../../../core/services/logger_service.dart';
import '../../../shared/models/career_stage.dart';
import '../../../shared/repositories/user_profile_repository.dart';
import '../../authentication/services/session_service.dart';

class OnboardingController extends GetxController {
  OnboardingController({
    required this._userProfileRepository,
    required this._sessionService,
    required this._logger,
  });

  final UserProfileRepository _userProfileRepository;
  final SessionService _sessionService;
  final LoggerService _logger;

  final Rxn<CareerStage> _selectedStage = Rxn<CareerStage>();

  final RxBool _isSubmitting = false.obs;

  final Rxn<AppFailure> _failure = Rxn<AppFailure>();

  CareerStage? get selectedStage => _selectedStage.value;

  bool get isSubmitting => _isSubmitting.value;

  AppFailure? get failure => _failure.value;

  bool get hasSelection => selectedStage != null;

  bool get canContinue => hasSelection && !isSubmitting;

  @override
  void onInit() {
    super.onInit();

    // Useful if the user already selected a stage
    // but onboarding was not completed for any reason.
    _selectedStage.value = _sessionService.profile?.careerStage;
  }

  void selectStage(CareerStage stage) {
    if (isSubmitting) {
      return;
    }

    _failure.value = null;
    _selectedStage.value = stage;
  }

  void clearFailure() {
    _failure.value = null;
  }

  Future<bool> completeOnboarding() async {
    if (isSubmitting) {
      return false;
    }

    _failure.value = null;

    final authUser = _sessionService.authUser;

    final profile = _sessionService.profile;

    final stage = selectedStage;

    if (authUser == null) {
      _setValidationFailure(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'You must be signed in to continue.',
      );

      return false;
    }

    if (profile == null) {
      _setValidationFailure(
        code: 'PROFILE_REQUIRED',
        message: 'Your ProPersona profile could not be loaded.',
      );

      return false;
    }

    if (!profile.hasAcceptedCurrentLegal) {
      _setValidationFailure(
        code: 'LEGAL_CONSENT_REQUIRED',
        message:
            'Please accept the current Terms & Privacy Policy before continuing.',
      );

      return false;
    }

    if (stage == null) {
      _setValidationFailure(
        code: 'CAREER_STAGE_REQUIRED',
        message: 'Please select your career stage.',
      );

      return false;
    }

    _isSubmitting.value = true;

    try {
      final result = await _userProfileRepository.completeOnboarding(
        uid: authUser.uid,
        careerStage: stage,
      );

      switch (result) {
        case Success<void>():
          final updatedProfile = profile.copyWith(
            careerStage: stage,
            onboardingCompleted: true,
            updatedAt: DateTime.now().toUtc(),
          );

          _sessionService.setProfile(updatedProfile);

          _logger.info(
            'Onboarding completed successfully.',
            name: 'OnboardingController',
          );

          return true;

        case Failure<void>(failure: final failure):
          _failure.value = failure;

          _logger.warning(
            'Unable to complete onboarding.',
            error: failure.cause,
            stackTrace: failure.stackTrace,
            name: 'OnboardingController',
          );

          return false;
      }
    } finally {
      _isSubmitting.value = false;
    }
  }

  void _setValidationFailure({required String code, required String message}) {
    _failure.value = AppFailure(
      code: code,
      message: message,
      type: FailureType.validation,
    );
  }
}
