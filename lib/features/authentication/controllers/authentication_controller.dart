import 'package:get/get.dart';

import '../../../core/constants/legal_document_versions.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../../../core/services/logger_service.dart';
import '../../../shared/models/user_profile_model.dart';
import '../../../shared/repositories/user_profile_repository.dart';
import '../models/auth_user_model.dart';
import '../repositories/authentication_repository.dart';
import '../services/session_service.dart';

enum AuthOperation {
  none,
  login,
  signup,
  googleSignIn,
  passwordReset,
  legalConsent,
  logout,
}

class AuthController extends GetxController {
  AuthController({
    required this._authRepository,
    required this._userProfileRepository,
    required this._sessionService,
    required this._logger,
  });

  final AuthRepository _authRepository;

  final UserProfileRepository _userProfileRepository;

  final SessionService _sessionService;

  final LoggerService _logger;

  final Rx<AuthOperation> _operation = AuthOperation.none.obs;

  final Rxn<AppFailure> _failure = Rxn<AppFailure>();

  AuthOperation get operation => _operation.value;

  AppFailure? get failure => _failure.value;

  bool get isLoading => operation != AuthOperation.none;

  bool get isLoggingIn => operation == AuthOperation.login;

  bool get isSigningUp => operation == AuthOperation.signup;

  bool get isGoogleSigningIn => operation == AuthOperation.googleSignIn;

  bool get isResettingPassword => operation == AuthOperation.passwordReset;

  bool get isAcceptingLegalConsent => operation == AuthOperation.legalConsent;

  bool get isLoggingOut => operation == AuthOperation.logout;

  SessionService get session => _sessionService;

  Future<bool> login({required String email, required String password}) async {
    if (!_begin(AuthOperation.login)) {
      return false;
    }

    try {
      if (!_validateCredentials(email: email, password: password)) {
        return false;
      }

      final result = await _authRepository.login(
        email: email.trim(),
        password: password,
      );

      switch (result) {
        case Success<AuthUserModel>(data: final user):
          await _updateLastLogin(user.uid);

          return true;

        case Failure<AuthUserModel>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _end();
    }
  }

  Future<bool> signup({
    required String fullName,
    required String email,
    required String password,
    required bool legalConsentAccepted,
  }) async {
    if (!_begin(AuthOperation.signup)) {
      return false;
    }

    try {
      if (fullName.trim().isEmpty) {
        _validation('FULL_NAME_REQUIRED', 'Please enter your full name.');

        return false;
      }

      if (!_validateCredentials(email: email, password: password)) {
        return false;
      }

      if (!legalConsentAccepted) {
        _validation(
          'LEGAL_CONSENT_REQUIRED',
          'You must accept the Terms & Conditions and Privacy Policy.',
        );

        return false;
      }

      final authResult = await _authRepository.signup(
        email: email.trim(),
        password: password,
      );

      switch (authResult) {
        case Failure<AuthUserModel>(failure: final failure):
          _setFailure(failure);

          return false;

        case Success<AuthUserModel>(data: final authUser):
          final profile = UserProfileModel.newUser(
            uid: authUser.uid,
            fullName: fullName.trim(),
            email: authUser.email,
            photoUrl: authUser.photoUrl,
            acceptedTermsVersion: LegalDocumentVersions.terms,
            acceptedPrivacyVersion: LegalDocumentVersions.privacy,
          );

          final profileResult = await _userProfileRepository.createProfile(
            profile: profile,
          );

          switch (profileResult) {
            case Success<UserProfileModel>(data: final createdProfile):
              _sessionService.setProfile(createdProfile);

              return true;

            case Failure<UserProfileModel>(failure: final failure):
              _setFailure(failure);

              return false;
          }
      }
    } finally {
      _end();
    }
  }

  Future<bool> signInWithGoogle({bool legalConsentAccepted = false}) async {
    if (!_begin(AuthOperation.googleSignIn)) {
      return false;
    }

    try {
      final authResult = await _authRepository.signInWithGoogle();

      switch (authResult) {
        case Failure<AuthUserModel>(failure: final failure):
          _setFailure(failure);

          return false;

        case Success<AuthUserModel>(data: final authUser):
          return _resolveGoogleProfile(
            authUser,
            legalConsentAccepted: legalConsentAccepted,
          );
      }
    } finally {
      _end();
    }
  }

  Future<bool> _resolveGoogleProfile(
    AuthUserModel authUser, {
    required bool legalConsentAccepted,
  }) async {
    final result = await _userProfileRepository.getProfile(uid: authUser.uid);

    switch (result) {
      case Failure<UserProfileModel?>(failure: final failure):
        _setFailure(failure);

        return false;

      case Success<UserProfileModel?>(data: final profile):
        if (profile != null) {
          _sessionService.setProfile(profile);

          await _updateLastLogin(authUser.uid);

          return true;
        }

        if (!legalConsentAccepted) {
          await _authRepository.logout();

          _validation(
            'LEGAL_CONSENT_REQUIRED',
            'No ProPersona profile exists for this Google account. Please create an account first.',
          );

          return false;
        }

        final fullName = _googleDisplayName(authUser);

        final newProfile = UserProfileModel.newUser(
          uid: authUser.uid,
          fullName: fullName,
          email: authUser.email,
          photoUrl: authUser.photoUrl,
          acceptedTermsVersion: LegalDocumentVersions.terms,
          acceptedPrivacyVersion: LegalDocumentVersions.privacy,
        );

        final createResult = await _userProfileRepository.createProfile(
          profile: newProfile,
        );

        switch (createResult) {
          case Success<UserProfileModel>(data: final createdProfile):
            _sessionService.setProfile(createdProfile);

            return true;

          case Failure<UserProfileModel>(failure: final failure):
            _setFailure(failure);

            return false;
        }
    }
  }

  Future<bool> resetPassword({required String email}) async {
    if (!_begin(AuthOperation.passwordReset)) {
      return false;
    }

    try {
      if (email.trim().isEmpty) {
        _validation('EMAIL_REQUIRED', 'Please enter your email address.');

        return false;
      }

      final result = await _authRepository.resetPassword(email: email.trim());

      switch (result) {
        case Success<void>():
          return true;

        case Failure<void>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _end();
    }
  }

  Future<bool> acceptCurrentLegalDocuments() async {
    if (!_begin(AuthOperation.legalConsent)) {
      return false;
    }

    try {
      final uid = _sessionService.uid;

      if (uid == null) {
        _validation('AUTH_REQUIRED', 'You must be signed in.');

        return false;
      }

      final result = await _userProfileRepository.updateLegalConsent(
        uid: uid,
        termsVersion: LegalDocumentVersions.terms,
        privacyVersion: LegalDocumentVersions.privacy,
      );

      switch (result) {
        case Success<void>():
          await _sessionService.refreshProfile();

          return true;

        case Failure<void>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _end();
    }
  }

  Future<bool> logout() async {
    if (!_begin(AuthOperation.logout)) {
      return false;
    }

    try {
      final result = await _authRepository.logout();

      switch (result) {
        case Success<void>():
          return true;

        case Failure<void>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _end();
    }
  }

  void clearFailure() {
    _failure.value = null;
  }

  bool _begin(AuthOperation operation) {
    if (isLoading) {
      return false;
    }

    _failure.value = null;
    _operation.value = operation;

    return true;
  }

  void _end() {
    _operation.value = AuthOperation.none;
  }

  bool _validateCredentials({required String email, required String password}) {
    if (email.trim().isEmpty) {
      _validation('EMAIL_REQUIRED', 'Please enter your email address.');

      return false;
    }

    if (password.isEmpty) {
      _validation('PASSWORD_REQUIRED', 'Please enter your password.');

      return false;
    }

    return true;
  }

  void _validation(String code, String message) {
    _failure.value = AppFailure(
      code: code,
      message: message,
      type: FailureType.validation,
    );
  }

  void _setFailure(AppFailure failure) {
    _failure.value = failure;

    _logger.warning(
      'Authentication operation failed: ${failure.code}',
      error: failure.cause,
      stackTrace: failure.stackTrace,
      name: 'AuthController',
    );
  }

  Future<void> _updateLastLogin(String uid) async {
    final result = await _userProfileRepository.updateLastLogin(uid: uid);

    if (result case Failure<void>(failure: final failure)) {
      _logger.warning(
        'Unable to update last login.',
        error: failure.cause,
        stackTrace: failure.stackTrace,
        name: 'AuthController',
      );
    }
  }

  String _googleDisplayName(AuthUserModel user) {
    final displayName = user.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final email = user.email.trim();

    if (email.contains('@')) {
      final local = email.split('@').first;

      if (local.isNotEmpty) {
        return local;
      }
    }

    return 'ProPersona User';
  }
}
