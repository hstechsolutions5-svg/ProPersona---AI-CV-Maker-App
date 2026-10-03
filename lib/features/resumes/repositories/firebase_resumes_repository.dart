import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_persona/features/resumes/repositories/resumes_repository.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/firebase_error_mapper.dart';
import '../../../core/result/result.dart';
import '../models/resume_model.dart';

class FirebaseResumeRepository implements ResumeRepository {
  FirebaseResumeRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _resumes {
    return _firestore.collection(FirestoreCollections.resumes);
  }

  @override
  Future<Result<ResumeModel>> createResume({
    required ResumeModel resume,
  }) async {
    try {
      _validateResumeForWrite(resume);

      final document = _resumes.doc(resume.id);

      final data = Map<String, dynamic>.from(resume.toMap());

      data['createdAt'] = FieldValue.serverTimestamp();

      data['updatedAt'] = FieldValue.serverTimestamp();

      await document.set(data);

      return Success<ResumeModel>(resume);
    } catch (error, stackTrace) {
      return Failure<ResumeModel>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<List<ResumeModel>>> getUserResumes({
    required String ownerId,
  }) async {
    try {
      _validateOwnerId(ownerId);

      final snapshot = await _resumes
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final resumes = <ResumeModel>[];

      for (final document in snapshot.docs) {
        final resume = _resumeFromDocument(document);

        if (resume.ownerId != ownerId) {
          throw const AppException(
            code: 'RESUME_OWNER_MISMATCH',
            message: 'Resume ownership could not be verified.',
            type: FailureType.authorization,
          );
        }

        resumes.add(resume);
      }

      resumes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return Success<List<ResumeModel>>(resumes);
    } catch (error, stackTrace) {
      return Failure<List<ResumeModel>>(
        FirebaseErrorMapper.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<ResumeModel?>> getResume({
    required String resumeId,
    required String ownerId,
  }) async {
    try {
      _validateResumeId(resumeId);

      _validateOwnerId(ownerId);

      final document = await _resumes.doc(resumeId).get();

      if (!document.exists) {
        return const Success<ResumeModel?>(null);
      }

      final resume = _resumeFromDocument(document);

      if (resume.ownerId != ownerId) {
        throw const AppException(
          code: 'RESUME_ACCESS_DENIED',
          message: 'You do not have permission to access this resume.',
          type: FailureType.authorization,
        );
      }

      return Success<ResumeModel?>(resume);
    } catch (error, stackTrace) {
      return Failure<ResumeModel?>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> updateResume({required ResumeModel resume}) async {
    try {
      _validateResumeForWrite(resume);

      final data = Map<String, dynamic>.from(resume.toMap());

      // These fields are immutable.
      data.remove('id');
      data.remove('ownerId');
      data.remove('createdAt');

      data['updatedAt'] = FieldValue.serverTimestamp();

      await _resumes.doc(resume.id).update(data);

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> deleteResume({
    required String resumeId,
    required String ownerId,
  }) async {
    try {
      _validateResumeId(resumeId);

      _validateOwnerId(ownerId);

      await _resumes.doc(resumeId).delete();

      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(FirebaseErrorMapper.map(error, stackTrace));
    }
  }

  ResumeModel _resumeFromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw const AppException(
        code: 'RESUME_DATA_MISSING',
        message: 'The resume data could not be loaded.',
        type: FailureType.notFound,
      );
    }

    final resume = ResumeModel.fromMap(data);

    if (resume.id.isEmpty) {
      throw const AppException(
        code: 'RESUME_ID_MISSING',
        message: 'The resume contains invalid data.',
        type: FailureType.firebase,
      );
    }

    if (resume.id != document.id) {
      throw const AppException(
        code: 'RESUME_ID_MISMATCH',
        message: 'The resume contains inconsistent data.',
        type: FailureType.firebase,
      );
    }

    if (resume.ownerId.trim().isEmpty) {
      throw const AppException(
        code: 'RESUME_OWNER_MISSING',
        message: 'The resume contains invalid ownership data.',
        type: FailureType.firebase,
      );
    }

    return resume;
  }

  void _validateResumeForWrite(ResumeModel resume) {
    _validateResumeId(resume.id);

    _validateOwnerId(resume.ownerId);

    if (resume.title.trim().isEmpty) {
      throw const AppException(
        code: 'RESUME_TITLE_REQUIRED',
        message: 'A resume title is required.',
        type: FailureType.validation,
      );
    }

    if (resume.sectionOrder.isEmpty) {
      throw const AppException(
        code: 'RESUME_SECTION_ORDER_REQUIRED',
        message: 'The resume must contain a valid section order.',
        type: FailureType.validation,
      );
    }
  }

  void _validateResumeId(String resumeId) {
    if (resumeId.trim().isEmpty) {
      throw const AppException(
        code: 'INVALID_RESUME_ID',
        message: 'A valid resume identifier is required.',
        type: FailureType.validation,
      );
    }
  }

  void _validateOwnerId(String ownerId) {
    if (ownerId.trim().isEmpty) {
      throw const AppException(
        code: 'INVALID_RESUME_OWNER',
        message: 'A valid user account is required.',
        type: FailureType.validation,
      );
    }
  }
}
