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

  // ─────────────────────────────────────────────
  // Session Status
  // ─────────────────────────────────────────────

  bool get isInitializing {
    return status == SessionStatus.initializing;
  }

  bool get isUnauthenticated {
    return status == SessionStatus.unauthenticated;
  }

  bool get isAuthenticated {
    return status == SessionStatus.authenticated;
  }

  bool get hasError {
    return status == SessionStatus.error;
  }

  bool get needsLegalConsent {
    return isAuthenticated &&
        profile != null &&
        !profile!.hasAcceptedCurrentLegal;
  }

  // ─────────────────────────────────────────────
  // Authentication
  // ─────────────────────────────────────────────

  bool get hasAuthenticatedUser {
    return authUser != null;
  }

  String? get uid {
    return authUser?.uid;
  }

  // ─────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────

  bool get hasProfile {
    return profile != null;
  }

  bool get requiresProfileCreation {
    return isAuthenticated && authUser != null && profile == null;
  }

  // ─────────────────────────────────────────────
  // Onboarding
  // ─────────────────────────────────────────────

  bool get needsOnboarding {
    return isAuthenticated &&
        profile != null &&
        profile!.hasAcceptedCurrentLegal &&
        !profile!.onboardingCompleted;
  }

  bool get onboardingCompleted {
    return isAuthenticated && profile?.onboardingCompleted == true;
  }

  // ─────────────────────────────────────────────
  // Application Access
  // ─────────────────────────────────────────────

  bool get canEnterApplication {
    return isAuthenticated &&
        profile != null &&
        profile!.hasAcceptedCurrentLegal &&
        profile!.onboardingCompleted;
  }

  @override
  String toString() {
    return 'SessionState('
        'status: $status, '
        'uid: ${authUser?.uid}, '
        'hasProfile: $hasProfile, '
        'onboardingCompleted: $onboardingCompleted'
        ')';
  }
}
