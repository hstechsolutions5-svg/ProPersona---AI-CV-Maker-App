import '../../../core/result/result.dart';
import '../models/auth_user_model.dart';

abstract interface class AuthRepository {
  /// Returns the currently authenticated user.
  ///
  /// Returns null when there is no active Firebase
  /// Authentication session.
  AuthUserModel? get currentUser;

  /// Emits authentication state changes.
  ///
  /// Example:
  ///
  /// signed out
  ///   -> null
  ///
  /// signed in
  ///   -> AuthUserModel
  Stream<AuthUserModel?> authStateChanges();

  /// Creates a new account using email and password.
  Future<Result<AuthUserModel>> signup({
    required String email,
    required String password,
  });

  /// Authenticates an existing user using email
  /// and password.
  Future<Result<AuthUserModel>> login({
    required String email,
    required String password,
  });

  /// Authenticates using Google.
  Future<Result<AuthUserModel>> signInWithGoogle();

  /// Sends a password-reset email.
  Future<Result<void>> resetPassword({required String email});

  /// Signs out the current user.
  Future<Result<void>> logout();
}
