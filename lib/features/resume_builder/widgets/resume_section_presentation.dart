import 'package:flutter/material.dart';

import '../../resumes/models/resume_section_type.dart';

extension ResumeSectionPresentation on ResumeSectionType {
  String get label {
    return switch (this) {
      ResumeSectionType.personalInfo => 'Personal Information',
      ResumeSectionType.professionalSummary => 'Professional Summary',
      ResumeSectionType.education => 'Education',
      ResumeSectionType.experience => 'Experience',
      ResumeSectionType.projects => 'Projects',
      ResumeSectionType.skills => 'Skills',
      ResumeSectionType.certifications => 'Certifications',
    };
  }

  IconData get icon {
    return switch (this) {
      ResumeSectionType.personalInfo => Icons.person_outline_rounded,
      ResumeSectionType.professionalSummary => Icons.subject_rounded,
      ResumeSectionType.education => Icons.school_outlined,
      ResumeSectionType.experience => Icons.work_outline_rounded,
      ResumeSectionType.projects => Icons.folder_outlined,
      ResumeSectionType.skills => Icons.auto_awesome_outlined,
      ResumeSectionType.certifications => Icons.workspace_premium_outlined,
    };
  }
}
