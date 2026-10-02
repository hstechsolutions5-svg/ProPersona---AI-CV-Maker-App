import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/career_stage.dart';
import '../controllers/onboarding_controller.dart';

class PathSelectorView extends StatefulWidget {
  const PathSelectorView({super.key});

  @override
  State<PathSelectorView> createState() => _PathSelectorViewState();
}

class _PathSelectorViewState extends State<PathSelectorView> {
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = Get.find<OnboardingController>();
  }

  Future<void> _continue() async {
    _controller.clearFailure();

    final success = await _controller.completeOnboarding();

    if (!mounted) {
      return;
    }

    if (success) {
      Get.offAllNamed(AppRoutes.splash);

      return;
    }

    Get.offAllNamed(AppRoutes.splash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, deviceType, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(
                deviceType == DeviceType.mobile
                    ? AppSpacing.lg
                    : AppSpacing.xxl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: _buildContent(deviceType),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(DeviceType deviceType) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),

        const SizedBox(height: AppSpacing.xxxl),

        Text(
          'Where are you in your career?',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: AppSpacing.xm),

        Text(
          'Choose the option that best describes you. ProPersona will use it to personalize your resume-building experience.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: AppSpacing.xxxl),

        Obx(() {
          if (deviceType == DeviceType.mobile) {
            return Column(
              children: [
                _buildGraduateCard(),

                const SizedBox(height: AppSpacing.lg),

                _buildProfessionalCard(),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildGraduateCard()),

              const SizedBox(width: AppSpacing.xl),

              Expanded(child: _buildProfessionalCard()),
            ],
          );
        }),

        const SizedBox(height: AppSpacing.xxl),

        Text(
          'You can change your career stage later from your profile settings.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 240, maxWidth: 360),
            child: Obx(
              () => FilledButton(
                onPressed: _controller.canContinue ? _continue : null,
                child: _controller.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Text(
            'P',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        Text(
          'ProPersona',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildGraduateCard() {
    return _CareerStageCard(
      selected: _controller.selectedStage == CareerStage.graduate,
      icon: Icons.school_outlined,
      title: 'Student / Fresh Graduate',
      description:
          'Designed for students, recent graduates, interns, and early-career applicants.',
      highlights: const [
        'Give education greater prominence',
        'Highlight academic and personal projects',
        'Showcase skills and certifications',
      ],
      onTap: () {
        _controller.selectStage(CareerStage.graduate);
      },
    );
  }

  Widget _buildProfessionalCard() {
    return _CareerStageCard(
      selected: _controller.selectedStage == CareerStage.professional,
      icon: Icons.work_outline_rounded,
      title: 'Professional',
      description:
          'Designed for candidates with professional work experience and career achievements.',
      highlights: const [
        'Prioritize professional experience',
        'Highlight measurable achievements',
        'Showcase expertise and responsibilities',
      ],
      onTap: () {
        _controller.selectStage(CareerStage.professional);
      },
    );
  }
}

class _CareerStageCard extends StatelessWidget {
  const _CareerStageCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
    required this.highlights,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String description;
  final List<String> highlights;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : theme.colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
            color: selected ? AppColors.primary.withValues(alpha: 0.05) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: AppColors.primary),
                  ),

                  const Spacer(),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: selected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            key: ValueKey('selected'),
                            color: AppColors.success,
                            size: 26,
                          )
                        : Icon(
                            Icons.radio_button_unchecked,
                            key: const ValueKey('not-selected'),
                            color: theme.colorScheme.outline,
                            size: 26,
                          ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.xm),

              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              for (final item in highlights)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: AppColors.success,
                      ),

                      const SizedBox(width: AppSpacing.xm),

                      Expanded(
                        child: Text(item, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
