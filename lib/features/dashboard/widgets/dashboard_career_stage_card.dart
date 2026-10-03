import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class DashboardCareerStageCard extends StatelessWidget {
  const DashboardCareerStageCard({
    required this.label,
    required this.guidance,
    required this.tip,
    super.key,
  });

  final String label;
  final String guidance;
  final String tip;

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
                'Career Stage',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.profile);
                },
                child: const Text('Edit'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(Icons.school_outlined, color: scheme.primary),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xm),

                    Text(
                      guidance,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: scheme.primary, size: 20),

                const SizedBox(width: AppSpacing.xm),

                Expanded(
                  child: Text('Tip: $tip', style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
