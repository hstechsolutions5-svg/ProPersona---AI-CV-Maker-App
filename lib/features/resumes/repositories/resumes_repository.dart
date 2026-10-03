import '../../../core/result/result.dart';
import '../models/resume_model.dart';

abstract interface class ResumeRepository {
  Future<Result<ResumeModel>> createResume({required ResumeModel resume});

  Future<Result<List<ResumeModel>>> getUserResumes({required String ownerId});

  Future<Result<ResumeModel?>> getResume({
    required String resumeId,
    required String ownerId,
  });

  Future<Result<void>> updateResume({required ResumeModel resume});

  Future<Result<void>> deleteResume({
    required String resumeId,
    required String ownerId,
  });
}
