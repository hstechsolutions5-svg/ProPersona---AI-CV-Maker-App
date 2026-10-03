import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/career_stage.dart';
import '../../resumes/models/resume_model.dart';
import '../models/resume_save_status.dart';

class ResumeBuilderHeader extends StatelessWidget {
  const ResumeBuilderHeader({
    required this.resume,
    required this.saveStatus,
    required this.isDirty,
    required this.lastSavedAt,
    required this.onBack,
    required this.onSave,
    required this.onPreview,
    super.key,
  });

  final ResumeModel resume;

  final ResumeSaveStatus
  saveStatus;

  final bool isDirty;

  final DateTime? lastSavedAt;

  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onPreview;

  bool get _isSaving =>
      saveStatus ==
          ResumeSaveStatus.saving;

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final scheme =
        theme.colorScheme;

    return Container(
      padding:
      const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
        BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color:
          scheme.outlineVariant,
        ),
      ),
      child: Wrap(
        spacing: AppSpacing.lg,
        runSpacing:
        AppSpacing.lg,
        alignment:
        WrapAlignment
            .spaceBetween,
        crossAxisAlignment:
        WrapCrossAlignment
            .center,
        children: [
          Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              IconButton(
                tooltip:
                'Back to My Resumes',
                onPressed:
                onBack,
                icon: const Icon(
                  Icons
                      .arrow_back_rounded,
                ),
              ),

              const SizedBox(
                width:
                AppSpacing.xm,
              ),

              ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 620,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      resume.title,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: theme
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                        fontWeight:
                        FontWeight
                            .w800,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      resume.hasTargetRole
                          ? resume
                          .targetRole!
                          : 'No target role selected',
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: scheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Wrap(
            spacing:
            AppSpacing.xm,
            runSpacing:
            AppSpacing.xm,
            crossAxisAlignment:
            WrapCrossAlignment
                .center,
            children: [
              _BuilderChip(
                icon: Icons
                    .route_outlined,
                label: resume
                    .careerStage
                    .label,
              ),

              _BuilderChip(
                icon:
                _statusIcon,
                label:
                _statusLabel,
              ),

              FilledButton.icon(
                onPressed:
                !isDirty ||
                    _isSaving
                    ? null
                    : onSave,
                icon: _isSaving
                    ? const SizedBox(
                  width: 17,
                  height: 17,
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                  ),
                )
                    : const Icon(
                  Icons
                      .save_outlined,
                ),
                label: Text(
                  _isSaving
                      ? 'Saving...'
                      : 'Save',
                ),
              ),
              OutlinedButton.icon(
                onPressed: isDirty || _isSaving
                    ? null
                    : onPreview,
                icon: const Icon(
                  Icons.visibility_outlined,
                ),
                label: const Text(
                  'Preview',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData get _statusIcon {
    return switch (
    saveStatus
    ) {
      ResumeSaveStatus.clean =>
      Icons.cloud_done_outlined,
      ResumeSaveStatus.dirty =>
      Icons.edit_outlined,
      ResumeSaveStatus.saving =>
      Icons.cloud_upload_outlined,
      ResumeSaveStatus.saved =>
      Icons.cloud_done_outlined,
      ResumeSaveStatus.error =>
      Icons
          .cloud_off_outlined,
    };
  }

  String get _statusLabel {
    return switch (
    saveStatus
    ) {
      ResumeSaveStatus.clean =>
      'Up to date',
      ResumeSaveStatus.dirty =>
      'Unsaved changes',
      ResumeSaveStatus.saving =>
      'Saving...',
      ResumeSaveStatus.saved =>
      lastSavedAt == null
          ? 'Saved'
          : 'Saved just now',
      ResumeSaveStatus.error =>
      'Save failed',
    };
  }
}

class _BuilderChip
    extends StatelessWidget {
  const _BuilderChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(
      BuildContext context,
      ) {
    final scheme =
        Theme.of(context)
            .colorScheme;

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: scheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(
          99,
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color:
            scheme.primary,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(label),
        ],
      ),
    );
  }
}