import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/firebase_error_mapper.dart';
import '../../../core/result/result.dart';
import '../models/auth_user_model.dart';
import 'authentication_repository.dart';

class FirebaseAuthenticationRepository implements AuthRepository {
  FirebaseAuthenticationRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void>? _googleInitialization;

  // ─────────────────────────────────────────────
  // Current User
  // ─────────────────────────────────────────────

  @override
  AuthUserModel? get currentUser {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return _mapUser(user);
  }

  // ─────────────────────────────────────────────
  // Authentication State
  // ─────────────────────────────────────────────

  @override
  Stream<AuthUserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return _mapUser(user);
    });
  }

  // ─────────────────────────────────────────────
  // Sign Up
  // ─────────────────────────────────────────────

  @override
  Future<Result<AuthUserModel>> signup({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AppException(
          code: 'AUTH_USER_MISSING',
          message:
              'Your account was created, but the user session could not be loaded.',
          type: FailureType.authentication,
        );
      }

      return Success<AuthUserModel>(_mapUser(user));
    } catch (error, stackTrace) {
      return Failure<AuthUserModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  // ─────────────────────────────────────────────
  // Login
  // ─────────────────────────────────────────────

  @override
  Future<Result<AuthUserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AppException(
          code: 'AUTH_USER_MISSING',
          message:
              'The account was authenticated, but the user session could not be loaded.',
          type: FailureType.authentication,
        );
      }

      return Success<AuthUserModel>(_mapUser(user));
    } catch (error, stackTrace) {
      return Failure<AuthUserModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  // ─────────────────────────────────────────────
  // Google Sign-In
  // ─────────────────────────────────────────────

  @override
  Future<Result<AuthUserModel>> signInWithGoogle() async {
    try {
      final UserCredential credential;

      if (kIsWeb) {
        credential = await _signInWithGoogleWeb();
      } else {
        credential = await _signInWithGoogleNative();
      }

      final user = credential.user;

      if (user == null) {
        throw const AppException(
          code: 'GOOGLE_AUTH_USER_MISSING',
          message:
              'Google sign-in completed, but the user session could not be loaded.',
          type: FailureType.authentication,
        );
      }

      return Success<AuthUserModel>(_mapUser(user));
    } on GoogleSignInException catch (error, stackTrace) {
      return Failure<AuthUserModel>(
        _mapGoogleSignInException(error, stackTrace),
      );
    } catch (error, stackTrace) {
      return Failure<AuthUserModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  // ─────────────────────────────────────────────
  // Password Reset
  // ─────────────────────────────────────────────

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  // ─────────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────────

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();

      if (_supportsNativeGoogleSignIn) {
        try {
          await _ensureGoogleInitialized();
          await _googleSignIn.signOut();
        } on GoogleSignInException {
          // Firebase has already signed out successfully.
          // Google provider cleanup should not prevent logout.
        }
      }

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  // ─────────────────────────────────────────────
  // Google — Web
  // ─────────────────────────────────────────────

  Future<UserCredential> _signInWithGoogleWeb() async {
    final provider = GoogleAuthProvider();

    return _firebaseAuth.signInWithPopup(provider);
  }

  // ─────────────────────────────────────────────
  // Google — Native
  // ─────────────────────────────────────────────

  Future<UserCredential> _signInWithGoogleNative() async {
    if (!_supportsNativeGoogleSignIn) {
      throw const AppException(
        code: 'GOOGLE_SIGN_IN_UNSUPPORTED',
        message: 'Google sign-in is not currently available on this platform.',
        type: FailureType.serviceUnavailable,
      );
    }

    await _ensureGoogleInitialized();

    final googleAccount = await _googleSignIn.authenticate();

    final googleAuthentication = googleAccount.authentication;

    final idToken = googleAuthentication.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw const AppException(
        code: 'GOOGLE_ID_TOKEN_MISSING',
        message:
            'Google authentication could not be completed. Please try again.',
        type: FailureType.authentication,
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    return _firebaseAuth.signInWithCredential(credential);
  }

  // ─────────────────────────────────────────────
  // Google Initialization
  // ─────────────────────────────────────────────

  Future<void> _ensureGoogleInitialized() {
    return _googleInitialization ??= _googleSignIn.initialize();
  }

  // ─────────────────────────────────────────────
  // Platform Support
  // ─────────────────────────────────────────────

  bool get _supportsNativeGoogleSignIn {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,

      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.fuchsia => false,
    };
  }

  // ─────────────────────────────────────────────
  // Firebase User Mapper
  // ─────────────────────────────────────────────

  AuthUserModel _mapUser(User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  // ─────────────────────────────────────────────
  // Google Error Mapper
  // ─────────────────────────────────────────────

  AppFailure _mapGoogleSignInException(
    GoogleSignInException exception,
    StackTrace stackTrace,
  ) {
    return switch (exception.code) {
      GoogleSignInExceptionCode.canceled => AppFailure(
        code: 'GOOGLE_SIGN_IN_CANCELLED',
        message: 'Google sign-in was cancelled.',
        type: FailureType.cancelled,
        cause: exception,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.interrupted => AppFailure(
        code: 'GOOGLE_SIGN_IN_INTERRUPTED',
        message: 'Google sign-in was interrupted. Please try again.',
        type: FailureType.authentication,
        cause: exception,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.clientConfigurationError => AppFailure(
        code: 'GOOGLE_CLIENT_CONFIGURATION_ERROR',
        message: 'Google sign-in is not configured correctly.',
        type: FailureType.serviceUnavailable,
        cause: exception,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.providerConfigurationError => AppFailure(
        code: 'GOOGLE_PROVIDER_CONFIGURATION_ERROR',
        message: 'Google sign-in is temporarily unavailable.',
        type: FailureType.serviceUnavailable,
        cause: exception,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.uiUnavailable => AppFailure(
        code: 'GOOGLE_SIGN_IN_UI_UNAVAILABLE',
        message: 'Google sign-in cannot be displayed right now.',
        type: FailureType.serviceUnavailable,
        cause: exception,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.userMismatch => AppFailure(
        code: 'GOOGLE_USER_MISMATCH',
        message:
            'A different Google account is currently active. Please try again.',
        type: FailureType.authentication,
        cause: exception,
        stackTrace: stackTrace,
      ),

      _ => AppFailure(
        code: 'GOOGLE_SIGN_IN_FAILED',
        message: 'Google sign-in could not be completed. Please try again.',
        type: FailureType.authentication,
        cause: exception,
        stackTrace: stackTrace,
      ),
    };
  }
}
