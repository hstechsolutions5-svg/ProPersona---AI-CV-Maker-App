import 'package:get/get.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../../../core/services/logger_service.dart';
import '../../../shared/models/user_profile_model.dart';
import '../../../shared/repositories/user_profile_repository.dart';
import '../models/auth_user_model.dart';
import '../repositories/authentication_repository.dart';
import '../services/session_service.dart';
import '../../../core/constants/legal_document_versions.dart';

enum AuthOperation {
  none,
  login,
  signup,
  googleSignIn,
  passwordReset,
  logout,
  legalConsent,
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

  // ─────────────────────────────────────────────
  // Public State
  // ─────────────────────────────────────────────

  AuthOperation get operation => _operation.value;

  AppFailure? get failure => _failure.value;

  bool get isLoading => operation != AuthOperation.none;

  bool get isLoggingIn => operation == AuthOperation.login;

  bool get isSigningUp => operation == AuthOperation.signup;

  bool get isGoogleSigningIn => operation == AuthOperation.googleSignIn;

  bool get isResettingPassword => operation == AuthOperation.passwordReset;

  bool get isLoggingOut => operation == AuthOperation.logout;

  SessionService get session => _sessionService;

  bool get isAcceptingLegalConsent => operation == AuthOperation.legalConsent;

  // ─────────────────────────────────────────────
  // Login
  // ─────────────────────────────────────────────

  Future<bool> login({required String email, required String password}) async {
    if (!_beginOperation(AuthOperation.login)) {
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
          _logger.info(
            'User authenticated successfully.',
            name: 'AuthController',
          );

          await _updateLastLoginBestEffort(user.uid);

          return true;

        case Failure<AuthUserModel>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _endOperation();
    }
  }

  // ─────────────────────────────────────────────
  // Sign Up
  // ─────────────────────────────────────────────

  Future<bool> signup({
    required String fullName,
    required String email,
    required String password,
    required bool legalConsentAccepted,
  }) async {
    if (!_beginOperation(AuthOperation.signup)) {
      return false;
    }

    try {
      if (!_validateSignup(
        fullName: fullName,
        email: email,
        password: password,
      )) {
        return false;
      }

      final authResult = await _authRepository.signup(
        email: email.trim(),
        password: password,
      );

      if (!legalConsentAccepted) {
        _setValidationFailure(
          code: 'LEGAL_CONSENT_REQUIRED',
          message:
              'You must accept the Terms & Conditions and Privacy Policy to create an account.',
        );

        return false;
      }

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

              _logger.info(
                'User account and profile created successfully.',
                name: 'AuthController',
              );

              return true;

            case Failure<UserProfileModel>(failure: final failure):
              _setFailure(failure);

              _logger.error(
                'Authentication account was created but profile creation failed.',
                error: failure.cause,
                stackTrace: failure.stackTrace,
                name: 'AuthController',
              );

              return false;
          }
      }
    } finally {
      _endOperation();
    }
  }

  // ─────────────────────────────────────────────
  // Google Sign-In
  // ─────────────────────────────────────────────

  Future<bool> signInWithGoogle({bool legalConsentAccepted = false}) async {
    if (!_beginOperation(AuthOperation.googleSignIn)) {
      return false;
    }

    try {
      final authResult = await _authRepository.signInWithGoogle();

      switch (authResult) {
        case Failure<AuthUserModel>(failure: final failure):
          _setFailure(failure);

          return false;

        case Success<AuthUserModel>(data: final authUser):
          return await _resolveGoogleProfile(
            authUser,
            legalConsentAccepted: true,
          );
      }
    } finally {
      _endOperation();
    }
  }

  Future<bool> _resolveGoogleProfile(
    AuthUserModel authUser, {
    required bool legalConsentAccepted,
  }) async {
    final profileResult = await _userProfileRepository.getProfile(
      uid: authUser.uid,
    );

    switch (profileResult) {
      case Failure<UserProfileModel?>(failure: final failure):
        _setFailure(failure);
        return false;

      case Success<UserProfileModel?>(data: final existingProfile):
        if (existingProfile != null) {
          _sessionService.setProfile(existingProfile);

          await _updateLastLoginBestEffort(authUser.uid);

          return true;
        }

        if (!legalConsentAccepted) {
          await _authRepository.logout();

          _setValidationFailure(
            code: 'LEGAL_CONSENT_REQUIRED',
            message:
                'No ProPersona profile exists for this Google account. Please create an account and accept the Terms & Privacy Policy first.',
          );

          return false;
        }

        return _createGoogleProfile(authUser);
    }
  }

  Future<bool> _createGoogleProfile(AuthUserModel authUser) async {
    final fullName = _resolveGoogleDisplayName(authUser);

    final profile = UserProfileModel.newUser(
      uid: authUser.uid,
      fullName: fullName,
      email: authUser.email,
      photoUrl: authUser.photoUrl,
      acceptedTermsVersion: LegalDocumentVersions.terms,
      acceptedPrivacyVersion: LegalDocumentVersions.privacy,
    );

    final result = await _userProfileRepository.createProfile(profile: profile);

    switch (result) {
      case Success<UserProfileModel>(data: final createdProfile):
        _sessionService.setProfile(createdProfile);

        _logger.info(
          'New Google user profile created.',
          name: 'AuthController',
        );

        return true;

      case Failure<UserProfileModel>(failure: final failure):
        _setFailure(failure);

        return false;
    }
  }

  Future<bool> acceptCurrentLegalDocuments() async {
    if (!_beginOperation(AuthOperation.legalConsent)) {
      return false;
    }

    try {
      final uid = _sessionService.uid;

      if (uid == null) {
        _setValidationFailure(
          code: 'AUTHENTICATION_REQUIRED',
          message: 'You must be signed in to continue.',
        );

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
      _endOperation();
    }
  }

  // ─────────────────────────────────────────────
  // Password Reset
  // ─────────────────────────────────────────────

  Future<bool> resetPassword({required String email}) async {
    if (!_beginOperation(AuthOperation.passwordReset)) {
      return false;
    }

    try {
      if (email.trim().isEmpty) {
        _setValidationFailure(
          code: 'EMAIL_REQUIRED',
          message: 'Please enter your email address.',
        );

        return false;
      }

      final result = await _authRepository.resetPassword(email: email.trim());

      switch (result) {
        case Success<void>():
          _logger.info(
            'Password reset request submitted.',
            name: 'AuthController',
          );

          return true;

        case Failure<void>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _endOperation();
    }
  }

  // ─────────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────────

  Future<bool> logout() async {
    if (!_beginOperation(AuthOperation.logout)) {
      return false;
    }

    try {
      final result = await _authRepository.logout();

      switch (result) {
        case Success<void>():
          _logger.info('User signed out.', name: 'AuthController');

          return true;

        case Failure<void>(failure: final failure):
          _setFailure(failure);

          return false;
      }
    } finally {
      _endOperation();
    }
  }

  // ─────────────────────────────────────────────
  // Failure State
  // ─────────────────────────────────────────────

  void clearFailure() {
    _failure.value = null;
  }

  void _setFailure(AppFailure failure) {
    _failure.value = failure;

    _logger.warning(
      'Authentication operation failed: '
      '${failure.code}',
      error: failure.cause,
      stackTrace: failure.stackTrace,
      name: 'AuthController',
    );
  }

  void _setValidationFailure({required String code, required String message}) {
    _failure.value = AppFailure(
      code: code,
      message: message,
      type: FailureType.validation,
    );
  }

  // ─────────────────────────────────────────────
  // Operation State
  // ─────────────────────────────────────────────

  bool _beginOperation(AuthOperation operation) {
    if (isLoading) {
      return false;
    }

    _failure.value = null;
    _operation.value = operation;

    return true;
  }

  void _endOperation() {
    _operation.value = AuthOperation.none;
  }

  // ─────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────

  bool _validateCredentials({required String email, required String password}) {
    if (email.trim().isEmpty) {
      _setValidationFailure(
        code: 'EMAIL_REQUIRED',
        message: 'Please enter your email address.',
      );

      return false;
    }

    if (password.isEmpty) {
      _setValidationFailure(
        code: 'PASSWORD_REQUIRED',
        message: 'Please enter your password.',
      );

      return false;
    }

    return true;
  }

  bool _validateSignup({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (fullName.trim().isEmpty) {
      _setValidationFailure(
        code: 'FULL_NAME_REQUIRED',
        message: 'Please enter your full name.',
      );

      return false;
    }

    return _validateCredentials(email: email, password: password);
  }

  // ─────────────────────────────────────────────
  // Profile Helpers
  // ─────────────────────────────────────────────

  Future<void> _updateLastLoginBestEffort(String uid) async {
    final result = await _userProfileRepository.updateLastLogin(uid: uid);

    if (result case Failure<void>(failure: final failure)) {
      _logger.warning(
        'Unable to update last login timestamp.',
        error: failure.cause,
        stackTrace: failure.stackTrace,
        name: 'AuthController',
      );
    }
  }

  String _resolveGoogleDisplayName(AuthUserModel user) {
    final displayName = user.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final email = user.email.trim();

    if (email.contains('@')) {
      final localPart = email.split('@').first;

      if (localPart.isNotEmpty) {
        return localPart;
      }
    }

    return 'ProPersona User';
  }
}
