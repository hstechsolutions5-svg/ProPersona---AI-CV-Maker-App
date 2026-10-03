import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../resumes/models/resume_section_type.dart';
import 'resume_section_presentation.dart';

class ResumeBuilderSectionNavigation extends StatelessWidget {
  const ResumeBuilderSectionNavigation({
    required this.sections,
    required this.selectedSection,
    required this.onSelected,
    this.compact = false,
    super.key,
  });

  final List<ResumeSectionType> sections;
  final ResumeSectionType? selectedSection;
  final ValueChanged<ResumeSectionType> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }

    return _buildSidebar(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xm,
      runSpacing: AppSpacing.xm,
      children: [
        for (final section in sections)
          ChoiceChip(
            selected: selectedSection == section,
            onSelected: (_) {
              onSelected(section);
            },
            avatar: Icon(section.icon, size: 17),
            label: Text(section.label),
          ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xm),
            child: Text(
              'Resume Sections',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xm),
          for (final section in sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _SectionButton(
                section: section,
                selected: selectedSection == section,
                onTap: () {
                  onSelected(section);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final ResumeSectionType section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? scheme.primary.withValues(alpha: 0.09)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                section.icon,
                size: 20,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xm),
              Expanded(
                child: Text(
                  section.label,
                  style: TextStyle(
                    color: selected ? scheme.primary : null,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: scheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
