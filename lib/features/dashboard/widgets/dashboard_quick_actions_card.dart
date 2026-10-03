import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class DashboardQuickActionsCard extends StatelessWidget {
  const DashboardQuickActionsCard({super.key});

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
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          _QuickAction(
            icon: Icons.add_rounded,
            label: 'Create Resume',
            onTap: () {
              Get.toNamed(AppRoutes.createResume);
            },
          ),

          _QuickAction(
            icon: Icons.analytics_outlined,
            label: 'Analyze ATS Score',
            onTap: () {
              Get.toNamed(AppRoutes.atsAnalyzer);
            },
          ),

          _QuickAction(
            icon: Icons.auto_fix_high_outlined,
            label: 'Polish Resume Bullet',
            onTap: () {
              Get.toNamed(AppRoutes.bulletPolish);
            },
          ),

          _QuickAction(
            icon: Icons.mail_outline,
            label: 'Generate Cover Letter',
            onTap: () {
              Get.toNamed(AppRoutes.coverLetter);
            },
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xm,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
