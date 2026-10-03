import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class DashboardAtsCard extends StatelessWidget {
  const DashboardAtsCard({super.key});

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
                'ATS Score',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              Icon(Icons.analytics_outlined, color: scheme.primary),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Center(
            child: Container(
              height: 120,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 10,
                  color: scheme.primary.withValues(alpha: 0.10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '—',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('No score yet'),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'Analyze a resume against a job description to understand its ATS compatibility.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.atsAnalyzer);
              },
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Analyze ATS Score'),
            ),
          ),
        ],
      ),
    );
  }
}
