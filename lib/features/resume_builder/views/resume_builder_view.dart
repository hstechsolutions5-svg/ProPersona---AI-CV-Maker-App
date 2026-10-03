import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/navigation/app_page_container.dart';
import '../../../shared/widgets/navigation/app_shell.dart';
import '../../resumes/models/resume_model.dart';
import '../controllers/resume_builder_controller.dart';
import '../models/resume_builder_status.dart';
import '../widgets/resume_builder_editor_panel.dart';
import '../widgets/resume_builder_header.dart';
import '../widgets/resume_builder_outline_preview.dart';
import '../widgets/resume_builder_section_navigation.dart';

class ResumeBuilderView extends StatefulWidget {
  const ResumeBuilderView({super.key});

  @override
  State<ResumeBuilderView> createState() => _ResumeBuilderViewState();
}

class _ResumeBuilderViewState extends State<ResumeBuilderView> {
  late final ResumeBuilderController _controller;

  late final String _resumeId;

  @override
  void initState() {
    super.initState();

    _controller = Get.find<ResumeBuilderController>();

    _resumeId = Get.parameters['id']?.trim() ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initialize(_resumeId);
    });
  }

  Future<void>
  _backToResumes() async {
    final saved =
    await _controller
        .saveBeforeExit();

    if (!mounted) {
      return;
    }

    if (saved) {
      Get.offNamed(
        AppRoutes.resumes,
      );

      return;
    }

    final discard =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Resume not saved',
          ),
          content: Text(
            _controller
                .saveFailure
                ?.message ??
                'Your latest changes could not be saved. You can stay and retry, or discard the unsaved changes.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false);
              },
              child: const Text(
                'Stay',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true);
              },
              child: const Text(
                'Discard & Exit',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted ||
        discard != true) {
      return;
    }

    _controller
        .discardChanges();

    Get.offNamed(
      AppRoutes.resumes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Resume Builder',
      currentRoute: AppRoutes.resumes,
      child: AppPageContainer(
        child: Obx(() {
          return switch (_controller.status) {
            ResumeBuilderStatus.idle ||
            ResumeBuilderStatus.loading => const _BuilderLoadingState(),

            ResumeBuilderStatus.error => _BuilderErrorState(
              message:
                  _controller.failure?.message ??
                  'The resume could not be loaded.',
              onRetry: _controller.reload,
              onBack: _backToResumes,
            ),

            ResumeBuilderStatus.ready => _buildReadyState(context),
          };
        }),
      ),
    );
  }

  Widget _buildReadyState(BuildContext context) {
    final resume = _controller.workingResume;

    if (resume == null) {
      return _BuilderErrorState(
        message: 'The resume could not be loaded.',
        onRetry: _controller.reload,
        onBack: _backToResumes,
      );
    }

    final sections = _controller.availableSections;

    final selected = _controller.selectedSection;

    if (sections.isEmpty || selected == null) {
      return _BuilderErrorState(
        message: 'This resume does not contain any enabled sections.',
        onRetry: _controller.reload,
        onBack: _backToResumes,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResumeBuilderHeader(
            resume: resume,
            saveStatus:
            _controller.saveStatus,
            isDirty:
            _controller.isDirty,
            lastSavedAt:
            _controller.lastSavedAt,
            onBack: () {
              _backToResumes();
            },
            onSave: () {
              _controller.saveNow();
            },
            onPreview: () {
              Get.toNamed(
                AppRoutes.resumePreviewPath(
                  resume.id,
                ),
              );
            },
          ),
          if (_controller
              .hasSaveError) ...[
            const SizedBox(
              height: AppSpacing.md,
            ),

            _SaveErrorBanner(
              message:
              _controller
                  .saveFailure
                  ?.message ??
                  'Your latest changes could not be saved.',
              onRetry:
              _controller.retrySave,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          ResponsiveBuilder(
            builder: (context, deviceType, constraints) {
              if (deviceType == DeviceType.mobile) {
                return _buildMobile(resume);
              }

              if (deviceType == DeviceType.tablet ||
                  constraints.maxWidth < 1180) {
                return _buildTablet(resume);
              }

              return _buildDesktop(resume);
            },
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildMobile(ResumeModel resume) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResumeBuilderSectionNavigation(
          sections: _controller.availableSections,
          selectedSection: _controller.selectedSection,
          onSelected: _controller.selectSection,
          compact: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        ResumeBuilderEditorPanel(
          resume: resume,
          section: _controller.selectedSection!,
          controller: _controller,
        ),
        const SizedBox(height: AppSpacing.lg),
        ResumeBuilderOutlinePreview(resume: resume),
      ],
    );
  }

  Widget _buildTablet(ResumeModel resume) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: ResumeBuilderSectionNavigation(
            sections: _controller.availableSections,
            selectedSection: _controller.selectedSection,
            onSelected: _controller.selectSection,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            children: [
              ResumeBuilderEditorPanel(
                resume: resume,
                section: _controller.selectedSection!,
                controller: _controller,
              ),
              const SizedBox(height: AppSpacing.lg),
              ResumeBuilderOutlinePreview(resume: resume),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktop(ResumeModel resume) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: ResumeBuilderSectionNavigation(
            sections: _controller.availableSections,
            selectedSection: _controller.selectedSection,
            onSelected: _controller.selectSection,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: ResumeBuilderEditorPanel(
            resume: resume,
            section: _controller.selectedSection!,
            controller: _controller,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        SizedBox(
          width: 340,
          child: ResumeBuilderOutlinePreview(resume: resume),
        ),
      ],
    );
  }
}

class _BuilderLoadingState extends StatelessWidget {
  const _BuilderLoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 520,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.lg),
            Text('Loading resume builder...'),
          ],
        ),
      ),
    );
  }
}

class _BuilderErrorState extends StatelessWidget {
  const _BuilderErrorState({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;
  final Future<void> Function() onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 520,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.description_outlined, size: 54, color: scheme.error),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Unable to open resume',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                spacing: AppSpacing.xm,
                runSpacing: AppSpacing.xm,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('My Resumes'),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      onRetry();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveErrorBanner
    extends StatelessWidget {
  const _SaveErrorBanner({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final scheme =
        theme.colorScheme;

    return Container(
      padding:
      const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: scheme.error
            .withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        border: Border.all(
          color: scheme.error
              .withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons
                .cloud_off_outlined,
            color: scheme.error,
          ),

          const SizedBox(
            width:
            AppSpacing.md,
          ),

          Expanded(
            child: Text(
              message,
              style: theme
                  .textTheme
                  .bodyMedium,
            ),
          ),

          TextButton(
            onPressed:
            onRetry,
            child: const Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }
}