import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class DashboardRecentResumesCard extends StatelessWidget {
  const DashboardRecentResumesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Resumes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.resumes);
                },
                child: const Text('View All'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    size: 30,
                    color: scheme.primary,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  'No resumes yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                Text(
                  'Create your first ATS-friendly resume to get started.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                FilledButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.createResume);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Resume'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
