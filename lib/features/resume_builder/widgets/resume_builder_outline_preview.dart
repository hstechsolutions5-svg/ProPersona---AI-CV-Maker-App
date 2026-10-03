import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../resumes/models/resume_model.dart';
import 'resume_section_presentation.dart';

class ResumeBuilderOutlinePreview extends StatelessWidget {
  const ResumeBuilderOutlinePreview({required this.resume, super.key});

  final ResumeModel resume;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final sections = resume.sectionOrder
        .where(resume.isSectionEnabled)
        .toList();

    final name = resume.personalInfo.fullName.trim();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 520),
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
              Icon(Icons.visibility_outlined, color: scheme.primary),
              const SizedBox(width: AppSpacing.xm),
              Text(
                'Live Outline',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Your Name' : name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resume.hasTargetRole ? resume.targetRole! : 'Target Role',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (resume.personalInfo.email.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    resume.personalInfo.email,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Divider(color: scheme.outlineVariant),
                const SizedBox(height: AppSpacing.xm),
                for (final section in sections) ...[
                  Row(
                    children: [
                      Icon(section.icon, size: 16, color: scheme.primary),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          section.label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  _OutlineLine(
                    widthFactor: 0.92,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 5),
                  _OutlineLine(
                    widthFactor: 0.72,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineLine extends StatelessWidget {
  const _OutlineLine({required this.widthFactor, required this.color});

  final double widthFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
