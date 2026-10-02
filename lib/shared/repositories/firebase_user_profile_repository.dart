import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/app_failure.dart';
import '../../core/errors/firebase_error_mapper.dart';
import '../../core/result/result.dart';
import '../models/career_stage.dart';
import '../models/user_profile_model.dart';
import 'user_profile_repository.dart';

class FirebaseUserProfileRepository implements UserProfileRepository {
  FirebaseUserProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestoreCollections.users);

  @override
  Future<Result<UserProfileModel>> createProfile({
    required UserProfileModel profile,
  }) async {
    try {
      _validateUid(profile.uid);

      final document = _users.doc(profile.uid);

      final existing = await document.get();

      if (existing.exists) {
        throw const AppException(
          code: 'PROFILE_ALREADY_EXISTS',
          message: 'A profile already exists for this account.',
          type: FailureType.conflict,
        );
      }

      await document.set(profile.toMap());

      return Success<UserProfileModel>(profile);
    } catch (error, stackTrace) {
      return Failure<UserProfileModel>(
        FirebaseErrorMapper.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<UserProfileModel?>> getProfile({required String uid}) async {
    try {
      _validateUid(uid);

      final document = await _users.doc(uid).get();

      if (!document.exists) {
        return const Success<UserProfileModel?>(null);
      }

      final data = document.data();

      if (data == null) {
        throw const AppException(
          code: 'PROFILE_DATA_MISSING',
          message: 'Your profile could not be loaded.',
          type: FailureType.notFound,
        );
      }

      return Success<UserProfileModel?>(UserProfileModel.fromMap(data));
    } catch (error, stackTrace) {
      return Failure<UserProfileModel?>(
        FirebaseErrorMapper.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> updateCareerStage({
    required String uid,
    required CareerStage careerStage,
  }) async {
    try {
      _validateUid(uid);

      await _users.doc(uid).update({
        'careerStage': careerStage.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> completeOnboarding({
    required String uid,
    required CareerStage careerStage,
  }) async {
    try {
      _validateUid(uid);

      await _users.doc(uid).update({
        'careerStage': careerStage.value,
        'onboardingCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> updateLastLogin({required String uid}) async {
    try {
      _validateUid(uid);

      await _users.doc(uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> updateLegalConsent({
    required String uid,
    required String termsVersion,
    required String privacyVersion,
  }) async {
    try {
      _validateUid(uid);

      await _users.doc(uid).update({
        'acceptedTermsVersion': termsVersion,
        'acceptedPrivacyVersion': privacyVersion,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
        'privacyAcceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  void _validateUid(String uid) {
    if (uid.trim().isEmpty) {
      throw const AppException(
        code: 'INVALID_USER_ID',
        message: 'A valid user account is required.',
        type: FailureType.validation,
      );
    }
  }
}
