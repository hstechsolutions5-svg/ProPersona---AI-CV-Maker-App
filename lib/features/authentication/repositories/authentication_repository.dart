import '../../../core/result/result.dart';
import '../models/auth_user_model.dart';

abstract interface class AuthRepository {
  AuthUserModel? get currentUser;

  Stream<AuthUserModel?> authStateChanges();

  Future<Result<AuthUserModel>> signup({
    required String email,
    required String password,
  });

  Future<Result<AuthUserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthUserModel>> signInWithGoogle();

  Future<Result<void>> resetPassword({required String email});

  Future<Result<void>> logout();
}
