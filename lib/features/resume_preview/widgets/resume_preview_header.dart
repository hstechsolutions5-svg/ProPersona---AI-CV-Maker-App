import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../resumes/models/resume_model.dart';

class ResumePreviewHeader
    extends StatelessWidget {
  const ResumePreviewHeader({
    required this.resume,
    required this.onBack,
    required this.onEdit,
    required this.onRefresh,
    super.key,
  });

  final ResumeModel resume;

  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final scheme =
        theme.colorScheme;

    return Container(
      padding:
      const EdgeInsets.all(
        AppSpacing.lg,
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
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        alignment:
        WrapAlignment.spaceBetween,
        crossAxisAlignment:
        WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'My Resumes',
                onPressed: onBack,
                icon: const Icon(
                  Icons
                      .arrow_back_rounded,
                ),
              ),

              const SizedBox(
                width: AppSpacing.xm,
              ),

              ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 520,
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
                          .titleLarge
                          ?.copyWith(
                        fontWeight:
                        FontWeight
                            .w800,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      'Resume Preview',
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
            spacing: AppSpacing.xm,
            runSpacing:
            AppSpacing.xm,
            children: [
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(
                  Icons
                      .refresh_rounded,
                ),
                label: const Text(
                  'Refresh',
                ),
              ),

              FilledButton.icon(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'Edit Resume',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}