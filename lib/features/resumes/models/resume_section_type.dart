import '../../../shared/models/career_stage.dart';

enum ResumeSectionType {
  personalInfo('personal_info'),
  professionalSummary('professional_summary'),
  education('education'),
  experience('experience'),
  projects('projects'),
  skills('skills'),
  certifications('certifications');

  const ResumeSectionType(this.value);

  final String value;

  static ResumeSectionType? fromString(String? value) {
    for (final section in ResumeSectionType.values) {
      if (section.value == value) {
        return section;
      }
    }

    return null;
  }

  static List<ResumeSectionType> defaultOrderFor(CareerStage careerStage) {
    return switch (careerStage) {
      CareerStage.graduate => const [
        ResumeSectionType.personalInfo,
        ResumeSectionType.professionalSummary,
        ResumeSectionType.education,
        ResumeSectionType.projects,
        ResumeSectionType.experience,
        ResumeSectionType.skills,
        ResumeSectionType.certifications,
      ],
      CareerStage.professional => const [
        ResumeSectionType.personalInfo,
        ResumeSectionType.professionalSummary,
        ResumeSectionType.experience,
        ResumeSectionType.projects,
        ResumeSectionType.education,
        ResumeSectionType.skills,
        ResumeSectionType.certifications,
      ],
    };
  }
}
