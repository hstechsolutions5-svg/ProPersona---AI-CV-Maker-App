import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../resumes/models/resume_model.dart';
import '../../resumes/models/resume_section_type.dart';
import '../controllers/resume_builder_controller.dart';
import 'resume_section_presentation.dart';
import 'sections/certifications_section.dart';
import 'sections/education_section.dart';
import 'sections/experience_section.dart';
import 'sections/personal_info_section.dart';
import 'sections/professional_summary_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';

class ResumeBuilderEditorPanel extends StatelessWidget {
  const ResumeBuilderEditorPanel({
    required this.resume,
    required this.section,
    required this.controller,
    super.key,
  });

  final ResumeModel resume;

  final ResumeSectionType section;

  final ResumeBuilderController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(section.icon, color: scheme.primary),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.label,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _description(section),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          _buildEditor(),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return switch (section) {
      ResumeSectionType.personalInfo => PersonalInfoSection(
        personalInfo: resume.personalInfo,
        onChanged: controller.updatePersonalInfo,
      ),

      ResumeSectionType.professionalSummary => ProfessionalSummarySection(
        summary: resume.professionalSummary,
        onChanged: controller.updateProfessionalSummary,
      ),

      ResumeSectionType.education => EducationSection(
        items: resume.education,
        onAdd: controller.addEducation,
        onUpdate: controller.updateEducation,
        onRemove: controller.removeEducation,
      ),

      ResumeSectionType.experience => ExperienceSection(
        items: resume.experience,
        onAdd: controller.addExperience,
        onUpdate: controller.updateExperience,
        onRemove: controller.removeExperience,
      ),

      ResumeSectionType.projects => ProjectsSection(
        items: resume.projects,
        onAdd: controller.addProject,
        onUpdate: controller.updateProject,
        onRemove: controller.removeProject,
      ),

      ResumeSectionType.skills => SkillsSection(
        skills: resume.skills,
        onAdd: controller.addSkill,
        onRemove: controller.removeSkill,
      ),

      ResumeSectionType.certifications => CertificationsSection(
        items: resume.certifications,
        onAdd: controller.addCertification,
        onUpdate: controller.updateCertification,
        onRemove: controller.removeCertification,
      ),
    };
  }

  String _description(ResumeSectionType section) {
    return switch (section) {
      ResumeSectionType.personalInfo =>
        'Manage your contact and professional profile information.',
      ResumeSectionType.professionalSummary =>
        'Write a focused summary aligned with your target role.',
      ResumeSectionType.education =>
        'Add your degrees, institutions and academic achievements.',
      ResumeSectionType.experience =>
        'Describe your professional experience and measurable impact.',
      ResumeSectionType.projects =>
        'Showcase projects, technologies and outcomes.',
      ResumeSectionType.skills => 'Add skills relevant to your target role.',
      ResumeSectionType.certifications =>
        'Add professional certificates and credentials.',
    };
  }
}
