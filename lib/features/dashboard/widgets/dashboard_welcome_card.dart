import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class DashboardWelcomeCard extends StatelessWidget {
  const DashboardWelcomeCard({required this.firstName, super.key});

  final String firstName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.14),
            scheme.primary.withValues(alpha: 0.05),
            scheme.surface,
          ],
        ),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.primary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                Text(
                  '$firstName 👋',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: AppSpacing.xm),

                Text(
                  'Build ATS-friendly resumes and improve your career profile with ProPersona.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRoutes.createResume);
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create New Resume'),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.resumes);
                      },
                      icon: const Icon(Icons.description_outlined),
                      label: const Text('My Resumes'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.xl),

          Flexible(child: _HeroIllustration(color: scheme.primary)),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 150,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: -0.10,
              child: _ResumeSheet(color: color, opacity: 0.10),
            ),

            Transform.translate(
              offset: const Offset(18, 6),
              child: _ResumeSheet(color: color, opacity: 0.18),
            ),

            Positioned(
              right: 16,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'ATS Ready',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeSheet extends StatelessWidget {
  const _ResumeSheet({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 125,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: opacity)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(Icons.person, size: 12, color: color),
          ),

          const SizedBox(height: 10),

          _Line(width: 58, color: color),

          const SizedBox(height: 6),

          _Line(width: 70, color: color),

          const SizedBox(height: 6),

          _Line(width: 45, color: color),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
