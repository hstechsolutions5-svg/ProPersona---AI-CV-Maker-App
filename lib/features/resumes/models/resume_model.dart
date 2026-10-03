import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/career_stage.dart';
import 'resume_certification_model.dart';
import 'resume_education_model.dart';
import 'resume_experience_model.dart';
import 'resume_personal_info_model.dart';
import 'resume_project_model.dart';
import 'resume_section_type.dart';

const Object _unsetResume = Object();

class ResumeModel {
  const ResumeModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.careerStage,
    required this.personalInfo,
    required this.sectionOrder,
    required this.createdAt,
    required this.updatedAt,
    this.targetRole,
    this.templateId = 'classic',
    this.professionalSummary = '',
    this.education = const <ResumeEducationModel>[],
    this.experience = const <ResumeExperienceModel>[],
    this.projects = const <ResumeProjectModel>[],
    this.skills = const <String>[],
    this.certifications = const <ResumeCertificationModel>[],
    this.disabledSections = const <ResumeSectionType>[],
    this.schemaVersion = 1,
  });

  final String id;
  final String ownerId;

  final String title;
  final String? targetRole;

  final CareerStage careerStage;

  final String templateId;

  final ResumePersonalInfoModel personalInfo;

  final String professionalSummary;

  final List<ResumeEducationModel> education;

  final List<ResumeExperienceModel> experience;

  final List<ResumeProjectModel> projects;

  final List<String> skills;

  final List<ResumeCertificationModel> certifications;

  final List<ResumeSectionType> sectionOrder;

  final List<ResumeSectionType> disabledSections;

  final int schemaVersion;

  final DateTime createdAt;
  final DateTime updatedAt;

  factory ResumeModel.newDraft({
    required String id,
    required String ownerId,
    required String title,
    required CareerStage careerStage,
    String? targetRole,
    ResumePersonalInfoModel? personalInfo,
    String templateId = 'classic',
  }) {
    final now = DateTime.now().toUtc();

    return ResumeModel(
      id: id,
      ownerId: ownerId,
      title: title.trim(),
      targetRole: _normalizedNullable(targetRole),
      careerStage: careerStage,
      templateId: templateId,
      personalInfo: personalInfo ?? const ResumePersonalInfoModel(),
      sectionOrder: ResumeSectionType.defaultOrderFor(careerStage),
      createdAt: now,
      updatedAt: now,
    );
  }

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    final careerStage = CareerStage.fromString(map['careerStage'] as String?);

    if (careerStage == null) {
      throw const FormatException('Invalid resume careerStage.');
    }

    final storedOrder = (map['sectionOrder'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .map(ResumeSectionType.fromString)
        .whereType<ResumeSectionType>()
        .toList();

    final storedDisabled =
        (map['disabledSections'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .map(ResumeSectionType.fromString)
            .whereType<ResumeSectionType>()
            .toList();

    return ResumeModel(
      id: map['id'] as String? ?? '',
      ownerId: map['ownerId'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Resume',
      targetRole: map['targetRole'] as String?,
      careerStage: careerStage,
      templateId: map['templateId'] as String? ?? 'classic',
      personalInfo: ResumePersonalInfoModel.fromMap(
        _mapFromDynamic(map['personalInfo']),
      ),
      professionalSummary: map['professionalSummary'] as String? ?? '',
      education: _listOfMaps(
        map['education'],
      ).map(ResumeEducationModel.fromMap).toList(),
      experience: _listOfMaps(
        map['experience'],
      ).map(ResumeExperienceModel.fromMap).toList(),
      projects: _listOfMaps(
        map['projects'],
      ).map(ResumeProjectModel.fromMap).toList(),
      skills: List<String>.from(map['skills'] as List<dynamic>? ?? const []),
      certifications: _listOfMaps(
        map['certifications'],
      ).map(ResumeCertificationModel.fromMap).toList(),
      sectionOrder: storedOrder.isEmpty
          ? ResumeSectionType.defaultOrderFor(careerStage)
          : storedOrder,
      disabledSections: storedDisabled,
      schemaVersion: map['schemaVersion'] as int? ?? 1,
      createdAt: _requiredDate(map['createdAt']),
      updatedAt: _requiredDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'title': title,
      'targetRole': targetRole,
      'careerStage': careerStage.value,
      'templateId': templateId,
      'personalInfo': personalInfo.toMap(),
      'professionalSummary': professionalSummary,
      'education': education.map((item) => item.toMap()).toList(),
      'experience': experience.map((item) => item.toMap()).toList(),
      'projects': projects.map((item) => item.toMap()).toList(),
      'skills': skills,
      'certifications': certifications.map((item) => item.toMap()).toList(),
      'sectionOrder': sectionOrder.map((section) => section.value).toList(),
      'disabledSections': disabledSections
          .map((section) => section.value)
          .toList(),
      'schemaVersion': schemaVersion,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ResumeModel copyWith({
    String? title,
    Object? targetRole = _unsetResume,
    CareerStage? careerStage,
    String? templateId,
    ResumePersonalInfoModel? personalInfo,
    String? professionalSummary,
    List<ResumeEducationModel>? education,
    List<ResumeExperienceModel>? experience,
    List<ResumeProjectModel>? projects,
    List<String>? skills,
    List<ResumeCertificationModel>? certifications,
    List<ResumeSectionType>? sectionOrder,
    List<ResumeSectionType>? disabledSections,
    int? schemaVersion,
    DateTime? updatedAt,
  }) {
    return ResumeModel(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      targetRole: identical(targetRole, _unsetResume)
          ? this.targetRole
          : targetRole as String?,
      careerStage: careerStage ?? this.careerStage,
      templateId: templateId ?? this.templateId,
      personalInfo: personalInfo ?? this.personalInfo,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      education: education ?? List<ResumeEducationModel>.from(this.education),
      experience:
          experience ?? List<ResumeExperienceModel>.from(this.experience),
      projects: projects ?? List<ResumeProjectModel>.from(this.projects),
      skills: skills ?? List<String>.from(this.skills),
      certifications:
          certifications ??
          List<ResumeCertificationModel>.from(this.certifications),
      sectionOrder:
          sectionOrder ?? List<ResumeSectionType>.from(this.sectionOrder),
      disabledSections:
          disabledSections ??
          List<ResumeSectionType>.from(this.disabledSections),
      schemaVersion: schemaVersion ?? this.schemaVersion,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }

  bool get hasTargetRole => targetRole?.trim().isNotEmpty ?? false;

  bool get hasSummary => professionalSummary.trim().isNotEmpty;

  bool get hasEducation => education.any((item) => item.hasContent);

  bool get hasExperience => experience.any((item) => item.hasContent);

  bool get hasProjects => projects.any((item) => item.hasContent);

  bool get hasSkills => skills.any((skill) => skill.trim().isNotEmpty);

  bool get hasCertifications => certifications.any((item) => item.hasContent);

  bool isSectionEnabled(ResumeSectionType section) {
    return !disabledSections.contains(section);
  }

  static String? _normalizedNullable(String? value) {
    final normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static DateTime _requiredDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static Map<String, dynamic>? _mapFromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
