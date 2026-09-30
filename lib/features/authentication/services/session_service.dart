import 'dart:async';

import 'package:get/get.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../../../core/services/logger_service.dart';
import '../../../shared/models/user_profile_model.dart';
import '../../../shared/repositories/user_profile_repository.dart';
import '../models/auth_user_model.dart';
import '../models/session_state.dart';
import '../models/session_status.dart';
import '../repositories/authentication_repository.dart';

class SessionService extends GetxService {
  SessionService({
    required this._authRepository,
    required this._userProfileRepository,
    required this._logger,
  });

  final AuthRepository _authRepository;

  final UserProfileRepository _userProfileRepository;

  final LoggerService _logger;

  StreamSubscription<AuthUserModel?>? _authSubscription;

  final Rx<SessionState> _state = const SessionState.initial().obs;

  int _revision = 0;

  // ─────────────────────────────────────────────
  // Public State
  // ─────────────────────────────────────────────

  SessionState get state => _state.value;

  AuthUserModel? get authUser => state.authUser;

  UserProfileModel? get profile => state.profile;

  String? get uid => state.uid;

  bool get isInitializing => state.isInitializing;

  bool get isAuthenticated => state.isAuthenticated;

  bool get isUnauthenticated => state.isUnauthenticated;

  bool get hasProfile => state.hasProfile;

  bool get needsOnboarding => state.needsOnboarding;

  bool get onboardingCompleted => state.onboardingCompleted;

  bool get canEnterApplication => state.canEnterApplication;

  bool get hasError => state.hasError;

  bool get needsLegalConsent => state.needsLegalConsent;

  AppFailure? get failure => state.failure;

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    _listenToAuthentication();
  }

  void _listenToAuthentication() {
    _authSubscription = _authRepository.authStateChanges().listen(
      (user) {
        unawaited(_handleAuthenticationChange(user));
      },
      onError: (Object error, StackTrace stackTrace) {
        _logger.error(
          'Authentication state stream failed.',
          error: error,
          stackTrace: stackTrace,
          name: 'SessionService',
        );

        _state.value = SessionState.error(
          authUser: state.authUser,
          profile: state.profile,
          failure: AppFailure(
            code: 'SESSION_AUTH_STREAM_ERROR',
            message: 'Your session could not be loaded. Please try again.',
            type: FailureType.unknown,
            cause: error,
            stackTrace: stackTrace,
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Authentication Change
  // ─────────────────────────────────────────────

  Future<void> _handleAuthenticationChange(AuthUserModel? user) async {
    final revision = ++_revision;

    if (user == null) {
      _logger.debug(
        'Session changed to unauthenticated.',
        name: 'SessionService',
      );

      _state.value = const SessionState.unauthenticated();

      return;
    }

    _logger.debug(
      'Authenticated user detected: ${user.uid}',
      name: 'SessionService',
    );

    _state.value = SessionState(
      status: SessionStatus.initializing,
      authUser: user,
    );

    await _loadProfile(user: user, revision: revision);
  }

  // ─────────────────────────────────────────────
  // Load Firestore Profile
  // ─────────────────────────────────────────────

  Future<void> _loadProfile({
    required AuthUserModel user,
    required int revision,
  }) async {
    final result = await _userProfileRepository.getProfile(uid: user.uid);

    // Authentication may have changed while
    // Firestore was loading.
    if (revision != _revision) {
      return;
    }

    switch (result) {
      case Success<UserProfileModel?>(data: final profile):
        _state.value = SessionState.authenticated(
          authUser: user,
          profile: profile,
        );

        _logger.debug(
          profile == null
              ? 'Authenticated user has no ProPersona profile.'
              : 'User session and profile loaded.',
          name: 'SessionService',
        );

      case Failure<UserProfileModel?>(failure: final failure):
        _state.value = SessionState.error(authUser: user, failure: failure);

        _logger.error(
          'Unable to load user profile.',
          error: failure.cause,
          stackTrace: failure.stackTrace,
          name: 'SessionService',
        );
    }
  }

  // ─────────────────────────────────────────────
  // Refresh Profile
  // ─────────────────────────────────────────────

  Future<void> refreshProfile() async {
    final user = state.authUser;

    if (user == null) {
      _state.value = const SessionState.unauthenticated();

      return;
    }

    final revision = ++_revision;

    _state.value = SessionState(
      status: SessionStatus.initializing,
      authUser: user,
      profile: state.profile,
    );

    await _loadProfile(user: user, revision: revision);
  }

  // ─────────────────────────────────────────────
  // Update Session Profile
  // ─────────────────────────────────────────────

  void setProfile(UserProfileModel profile) {
    final user = state.authUser;

    if (user == null) {
      _logger.warning(
        'Attempted to set a session profile without an authenticated user.',
        name: 'SessionService',
      );

      return;
    }

    if (profile.uid != user.uid) {
      _logger.warning(
        'Attempted to assign a profile belonging to another user.',
        name: 'SessionService',
      );

      return;
    }

    // Invalidate any pending profile request.
    _revision++;

    _state.value = SessionState.authenticated(authUser: user, profile: profile);

    _logger.debug('Session profile updated.', name: 'SessionService');
  }

  // ─────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────

  @override
  void onClose() {
    final subscription = _authSubscription;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }

    super.onClose();
  }
}
