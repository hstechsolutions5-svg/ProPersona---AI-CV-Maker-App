import 'package:get/get.dart';

import '../../../core/errors/app_failure.dart';
import '../../resumes/controllers/resumes_controller.dart';
import '../../resumes/models/resume_model.dart';

enum ResumePreviewStatus {
  idle,
  loading,
  ready,
  error,
}

class ResumePreviewController extends GetxController {
  ResumePreviewController({
    required this._resumeController,
  });

  final ResumeController _resumeController;

  final Rx<ResumePreviewStatus> _status =
      ResumePreviewStatus.idle.obs;

  final Rxn<ResumeModel> _resume =
  Rxn<ResumeModel>();

  final Rxn<AppFailure> _failure =
  Rxn<AppFailure>();

  String? _resumeId;

  ResumePreviewStatus get status =>
      _status.value;

  ResumeModel? get resume =>
      _resume.value;

  AppFailure? get failure =>
      _failure.value;

  bool get isLoading =>
      status == ResumePreviewStatus.loading;

  bool get isReady =>
      status == ResumePreviewStatus.ready;

  bool get hasError =>
      status == ResumePreviewStatus.error;

  Future<void> initialize(
      String resumeId, {
        bool forceRefresh = false,
      }) async {
    final normalizedId =
    resumeId.trim();

    if (normalizedId.isEmpty) {
      _failure.value = const AppFailure(
        code: 'INVALID_RESUME_ID',
        message:
        'A valid resume identifier is required.',
        type: FailureType.validation,
      );

      _status.value =
          ResumePreviewStatus.error;

      return;
    }

    if (!forceRefresh &&
        _resumeId == normalizedId &&
        isReady) {
      return;
    }

    _resumeId = normalizedId;

    _status.value =
        ResumePreviewStatus.loading;

    _failure.value = null;

    final loadedResume =
    await _resumeController.openResume(
      resumeId: normalizedId,
      forceRefresh: forceRefresh,
    );

    if (loadedResume == null) {
      _failure.value =
          _resumeController.failure ??
              const AppFailure(
                code: 'RESUME_NOT_FOUND',
                message:
                'The requested resume could not be loaded.',
                type: FailureType.notFound,
              );

      _status.value =
          ResumePreviewStatus.error;

      return;
    }

    _resume.value =
        loadedResume;

    _status.value =
        ResumePreviewStatus.ready;
  }

  Future<void> refresh() async {
    final id = _resumeId;

    if (id == null) {
      return;
    }

    await initialize(
      id,
      forceRefresh: true,
    );
  }
}