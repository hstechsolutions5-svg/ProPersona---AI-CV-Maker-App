import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/navigation/app_page_container.dart';
import '../../../shared/widgets/navigation/app_shell.dart';
import '../controllers/resumes_controller.dart';

class CreateResumeView extends StatefulWidget {
  const CreateResumeView({super.key});

  @override
  State<CreateResumeView> createState() => _CreateResumeViewState();
}

class _CreateResumeViewState extends State<CreateResumeView> {
  final _formKey = GlobalKey<FormState>();

  late final ResumeController _controller;

  late final TextEditingController _titleController;

  late final TextEditingController _targetRoleController;

  @override
  void initState() {
    super.initState();

    _controller = Get.find<ResumeController>();

    _titleController = TextEditingController();

    _targetRoleController = TextEditingController();

    _controller.clearFailure();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetRoleController.dispose();

    super.dispose();
  }

  Future<void> _createResume() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final resume = await _controller.createResume(
      title: _titleController.text,
      targetRole: _targetRoleController.text.trim().isEmpty
          ? null
          : _targetRoleController.text,
    );

    if (!mounted || resume == null) {
      return;
    }

    Get.offNamed(AppRoutes.editResumePath(resume.id));
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Create Resume',
      currentRoute: AppRoutes.resumes,
      child: AppPageContainer(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeading(context),

                    const SizedBox(height: AppSpacing.xxl),

                    _buildProfileCard(context),

                    const SizedBox(height: AppSpacing.xl),

                    _buildFormCard(context),

                    const SizedBox(height: AppSpacing.xl),

                    Obx(() => _buildActions(context)),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create a new resume',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xm),
        Text(
          'Start with the basic details. You can add education, experience, projects, skills and more in the resume builder.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.person_outline, color: scheme.primary),
          ),

          const SizedBox(width: AppSpacing.lg),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting from your profile',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: AppSpacing.xm),

                Text(
                  _controller.profileFullName.isEmpty
                      ? 'Your profile'
                      : _controller.profileFullName,
                  style: theme.textTheme.bodyMedium,
                ),

                if (_controller.profileEmail.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    _controller.profileEmail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.md),

                Wrap(
                  spacing: AppSpacing.xm,
                  runSpacing: AppSpacing.xm,
                  children: [
                    _InfoChip(
                      icon: Icons.route_outlined,
                      label: _controller.careerStageLabel,
                    ),
                    const _InfoChip(
                      icon: Icons.description_outlined,
                      label: 'ATS-friendly',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Resume details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            'These details help organize your resume and tailor it toward a specific role.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          TextFormField(
            controller: _titleController,
            autofocus: true,
            textInputAction: TextInputAction.next,
            maxLength: 80,
            decoration: const InputDecoration(
              labelText: 'Resume Title',
              hintText: 'e.g. Flutter Developer Resume',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            validator: (value) {
              final title = value?.trim() ?? '';

              if (title.isEmpty) {
                return 'Please enter a resume title.';
              }

              if (title.length < 3) {
                return 'Resume title must contain at least 3 characters.';
              }

              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _targetRoleController,
            textInputAction: TextInputAction.done,
            maxLength: 80,
            decoration: const InputDecoration(
              labelText: 'Target Role (Optional)',
              hintText: 'e.g. Flutter Developer',
              prefixIcon: Icon(Icons.work_outline_rounded),
              helperText:
                  'This can later be used to tailor your resume and ATS analysis.',
            ),
            onFieldSubmitted: (_) {
              _createResume();
            },
          ),

          const SizedBox(height: AppSpacing.md),

          _CareerStageNotice(careerStage: _controller.careerStageLabel),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final failure = _controller.failure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (failure != null) ...[
          _FailureMessage(message: failure.message),

          const SizedBox(height: AppSpacing.lg),
        ],

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _controller.isCreating
                    ? null
                    : () {
                        Get.back();
                      },
                child: const Text('Cancel'),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: _controller.isCreating ? null : _createResume,
                icon: _controller.isCreating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  _controller.isCreating ? 'Creating...' : 'Create & Continue',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: scheme.primary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _CareerStageNotice extends StatelessWidget {
  const _CareerStageNotice({required this.careerStage});

  final String careerStage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: scheme.primary),

          const SizedBox(width: AppSpacing.xm),

          Expanded(
            child: Text(
              'Your resume will initially use the $careerStage section structure selected during onboarding. You can customize the content in the builder.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureMessage extends StatelessWidget {
  const _FailureMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: scheme.error, size: 20),

          const SizedBox(width: AppSpacing.xm),

          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
