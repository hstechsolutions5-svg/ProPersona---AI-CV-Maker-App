import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_failure.dart';
import '../../resumes/controllers/resumes_controller.dart';
import '../../resumes/models/resume_certification_model.dart';
import '../../resumes/models/resume_education_model.dart';
import '../../resumes/models/resume_experience_model.dart';
import '../../resumes/models/resume_model.dart';
import '../../resumes/models/resume_personal_info_model.dart';
import '../../resumes/models/resume_project_model.dart';
import '../../resumes/models/resume_section_type.dart';
import '../models/resume_builder_status.dart';
import '../models/resume_save_status.dart';

class ResumeBuilderController extends GetxController {
  ResumeBuilderController({
    required this._resumeController,
    Uuid? uuid,
  })  : _uuid = uuid ?? const Uuid();

  static const Duration autosaveDelay =
  Duration(seconds: 2);

  final ResumeController _resumeController;
  final Uuid _uuid;

  final Rx<ResumeBuilderStatus> _status =
      ResumeBuilderStatus.idle.obs;

  final Rx<ResumeSaveStatus> _saveStatus =
      ResumeSaveStatus.clean.obs;

  final Rxn<ResumeModel> _workingResume =
  Rxn<ResumeModel>();

  final Rxn<ResumeSectionType> _selectedSection =
  Rxn<ResumeSectionType>();

  final Rxn<AppFailure> _failure =
  Rxn<AppFailure>();

  final Rxn<AppFailure> _saveFailure =
  Rxn<AppFailure>();

  final RxBool _isDirty = false.obs;

  final Rxn<DateTime> _lastSavedAt =
  Rxn<DateTime>();

  ResumeModel? _sourceResume;

  String? _resumeId;

  Timer? _autosaveTimer;

  Future<bool>? _activeSave;

  int _editRevision = 0;

  // ─────────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────────

  ResumeBuilderStatus get status =>
      _status.value;

  ResumeSaveStatus get saveStatus =>
      _saveStatus.value;

  ResumeModel? get workingResume =>
      _workingResume.value;

  ResumeSectionType? get selectedSection =>
      _selectedSection.value;

  AppFailure? get failure =>
      _failure.value;

  AppFailure? get saveFailure =>
      _saveFailure.value;

  bool get isDirty =>
      _isDirty.value;

  DateTime? get lastSavedAt =>
      _lastSavedAt.value;

  bool get isLoading =>
      status ==
          ResumeBuilderStatus.loading;

  bool get isReady =>
      status ==
          ResumeBuilderStatus.ready;

  bool get hasError =>
      status ==
          ResumeBuilderStatus.error;

  bool get isSaving =>
      saveStatus ==
          ResumeSaveStatus.saving;

  bool get hasSaveError =>
      saveStatus ==
          ResumeSaveStatus.error;

  bool get canSave =>
      isReady &&
          isDirty &&
          !isSaving;

  List<ResumeSectionType> get availableSections {
    final resume =
        workingResume;

    if (resume == null) {
      return const [];
    }

    return resume.sectionOrder
        .where(
      resume.isSectionEnabled,
    )
        .toList(
      growable: false,
    );
  }

  // ─────────────────────────────────────────
  // INITIALIZATION
  // ─────────────────────────────────────────

  Future<void> initialize(
      String resumeId, {
        bool forceRefresh = false,
      }) async {
    final normalizedId =
    resumeId.trim();

    if (normalizedId.isEmpty) {
      _failure.value =
      const AppFailure(
        code:
        'INVALID_RESUME_ID',
        message:
        'A valid resume identifier is required.',
        type:
        FailureType.validation,
      );

      _status.value =
          ResumeBuilderStatus.error;

      return;
    }

    if (!forceRefresh &&
        _resumeId ==
            normalizedId &&
        isReady) {
      return;
    }

    _cancelAutosave();

    _resumeId =
        normalizedId;

    _status.value =
        ResumeBuilderStatus.loading;

    _failure.value =
    null;

    _saveFailure.value =
    null;

    _isDirty.value =
    false;

    _saveStatus.value =
        ResumeSaveStatus.clean;

    _editRevision = 0;

    final resume =
    await _resumeController
        .openResume(
      resumeId:
      normalizedId,
      forceRefresh:
      forceRefresh,
    );

    if (resume == null) {
      _failure.value =
          _resumeController.failure ??
              const AppFailure(
                code:
                'RESUME_NOT_FOUND',
                message:
                'The requested resume could not be loaded.',
                type:
                FailureType.notFound,
              );

      _status.value =
          ResumeBuilderStatus.error;

      return;
    }

    _sourceResume =
        resume;

    _workingResume.value =
        resume;

    _selectedSection.value =
        _firstEnabledSection(
          resume,
        );

    _isDirty.value =
    false;

    _saveStatus.value =
        ResumeSaveStatus.clean;

    _status.value =
        ResumeBuilderStatus.ready;
  }

  Future<void> reload() async {
    final id = _resumeId;

    if (id == null) {
      return;
    }

    _cancelAutosave();

    await initialize(
      id,
      forceRefresh: true,
    );
  }

  // ─────────────────────────────────────────
  // SECTION SELECTION
  // ─────────────────────────────────────────

  void selectSection(
      ResumeSectionType section,
      ) {
    final resume =
        workingResume;

    if (resume == null ||
        !resume.isSectionEnabled(
          section,
        )) {
      return;
    }

    _selectedSection.value =
        section;
  }

  // ─────────────────────────────────────────
  // LOCAL EDITING
  // ─────────────────────────────────────────

  void updateWorkingResume(
      ResumeModel Function(
          ResumeModel current,
          ) update,
      ) {
    final current =
        workingResume;

    if (current == null) {
      return;
    }

    final next =
    update(current);

    if (next.id !=
        current.id ||
        next.ownerId !=
            current.ownerId) {
      throw StateError(
        'Resume identity and ownership cannot be changed by the builder.',
      );
    }

    _workingResume.value =
        next;

    _editRevision++;

    _isDirty.value =
    true;

    _saveStatus.value =
        ResumeSaveStatus.dirty;

    _saveFailure.value =
    null;

    _ensureSelectedSection(
      next,
    );

    _scheduleAutosave();
  }

  // ─────────────────────────────────────────
  // SAVE
  // ─────────────────────────────────────────

  Future<bool> saveNow() async {
    _cancelAutosave();

    if (!isReady) {
      return false;
    }

    if (!isDirty) {
      return true;
    }

    //
    // If another write is currently in progress,
    // wait for it before deciding whether another
    // save is required.
    //
    final existingSave =
        _activeSave;

    if (existingSave !=
        null) {
      await existingSave;

      if (!isDirty) {
        return true;
      }

      return saveNow();
    }

    final saveFuture =
    _performSave();

    _activeSave =
        saveFuture;

    try {
      return await saveFuture;
    } finally {
      _activeSave =
      null;
    }
  }

  Future<bool> _performSave() async {
    final snapshot =
        workingResume;

    if (snapshot == null) {
      return false;
    }

    final revisionAtStart =
        _editRevision;

    _saveStatus.value =
        ResumeSaveStatus.saving;

    _saveFailure.value =
    null;

    final success =
    await _resumeController
        .updateResume(
      snapshot,
    );

    if (!success) {
      _saveFailure.value =
          _resumeController.failure ??
              const AppFailure(
                code:
                'RESUME_SAVE_FAILED',
                message:
                'Your resume could not be saved.',
                type:
                FailureType.firebase,
              );

      _saveStatus.value =
          ResumeSaveStatus.error;

      _isDirty.value =
      true;

      return false;
    }

    //
    // ResumeController maintains the canonical
    // local version after a successful update.
    //
    final persisted =
        _resumeController
            .findResume(
          snapshot.id,
        ) ??
            snapshot;

    _sourceResume =
        persisted;

    _lastSavedAt.value =
        DateTime.now();

    //
    // Critical race protection:
    //
    // If the user edited something while this
    // Firestore request was running, do NOT
    // replace the newer working copy with the
    // older saved snapshot.
    //
    if (_editRevision ==
        revisionAtStart) {
      _workingResume.value =
          persisted;

      _isDirty.value =
      false;

      _saveStatus.value =
          ResumeSaveStatus.saved;

      return true;
    }

    //
    // Newer local edits exist.
    //
    // Keep them intact and queue another
    // debounced save.
    //
    _isDirty.value =
    true;

    _saveStatus.value =
        ResumeSaveStatus.dirty;

    _scheduleAutosave();

    return true;
  }

  Future<bool>
  saveBeforeExit() async {
    if (!isDirty) {
      return true;
    }

    return saveNow();
  }

  void retrySave() {
    if (!isDirty ||
        isSaving) {
      return;
    }

    unawaited(
      saveNow(),
    );
  }

  void _scheduleAutosave() {
    _cancelAutosave();

    _autosaveTimer =
        Timer(
          autosaveDelay,
              () {
            if (!isDirty ||
                isSaving) {
              return;
            }

            unawaited(
              saveNow(),
            );
          },
        );
  }

  void _cancelAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = null;
  }

  // ─────────────────────────────────────────
  // RESET / DISCARD
  // ─────────────────────────────────────────

  void resetWorkingCopy() {
    final source =
        _sourceResume;

    if (source == null) {
      return;
    }

    _cancelAutosave();

    _workingResume.value =
        source;

    _selectedSection.value =
        _firstEnabledSection(
          source,
        );

    _editRevision++;

    _isDirty.value =
    false;

    _saveFailure.value =
    null;

    _saveStatus.value =
        ResumeSaveStatus.clean;
  }

  void discardChanges() {
    resetWorkingCopy();
  }

  // ─────────────────────────────────────────
  // PERSONAL INFORMATION
  // ─────────────────────────────────────────

  void updatePersonalInfo(
      ResumePersonalInfoModel personalInfo,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            personalInfo:
            personalInfo,
          ),
    );
  }

  // ─────────────────────────────────────────
  // PROFESSIONAL SUMMARY
  // ─────────────────────────────────────────

  void updateProfessionalSummary(
      String summary,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            professionalSummary:
            summary,
          ),
    );
  }

  // ─────────────────────────────────────────
  // EDUCATION
  // ─────────────────────────────────────────

  void addEducation() {
    final education =
    ResumeEducationModel(
      id: _uuid.v4(),
      institution: '',
      degree: '',
      fieldOfStudy: '',
      location: '',
      startDate: null,
      endDate: null,
      isCurrent: false,
      grade: '',
      description: '',
    );

    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            education: [
              ...resume.education,
              education,
            ],
          ),
    );
  }

  void updateEducation(
      ResumeEducationModel education,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            education:
            resume.education
                .map(
                  (item) =>
              item.id ==
                  education.id
                  ? education
                  : item,
            )
                .toList(),
          ),
    );
  }

  void removeEducation(
      String educationId,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            education:
            resume.education
                .where(
                  (item) =>
              item.id !=
                  educationId,
            )
                .toList(),
          ),
    );
  }

  // ─────────────────────────────────────────
  // EXPERIENCE
  // ─────────────────────────────────────────

  void addExperience() {
    final experience =
    ResumeExperienceModel(
      id: _uuid.v4(),
      company: '',
      jobTitle: '',
      location: '',
      startDate: null,
      endDate: null,
      isCurrent: false,
      bullets: const [],
    );

    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            experience: [
              ...resume.experience,
              experience,
            ],
          ),
    );
  }

  void updateExperience(
      ResumeExperienceModel experience,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            experience:
            resume.experience
                .map(
                  (item) =>
              item.id ==
                  experience.id
                  ? experience
                  : item,
            )
                .toList(),
          ),
    );
  }

  void removeExperience(
      String experienceId,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            experience:
            resume.experience
                .where(
                  (item) =>
              item.id !=
                  experienceId,
            )
                .toList(),
          ),
    );
  }

  // ─────────────────────────────────────────
  // PROJECTS
  // ─────────────────────────────────────────

  void addProject() {
    final project =
    ResumeProjectModel(
      id: _uuid.v4(),
      name: '',
      role: '',
      description: '',
      technologies:
      const [],
      bullets:
      const [],
      projectUrl: '',
      repositoryUrl: '',
      startDate: null,
      endDate: null,
    );

    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            projects: [
              ...resume.projects,
              project,
            ],
          ),
    );
  }

  void updateProject(
      ResumeProjectModel project,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            projects:
            resume.projects
                .map(
                  (item) =>
              item.id ==
                  project.id
                  ? project
                  : item,
            )
                .toList(),
          ),
    );
  }

  void removeProject(
      String projectId,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            projects:
            resume.projects
                .where(
                  (item) =>
              item.id !=
                  projectId,
            )
                .toList(),
          ),
    );
  }

  // ─────────────────────────────────────────
  // SKILLS
  // ─────────────────────────────────────────

  void addSkill(
      String value,
      ) {
    final skill =
    value.trim();

    if (skill.isEmpty) {
      return;
    }

    final exists =
        workingResume
            ?.skills
            .any(
              (existing) =>
          existing
              .toLowerCase() ==
              skill
                  .toLowerCase(),
        ) ??
            false;

    if (exists) {
      return;
    }

    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            skills: [
              ...resume.skills,
              skill,
            ],
          ),
    );
  }

  void removeSkill(
      String skill,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            skills:
            resume.skills
                .where(
                  (item) =>
              item != skill,
            )
                .toList(),
          ),
    );
  }

  // ─────────────────────────────────────────
  // CERTIFICATIONS
  // ─────────────────────────────────────────

  void addCertification() {
    final certification =
    ResumeCertificationModel(
      id: _uuid.v4(),
      name: '',
      issuer: '',
      issueDate: null,
      expiryDate: null,
      credentialId: '',
      credentialUrl: '',
    );

    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            certifications: [
              ...resume.certifications,
              certification,
            ],
          ),
    );
  }

  void updateCertification(
      ResumeCertificationModel certification,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            certifications:
            resume.certifications
                .map(
                  (item) =>
              item.id ==
                  certification.id
                  ? certification
                  : item,
            )
                .toList(),
          ),
    );
  }

  void removeCertification(
      String certificationId,
      ) {
    updateWorkingResume(
          (resume) =>
          resume.copyWith(
            certifications:
            resume.certifications
                .where(
                  (item) =>
              item.id !=
                  certificationId,
            )
                .toList(),
          ),
    );
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  ResumeSectionType?
  _firstEnabledSection(
      ResumeModel resume,
      ) {
    for (final section
    in resume.sectionOrder) {
      if (resume.isSectionEnabled(
        section,
      )) {
        return section;
      }
    }

    return null;
  }

  void _ensureSelectedSection(
      ResumeModel resume,
      ) {
    final selected =
        _selectedSection.value;

    if (selected != null &&
        resume.isSectionEnabled(
          selected,
        )) {
      return;
    }

    _selectedSection.value =
        _firstEnabledSection(
          resume,
        );
  }

  @override
  void onClose() {
    _cancelAutosave();

    super.onClose();
  }
}