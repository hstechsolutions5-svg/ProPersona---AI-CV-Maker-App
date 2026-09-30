import '../../core/result/result.dart';
import '../models/career_stage.dart';
import '../models/user_profile_model.dart';

abstract interface class UserProfileRepository {
  /// Creates the initial ProPersona profile
  /// after successful authentication signup.
  Future<Result<UserProfileModel>> createProfile({
    required UserProfileModel profile,
  });

  /// Returns the user's Firestore profile.
  ///
  /// Success(null) means the authenticated user
  /// exists in Firebase Authentication but no
  /// ProPersona profile exists yet.
  Future<Result<UserProfileModel?>> getProfile({required String uid});

  /// Updates the user's selected career stage.
  Future<Result<void>> updateCareerStage({
    required String uid,
    required CareerStage careerStage,
  });

  /// Completes onboarding and stores the selected
  /// career stage atomically.
  Future<Result<void>> completeOnboarding({
    required String uid,
    required CareerStage careerStage,
  });

  /// Updates the last successful login timestamp.
  Future<Result<void>> updateLastLogin({required String uid});

  Future<Result<void>> updateLegalConsent({
    required String uid,
    required String termsVersion,
    required String privacyVersion,
  });
}
