import 'package:flutter_test/flutter_test.dart';

import 'package:pro_persona/features/resumes/models/resume_model.dart';
import 'package:pro_persona/features/resumes/models/resume_personal_info_model.dart';
import 'package:pro_persona/features/resumes/models/resume_section_type.dart';
import 'package:pro_persona/shared/models/career_stage.dart';

void main() {
  group('ResumeModel', () {
    test('new graduate draft uses graduate section order', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Graduate Resume',
        careerStage: CareerStage.graduate,
      );

      expect(resume.sectionOrder, [
        ResumeSectionType.personalInfo,
        ResumeSectionType.professionalSummary,
        ResumeSectionType.education,
        ResumeSectionType.projects,
        ResumeSectionType.experience,
        ResumeSectionType.skills,
        ResumeSectionType.certifications,
      ]);
    });

    test('new professional draft prioritizes experience', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Professional Resume',
        careerStage: CareerStage.professional,
      );

      expect(resume.sectionOrder, [
        ResumeSectionType.personalInfo,
        ResumeSectionType.professionalSummary,
        ResumeSectionType.experience,
        ResumeSectionType.projects,
        ResumeSectionType.education,
        ResumeSectionType.skills,
        ResumeSectionType.certifications,
      ]);
    });

    test('new draft trims title and target role', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: '  Flutter Developer Resume  ',
        targetRole: '  Flutter Developer  ',
        careerStage: CareerStage.professional,
      );

      expect(resume.title, 'Flutter Developer Resume');

      expect(resume.targetRole, 'Flutter Developer');
    });

    test('empty target role becomes null', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Resume',
        targetRole: '   ',
        careerStage: CareerStage.graduate,
      );

      expect(resume.targetRole, isNull);

      expect(resume.hasTargetRole, isFalse);
    });

    test('resume serializes and deserializes correctly', () {
      final original = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Flutter Developer Resume',
        targetRole: 'Flutter Developer',
        careerStage: CareerStage.professional,
        personalInfo: const ResumePersonalInfoModel(
          fullName: 'Test User',
          email: 'test@example.com',
          phone: '+92 300 1234567',
          city: 'Peshawar',
          country: 'Pakistan',
          linkedinUrl: 'https://linkedin.com/in/test',
          githubUrl: 'https://github.com/test',
        ),
      );

      final map = original.toMap();

      final restored = ResumeModel.fromMap(map);

      expect(restored.id, original.id);

      expect(restored.ownerId, original.ownerId);

      expect(restored.title, original.title);

      expect(restored.targetRole, original.targetRole);

      expect(restored.careerStage, original.careerStage);

      expect(restored.templateId, 'classic');

      expect(restored.schemaVersion, 1);

      expect(restored.personalInfo.fullName, 'Test User');

      expect(restored.personalInfo.email, 'test@example.com');

      expect(restored.personalInfo.city, 'Peshawar');

      expect(restored.personalInfo.country, 'Pakistan');

      expect(restored.sectionOrder, original.sectionOrder);

      expect(
        restored.createdAt.millisecondsSinceEpoch,
        original.createdAt.millisecondsSinceEpoch,
      );

      expect(
        restored.updatedAt.millisecondsSinceEpoch,
        original.updatedAt.millisecondsSinceEpoch,
      );
    });

    test('target role can be explicitly cleared', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Resume',
        targetRole: 'Flutter Developer',
        careerStage: CareerStage.graduate,
      );

      final updated = resume.copyWith(targetRole: null);

      expect(updated.targetRole, isNull);

      expect(updated.hasTargetRole, isFalse);
    });

    test('disabled section is reported as disabled', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Resume',
        careerStage: CareerStage.graduate,
      ).copyWith(disabledSections: [ResumeSectionType.certifications]);

      expect(
        resume.isSectionEnabled(ResumeSectionType.certifications),
        isFalse,
      );

      expect(resume.isSectionEnabled(ResumeSectionType.education), isTrue);
    });

    test('new resume starts with empty content sections', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Resume',
        careerStage: CareerStage.graduate,
      );

      expect(resume.hasSummary, isFalse);

      expect(resume.hasEducation, isFalse);

      expect(resume.hasExperience, isFalse);

      expect(resume.hasProjects, isFalse);

      expect(resume.hasSkills, isFalse);

      expect(resume.hasCertifications, isFalse);
    });

    test('invalid careerStage throws FormatException', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Resume',
        careerStage: CareerStage.graduate,
      );

      final map = resume.toMap();

      map['careerStage'] = 'invalid-stage';

      expect(() => ResumeModel.fromMap(map), throwsFormatException);
    });

    test('missing section order restores default order', () {
      final resume = ResumeModel.newDraft(
        id: 'resume-1',
        ownerId: 'user-1',
        title: 'Resume',
        careerStage: CareerStage.professional,
      );

      final map = resume.toMap();

      map['sectionOrder'] = <String>[];

      final restored = ResumeModel.fromMap(map);

      expect(
        restored.sectionOrder,
        ResumeSectionType.defaultOrderFor(CareerStage.professional),
      );
    });
  });
}
