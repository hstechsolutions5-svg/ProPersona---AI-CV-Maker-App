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

  @override
  AuthUserModel? get currentUser {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return _mapUser(user);
  }

  @override
  Stream<AuthUserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
      (user) => user == null ? null : _mapUser(user),
    );
  }

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
              'The account was created, but the user session could not be loaded.',
          type: FailureType.authentication,
        );
      }

      return Success<AuthUserModel>(_mapUser(user));
    } catch (error, stackTrace) {
      return Failure<AuthUserModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

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
          message: 'The user session could not be loaded.',
          type: FailureType.authentication,
        );
      }

      return Success<AuthUserModel>(_mapUser(user));
    } catch (error, stackTrace) {
      return Failure<AuthUserModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<AuthUserModel>> signInWithGoogle() async {
    try {
      final UserCredential credential;

      if (kIsWeb) {
        credential = await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
      } else {
        if (!_supportsNativeGoogle) {
          throw const AppException(
            code: 'GOOGLE_SIGN_IN_UNSUPPORTED',
            message: 'Google Sign-In is not available on this platform.',
            type: FailureType.serviceUnavailable,
          );
        }

        await _ensureGoogleInitialized();

        final googleAccount = await _googleSignIn.authenticate();

        final authentication = googleAccount.authentication;

        final idToken = authentication.idToken;

        if (idToken == null || idToken.isEmpty) {
          throw const AppException(
            code: 'GOOGLE_ID_TOKEN_MISSING',
            message: 'Google authentication could not be completed.',
            type: FailureType.authentication,
          );
        }

        final googleCredential = GoogleAuthProvider.credential(
          idToken: idToken,
        );

        credential = await _firebaseAuth.signInWithCredential(googleCredential);
      }

      final user = credential.user;

      if (user == null) {
        throw const AppException(
          code: 'GOOGLE_USER_MISSING',
          message:
              'Google authentication completed, but the user session could not be loaded.',
          type: FailureType.authentication,
        );
      }

      return Success<AuthUserModel>(_mapUser(user));
    } on GoogleSignInException catch (error, stackTrace) {
      return Failure<AuthUserModel>(_mapGoogleException(error, stackTrace));
    } catch (error, stackTrace) {
      return Failure<AuthUserModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();

      if (!kIsWeb && _supportsNativeGoogle) {
        try {
          await _ensureGoogleInitialized();
          await _googleSignIn.signOut();
        } catch (_) {
          // Firebase logout remains
          // authoritative.
        }
      }

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  bool get _supportsNativeGoogle {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };
  }

  Future<void> _ensureGoogleInitialized() {
    return _googleInitialization ??= _googleSignIn.initialize();
  }

  AuthUserModel _mapUser(User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  AppFailure _mapGoogleException(
    GoogleSignInException error,
    StackTrace stackTrace,
  ) {
    return switch (error.code) {
      GoogleSignInExceptionCode.canceled => AppFailure(
        code: 'GOOGLE_SIGN_IN_CANCELLED',
        message: 'Google Sign-In was cancelled.',
        type: FailureType.cancelled,
        cause: error,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.clientConfigurationError => AppFailure(
        code: 'GOOGLE_CONFIGURATION_ERROR',
        message: 'Google Sign-In is not configured correctly.',
        type: FailureType.serviceUnavailable,
        cause: error,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.providerConfigurationError => AppFailure(
        code: 'GOOGLE_PROVIDER_ERROR',
        message: 'Google Sign-In is currently unavailable.',
        type: FailureType.serviceUnavailable,
        cause: error,
        stackTrace: stackTrace,
      ),

      GoogleSignInExceptionCode.interrupted => AppFailure(
        code: 'GOOGLE_SIGN_IN_INTERRUPTED',
        message: 'Google Sign-In was interrupted.',
        type: FailureType.authentication,
        cause: error,
        stackTrace: stackTrace,
      ),

      _ => AppFailure(
        code: 'GOOGLE_SIGN_IN_FAILED',
        message: 'Google Sign-In could not be completed.',
        type: FailureType.authentication,
        cause: error,
        stackTrace: stackTrace,
      ),
    };
  }
}
