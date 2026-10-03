import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/career_stage.dart';
import '../models/resume_model.dart';

class ResumeCard extends StatelessWidget {
  const ResumeCard({
    required this.resume,
    required this.onEdit,
    required this.onPreview,
    super.key,
  });

  final ResumeModel resume;

  final VoidCallback onEdit;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: AppSpacing.xl),

                Expanded(child: _buildPreview(context)),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  resume.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                Text(
                  resume.hasTargetRole
                      ? resume.targetRole!
                      : 'No target role yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Wrap(
                  spacing: AppSpacing.xm,
                  runSpacing: AppSpacing.xm,
                  children: [
                    _MetadataChip(
                      icon: _careerIcon(resume.careerStage),
                      label: _careerLabel(resume.careerStage),
                    ),
                    _MetadataChip(
                      icon: Icons.palette_outlined,
                      label: _templateLabel(resume.templateId),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                Divider(height: 1, color: scheme.outlineVariant),

                const SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Updated ${_formatUpdatedAt(resume.updatedAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    IconButton(
                      tooltip: 'Preview Resume',
                      onPressed: onPreview,
                      icon: const Icon(Icons.visibility_outlined),
                    ),

                    IconButton(
                      tooltip: 'Edit Resume',
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(Icons.description_outlined, color: scheme.primary),
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            'Draft',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PreviewLine(
                  widthFactor: 0.62,
                  strong: true,
                  color: scheme.primary,
                ),

                const SizedBox(height: 8),

                _PreviewLine(widthFactor: 0.85, color: scheme.onSurfaceVariant),

                const SizedBox(height: 6),

                _PreviewLine(widthFactor: 0.72, color: scheme.onSurfaceVariant),

                const SizedBox(height: 14),

                _PreviewLine(
                  widthFactor: 0.40,
                  strong: true,
                  color: scheme.primary,
                ),

                const SizedBox(height: 7),

                _PreviewLine(widthFactor: 0.92, color: scheme.onSurfaceVariant),

                const SizedBox(height: 5),

                _PreviewLine(widthFactor: 0.78, color: scheme.onSurfaceVariant),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.10),
            ),
            child: Icon(Icons.person_outline, size: 20, color: scheme.primary),
          ),
        ],
      ),
    );
  }

  static String _careerLabel(CareerStage stage) {
    return switch (stage) {
      CareerStage.graduate => 'Graduate',
      CareerStage.professional => 'Professional',
    };
  }

  static IconData _careerIcon(CareerStage stage) {
    return switch (stage) {
      CareerStage.graduate => Icons.school_outlined,
      CareerStage.professional => Icons.work_outline_rounded,
    };
  }

  static String _templateLabel(String templateId) {
    if (templateId.trim().isEmpty) {
      return 'Classic';
    }

    final value = templateId.trim();

    return value[0].toUpperCase() + value.substring(1);
  }

  static String _formatUpdatedAt(DateTime value) {
    final now = DateTime.now();

    final local = value.toLocal();

    final difference = now.difference(local);

    if (difference.inMinutes < 1) {
      return 'just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return DateFormat('dd MMM yyyy').format(local);
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({
    required this.widthFactor,
    required this.color,
    this.strong = false,
  });

  final double widthFactor;
  final Color color;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: strong ? 7 : 4,
        decoration: BoxDecoration(
          color: color.withValues(alpha: strong ? 0.40 : 0.14),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
