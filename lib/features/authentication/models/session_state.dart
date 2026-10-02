import '../../../core/errors/app_failure.dart';
import '../../../shared/models/user_profile_model.dart';
import 'auth_user_model.dart';
import 'session_status.dart';

class SessionState {
  const SessionState({
    required this.status,
    this.authUser,
    this.profile,
    this.failure,
  });

  const SessionState.initial()
    : status = SessionStatus.initializing,
      authUser = null,
      profile = null,
      failure = null;

  const SessionState.unauthenticated()
    : status = SessionStatus.unauthenticated,
      authUser = null,
      profile = null,
      failure = null;

  const SessionState.authenticated({
    required AuthUserModel this.authUser,
    this.profile,
  }) : status = SessionStatus.authenticated,
       failure = null;

  const SessionState.error({
    this.authUser,
    this.profile,
    required AppFailure this.failure,
  }) : status = SessionStatus.error;

  final SessionStatus status;

  final AuthUserModel? authUser;
  final UserProfileModel? profile;
  final AppFailure? failure;

  bool get isInitializing => status == SessionStatus.initializing;

  bool get isUnauthenticated => status == SessionStatus.unauthenticated;

  bool get isAuthenticated => status == SessionStatus.authenticated;

  bool get hasError => status == SessionStatus.error;

  String? get uid => authUser?.uid;

  bool get hasProfile => profile != null;

  bool get requiresProfileCreation {
    return isAuthenticated && authUser != null && profile == null;
  }

  bool get needsLegalConsent {
    return isAuthenticated &&
        profile != null &&
        !profile!.hasAcceptedCurrentLegal;
  }

  bool get needsOnboarding {
    return isAuthenticated &&
        profile != null &&
        profile!.hasAcceptedCurrentLegal &&
        !profile!.onboardingCompleted;
  }

  bool get onboardingCompleted {
    return isAuthenticated && profile?.onboardingCompleted == true;
  }

  bool get canEnterApplication {
    return isAuthenticated &&
        profile != null &&
        profile!.hasAcceptedCurrentLegal &&
        profile!.onboardingCompleted;
  }
}
