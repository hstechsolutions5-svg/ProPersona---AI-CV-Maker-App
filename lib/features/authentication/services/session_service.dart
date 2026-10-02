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

  SessionState get state => _state.value;

  Rx<SessionState> get stateRx => _state;

  AuthUserModel? get authUser => state.authUser;

  UserProfileModel? get profile => state.profile;

  String? get uid => state.uid;

  bool get isInitializing => state.isInitializing;

  bool get isAuthenticated => state.isAuthenticated;

  bool get isUnauthenticated => state.isUnauthenticated;

  bool get hasProfile => state.hasProfile;

  bool get needsLegalConsent => state.needsLegalConsent;

  bool get needsOnboarding => state.needsOnboarding;

  bool get canEnterApplication => state.canEnterApplication;

  bool get hasError => state.hasError;

  AppFailure? get failure => state.failure;

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
            message: 'Your session could not be loaded.',
            type: FailureType.unknown,
            cause: error,
            stackTrace: stackTrace,
          ),
        );
      },
    );
  }

  Future<void> _handleAuthenticationChange(AuthUserModel? user) async {
    final revision = ++_revision;

    if (user == null) {
      _state.value = const SessionState.unauthenticated();

      return;
    }

    _state.value = SessionState(
      status: SessionStatus.initializing,
      authUser: user,
    );

    await _loadProfile(user: user, revision: revision);
  }

  Future<void> _loadProfile({
    required AuthUserModel user,
    required int revision,
  }) async {
    final result = await _userProfileRepository.getProfile(uid: user.uid);

    if (revision != _revision) {
      return;
    }

    switch (result) {
      case Success<UserProfileModel?>(data: final profile):
        _state.value = SessionState.authenticated(
          authUser: user,
          profile: profile,
        );

      case Failure<UserProfileModel?>(failure: final failure):
        _state.value = SessionState.error(authUser: user, failure: failure);
    }
  }

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

  void setProfile(UserProfileModel profile) {
    final user = state.authUser;

    if (user == null || user.uid != profile.uid) {
      return;
    }

    ++_revision;

    _state.value = SessionState.authenticated(authUser: user, profile: profile);
  }

  @override
  void onClose() {
    final subscription = _authSubscription;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }

    super.onClose();
  }
}
