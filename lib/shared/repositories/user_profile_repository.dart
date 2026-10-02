import '../../core/result/result.dart';
import '../models/career_stage.dart';
import '../models/user_profile_model.dart';

abstract interface class UserProfileRepository {
  Future<Result<UserProfileModel>> createProfile({
    required UserProfileModel profile,
  });

  Future<Result<UserProfileModel?>> getProfile({required String uid});

  Future<Result<void>> updateCareerStage({
    required String uid,
    required CareerStage careerStage,
  });

  Future<Result<void>> completeOnboarding({
    required String uid,
    required CareerStage careerStage,
  });

  Future<Result<void>> updateLastLogin({required String uid});

  Future<Result<void>> updateLegalConsent({
    required String uid,
    required String termsVersion,
    required String privacyVersion,
  });
}
