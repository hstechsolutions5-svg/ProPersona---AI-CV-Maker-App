import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/navigation/app_page_container.dart';
import '../../../shared/widgets/navigation/app_shell.dart';
import '../controllers/resume_preview_controller.dart';
import '../widgets/ats_resume_preview.dart';
import '../widgets/resume_preview_header.dart';

class ResumePreviewView
    extends StatefulWidget {
  const ResumePreviewView({
    super.key,
  });

  @override
  State<ResumePreviewView> createState() =>
      _ResumePreviewViewState();
}

class _ResumePreviewViewState
    extends State<ResumePreviewView> {
  late final ResumePreviewController
  _controller;

  late final String _resumeId;

  @override
  void initState() {
    super.initState();

    _controller =
        Get.find<
            ResumePreviewController>();

    _resumeId =
        Get.parameters['id']
            ?.trim() ??
            '';

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        _controller.initialize(
          _resumeId,
        );
      },
    );
  }

  void _back() {
    Get.offNamed(
      AppRoutes.resumes,
    );
  }

  void _edit() {
    final resume =
        _controller.resume;

    if (resume == null) {
      return;
    }

    Get.offNamed(
      AppRoutes.editResumePath(
        resume.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Resume Preview',
      currentRoute:
      AppRoutes.resumes,
      child: AppPageContainer(
        child: Obx(
              () {
            return switch (
            _controller.status
            ) {
              ResumePreviewStatus.idle ||
              ResumePreviewStatus.loading =>
              const _PreviewLoadingState(),

              ResumePreviewStatus.error =>
                  _PreviewErrorState(
                    message:
                    _controller
                        .failure
                        ?.message ??
                        'The resume could not be loaded.',
                    onRetry:
                    _controller.refresh,
                    onBack: _back,
                  ),

              ResumePreviewStatus.ready =>
                  _buildPreview(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final resume =
        _controller.resume;

    if (resume == null) {
      return _PreviewErrorState(
        message:
        'The resume could not be loaded.',
        onRetry:
        _controller.refresh,
        onBack: _back,
      );
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        ResumePreviewHeader(
          resume: resume,
          onBack: _back,
          onEdit: _edit,
          onRefresh: () {
            _controller.refresh();
          },
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerLowest,
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            child:
            SingleChildScrollView(
              padding:
              const EdgeInsets.all(
                AppSpacing.xxl,
              ),
              child:
              SingleChildScrollView(
                scrollDirection:
                Axis.horizontal,
                child: AtsResumePreview(
                  resume: resume,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewLoadingState
    extends StatelessWidget {
  const _PreviewLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          CircularProgressIndicator(),

          SizedBox(
            height: AppSpacing.lg,
          ),

          Text(
            'Preparing resume preview...',
          ),
        ],
      ),
    );
  }
}

class _PreviewErrorState
    extends StatelessWidget {
  const _PreviewErrorState({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;

  final Future<void> Function()
  onRetry;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints:
        const BoxConstraints(
          maxWidth: 520,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .description_outlined,
              size: 54,
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            Text(
              'Unable to preview resume',
              textAlign:
              TextAlign.center,
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: AppSpacing.xm,
            ),

            Text(
              message,
              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: AppSpacing.xl,
            ),

            Wrap(
              spacing: AppSpacing.xm,
              runSpacing:
              AppSpacing.xm,
              children: [
                OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(
                    Icons
                        .arrow_back_rounded,
                  ),
                  label: const Text(
                    'My Resumes',
                  ),
                ),

                FilledButton.icon(
                  onPressed: () {
                    onRetry();
                  },
                  icon: const Icon(
                    Icons
                        .refresh_rounded,
                  ),
                  label: const Text(
                    'Retry',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}