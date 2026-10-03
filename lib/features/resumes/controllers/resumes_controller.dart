import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../../../core/services/logger_service.dart';
import '../../authentication/services/session_service.dart';
import '../models/resume_model.dart';
import '../models/resume_operations.dart';
import '../models/resume_personal_info_model.dart';
import '../repositories/resumes_repository.dart';

class ResumeController extends GetxController {
  ResumeController({
    required this._resumeRepository,
    required this._sessionService,
    required this._logger,
    Uuid? uuid,
  }) : _uuid = uuid ?? Uuid();

  final ResumeRepository _resumeRepository;
  final SessionService _sessionService;
  final LoggerService _logger;
  final Uuid _uuid;

  final RxList<ResumeModel> _resumes = <ResumeModel>[].obs;

  final Rxn<ResumeModel> _selectedResume = Rxn<ResumeModel>();

  final Rx<ResumeOperation> _operation = ResumeOperation.none.obs;

  final Rxn<AppFailure> _failure = Rxn<AppFailure>();

  final RxBool _hasLoadedResumes = false.obs;

  String? _loadedOwnerId;

  // ─────────────────────────────────────────
  // STATE
  // ─────────────────────────────────────────

  List<ResumeModel> get resumes => _resumes.toList(growable: false);

  RxList<ResumeModel> get observableResumes => _resumes;

  ResumeModel? get selectedResume => _selectedResume.value;

  ResumeOperation get operation => _operation.value;

  AppFailure? get failure => _failure.value;

  bool get hasLoadedResumes => _hasLoadedResumes.value;

  int get resumeCount => _resumes.length;

  bool get hasResumes => _resumes.isNotEmpty;

  bool get isBusy => operation != ResumeOperation.none;

  bool get isLoadingResumes => operation == ResumeOperation.loading;

  bool get isOpeningResume => operation == ResumeOperation.opening;

  bool get isCreating => operation == ResumeOperation.creating;

  bool get isUpdating => operation == ResumeOperation.updating;

  bool get isDeleting => operation == ResumeOperation.deleting;

  // ─────────────────────────────────────────
  // LOAD ALL
  // ─────────────────────────────────────────

  Future<bool> loadResumes({bool force = false}) async {
    if (isBusy) {
      return false;
    }

    final uid = _sessionService.uid;

    if (uid == null || uid.trim().isEmpty) {
      _setFailure(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'You must be signed in to load your resumes.',
        type: FailureType.authentication,
      );

      return false;
    }

    _synchronizeOwner(uid);

    if (hasLoadedResumes && !force) {
      return true;
    }

    if (!_begin(ResumeOperation.loading)) {
      return false;
    }

    try {
      final result = await _resumeRepository.getUserResumes(ownerId: uid);

      switch (result) {
        case Success<List<ResumeModel>>(data: final resumes):
          _resumes.assignAll(resumes);

          _sortResumes();

          _hasLoadedResumes.value = true;

          _loadedOwnerId = uid;

          _logger.info(
            'User resumes loaded successfully.',
            name: 'ResumeController',
          );

          return true;

        case Failure<List<ResumeModel>>(failure: final failure):
          _failure.value = failure;

          _logger.warning(
            'Unable to load resumes.',
            error: failure.cause,
            stackTrace: failure.stackTrace,
            name: 'ResumeController',
          );

          return false;
      }
    } finally {
      _end();
    }
  }

  Future<bool> refreshResumes() {
    return loadResumes(force: true);
  }

  // ─────────────────────────────────────────
  // OPEN ONE
  // ─────────────────────────────────────────

  Future<ResumeModel?> openResume({
    required String resumeId,
    bool forceRefresh = false,
  }) async {
    if (isBusy) {
      return null;
    }

    final normalizedId = resumeId.trim();

    if (normalizedId.isEmpty) {
      _setFailure(
        code: 'INVALID_RESUME_ID',
        message: 'A valid resume identifier is required.',
        type: FailureType.validation,
      );

      return null;
    }

    final uid = _sessionService.uid;

    if (uid == null || uid.trim().isEmpty) {
      _setFailure(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'You must be signed in to access this resume.',
        type: FailureType.authentication,
      );

      return null;
    }

    _synchronizeOwner(uid);

    if (!forceRefresh) {
      final cached = _findResume(normalizedId);

      if (cached != null) {
        _selectedResume.value = cached;

        return cached;
      }
    }

    if (!_begin(ResumeOperation.opening)) {
      return null;
    }

    try {
      final result = await _resumeRepository.getResume(
        resumeId: normalizedId,
        ownerId: uid,
      );

      switch (result) {
        case Success<ResumeModel?>(data: final resume):
          if (resume == null) {
            _setFailure(
              code: 'RESUME_NOT_FOUND',
              message: 'The requested resume could not be found.',
              type: FailureType.notFound,
            );

            return null;
          }

          _selectedResume.value = resume;

          _upsertLocalResume(resume);

          return resume;

        case Failure<ResumeModel?>(failure: final failure):
          _failure.value = failure;

          _logger.warning(
            'Unable to open resume.',
            error: failure.cause,
            stackTrace: failure.stackTrace,
            name: 'ResumeController',
          );

          return null;
      }
    } finally {
      _end();
    }
  }

  // ─────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────

  Future<ResumeModel?> createResume({
    required String title,
    String? targetRole,
  }) async {
    if (isBusy) {
      return null;
    }

    final normalizedTitle = title.trim();

    if (normalizedTitle.isEmpty) {
      _setFailure(
        code: 'RESUME_TITLE_REQUIRED',
        message: 'Please enter a resume title.',
        type: FailureType.validation,
      );

      return null;
    }

    final uid = _sessionService.uid;

    final profile = _sessionService.profile;

    if (uid == null || uid.trim().isEmpty) {
      _setFailure(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'You must be signed in to create a resume.',
        type: FailureType.authentication,
      );

      return null;
    }

    if (profile == null) {
      _setFailure(
        code: 'PROFILE_REQUIRED',
        message: 'Your profile could not be loaded.',
        type: FailureType.validation,
      );

      return null;
    }

    final careerStage = profile.careerStage;

    if (careerStage == null) {
      _setFailure(
        code: 'CAREER_STAGE_REQUIRED',
        message:
            'Please complete your career profile before creating a resume.',
        type: FailureType.validation,
      );

      return null;
    }

    _synchronizeOwner(uid);

    if (!_begin(ResumeOperation.creating)) {
      return null;
    }

    try {
      final resume = ResumeModel.newDraft(
        id: _uuid.v4(),
        ownerId: uid,
        title: normalizedTitle,
        targetRole: targetRole,
        careerStage: careerStage,
        personalInfo: ResumePersonalInfoModel(
          fullName: profile.fullName,
          email: profile.email,
        ),
      );

      final result = await _resumeRepository.createResume(resume: resume);

      switch (result) {
        case Success<ResumeModel>(data: final createdResume):
          _upsertLocalResume(createdResume);

          _selectedResume.value = createdResume;

          _hasLoadedResumes.value = true;

          _logger.info(
            'Resume created successfully.',
            name: 'ResumeController',
          );

          return createdResume;

        case Failure<ResumeModel>(failure: final failure):
          _failure.value = failure;

          _logger.warning(
            'Unable to create resume.',
            error: failure.cause,
            stackTrace: failure.stackTrace,
            name: 'ResumeController',
          );

          return null;
      }
    } finally {
      _end();
    }
  }

  // ─────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────

  Future<bool> updateResume(ResumeModel resume) async {
    if (isBusy) {
      return false;
    }

    final uid = _sessionService.uid;

    if (uid == null || uid.trim().isEmpty) {
      _setFailure(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'You must be signed in to update this resume.',
        type: FailureType.authentication,
      );

      return false;
    }

    if (resume.ownerId != uid) {
      _setFailure(
        code: 'RESUME_ACCESS_DENIED',
        message: 'You do not have permission to update this resume.',
        type: FailureType.authorization,
      );

      return false;
    }

    if (resume.title.trim().isEmpty) {
      _setFailure(
        code: 'RESUME_TITLE_REQUIRED',
        message: 'A resume title is required.',
        type: FailureType.validation,
      );

      return false;
    }

    _synchronizeOwner(uid);

    if (!_begin(ResumeOperation.updating)) {
      return false;
    }

    try {
      final updatedResume = resume.copyWith(updatedAt: DateTime.now().toUtc());

      final result = await _resumeRepository.updateResume(
        resume: updatedResume,
      );

      switch (result) {
        case Success<void>():
          _upsertLocalResume(updatedResume);

          if (_selectedResume.value?.id == updatedResume.id) {
            _selectedResume.value = updatedResume;
          }

          _logger.info(
            'Resume updated successfully.',
            name: 'ResumeController',
          );

          return true;

        case Failure<void>(failure: final failure):
          _failure.value = failure;

          _logger.warning(
            'Unable to update resume.',
            error: failure.cause,
            stackTrace: failure.stackTrace,
            name: 'ResumeController',
          );

          return false;
      }
    } finally {
      _end();
    }
  }

  // ─────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────

  Future<bool> deleteResume({required String resumeId}) async {
    if (isBusy) {
      return false;
    }

    final normalizedId = resumeId.trim();

    if (normalizedId.isEmpty) {
      _setFailure(
        code: 'INVALID_RESUME_ID',
        message: 'A valid resume identifier is required.',
        type: FailureType.validation,
      );

      return false;
    }

    final uid = _sessionService.uid;

    if (uid == null || uid.trim().isEmpty) {
      _setFailure(
        code: 'AUTHENTICATION_REQUIRED',
        message: 'You must be signed in to delete this resume.',
        type: FailureType.authentication,
      );

      return false;
    }

    _synchronizeOwner(uid);

    final localResume = _findResume(normalizedId);

    if (localResume != null && localResume.ownerId != uid) {
      _setFailure(
        code: 'RESUME_ACCESS_DENIED',
        message: 'You do not have permission to delete this resume.',
        type: FailureType.authorization,
      );

      return false;
    }

    if (!_begin(ResumeOperation.deleting)) {
      return false;
    }

    try {
      final result = await _resumeRepository.deleteResume(
        resumeId: normalizedId,
        ownerId: uid,
      );

      switch (result) {
        case Success<void>():
          _resumes.removeWhere((resume) => resume.id == normalizedId);

          if (_selectedResume.value?.id == normalizedId) {
            _selectedResume.value = null;
          }

          _logger.info(
            'Resume deleted successfully.',
            name: 'ResumeController',
          );

          return true;

        case Failure<void>(failure: final failure):
          _failure.value = failure;

          _logger.warning(
            'Unable to delete resume.',
            error: failure.cause,
            stackTrace: failure.stackTrace,
            name: 'ResumeController',
          );

          return false;
      }
    } finally {
      _end();
    }
  }

  // ─────────────────────────────────────────
  // LOCAL STATE
  // ─────────────────────────────────────────

  void selectResume(ResumeModel resume) {
    _selectedResume.value = resume;
  }

  void clearSelectedResume() {
    _selectedResume.value = null;
  }

  void clearFailure() {
    _failure.value = null;
  }

  ResumeModel? findResume(String resumeId) {
    return _findResume(resumeId);
  }

  ResumeModel? _findResume(String resumeId) {
    for (final resume in _resumes) {
      if (resume.id == resumeId) {
        return resume;
      }
    }

    return null;
  }

  void _upsertLocalResume(ResumeModel resume) {
    final index = _resumes.indexWhere((item) => item.id == resume.id);

    if (index == -1) {
      _resumes.add(resume);
    } else {
      _resumes[index] = resume;
    }

    _sortResumes();
  }

  void _sortResumes() {
    _resumes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // ─────────────────────────────────────────
  // OWNER / SESSION SAFETY
  // ─────────────────────────────────────────

  void _synchronizeOwner(String ownerId) {
    if (_loadedOwnerId == null) {
      _loadedOwnerId = ownerId;

      return;
    }

    if (_loadedOwnerId == ownerId) {
      return;
    }

    //
    // Prevent account A's local resume state
    // from leaking into account B's session.
    //
    _resumes.clear();
    _selectedResume.value = null;
    _failure.value = null;
    _hasLoadedResumes.value = false;

    _loadedOwnerId = ownerId;
  }

  // ─────────────────────────────────────────
  // OPERATION / FAILURE
  // ─────────────────────────────────────────

  bool _begin(ResumeOperation operation) {
    if (isBusy) {
      return false;
    }

    _failure.value = null;

    _operation.value = operation;

    return true;
  }

  void _end() {
    _operation.value = ResumeOperation.none;
  }

  void _setFailure({
    required String code,
    required String message,
    required FailureType type,
  }) {
    _failure.value = AppFailure(code: code, message: message, type: type);
  }
}
