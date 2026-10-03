import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/navigation/app_page_container.dart';
import '../../../shared/widgets/navigation/app_shell.dart';
import '../controllers/resumes_controller.dart';
import '../models/resume_model.dart';
import '../widgets/resume_card.dart';
import '../widgets/resumes_empty_state.dart';
import '../widgets/resumes_error_state.dart';

class MyResumesView extends StatefulWidget {
  const MyResumesView({super.key});

  @override
  State<MyResumesView> createState() => _MyResumesViewState();
}

class _MyResumesViewState extends State<MyResumesView> {
  late final ResumeController _controller;

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _controller = Get.find<ResumeController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadResumes();
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final value = _searchController.text;

    if (value == _searchQuery) {
      return;
    }

    setState(() {
      _searchQuery = value;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);

    _searchController.dispose();

    super.dispose();
  }

  void _createResume() {
    Get.toNamed(AppRoutes.createResume);
  }

  void _editResume(ResumeModel resume) {
    _controller.selectResume(resume);

    Get.toNamed(AppRoutes.editResumePath(resume.id));
  }

  void _previewResume(ResumeModel resume) {
    _controller.selectResume(resume);

    Get.toNamed(AppRoutes.resumePreviewPath(resume.id));
  }

  List<ResumeModel> _filteredResumes(List<ResumeModel> resumes) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return resumes;
    }

    return resumes.where((resume) {
      final title = resume.title.toLowerCase();

      final targetRole = resume.targetRole?.toLowerCase() ?? '';

      return title.contains(query) || targetRole.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'My Resumes',
      currentRoute: AppRoutes.resumes,
      actions: [
        IconButton(
          tooltip: 'Refresh Resumes',
          onPressed: () {
            _controller.refreshResumes();
          },
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createResume,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Resume'),
      ),
      child: AppPageContainer(child: Obx(() => _buildBody(context))),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    if (_controller.isLoadingResumes && !_controller.hasLoadedResumes) {
      return const _LoadingState();
    }

    if (_controller.failure != null && !_controller.hasLoadedResumes) {
      return ResumesErrorState(
        message:
            _controller.failure?.message ?? 'Your resumes could not be loaded.',
        onRetry: () {
          _controller.refreshResumes();
        },
      );
    }

    final resumes = _controller.resumes;

    final filtered = _filteredResumes(resumes);

    return RefreshIndicator(
      onRefresh: _controller.refreshResumes,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your resumes',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      Text(
                        resumes.isEmpty
                            ? 'Create and manage your ATS-friendly resumes.'
                            : '${resumes.length} ${resumes.length == 1 ? 'resume' : 'resumes'} in your workspace.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                if (_controller.isLoadingResumes)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            _SearchBar(
              controller: _searchController,
              hasQuery: _searchQuery.trim().isNotEmpty,
              onClear: () {
                _searchController.clear();
              },
            ),

            const SizedBox(height: AppSpacing.xxl),

            if (resumes.isEmpty)
              ResumesEmptyState(onCreateResume: _createResume)
            else if (filtered.isEmpty)
              ResumesEmptyState(
                onCreateResume: _createResume,
                searchQuery: _searchQuery,
              )
            else
              _ResumeGrid(
                resumes: filtered,
                onEdit: _editResume,
                onPreview: _previewResume,
              ),

            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.hasQuery,
    required this.onClear,
  });

  final TextEditingController controller;

  final bool hasQuery;

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search by resume title or target role',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: hasQuery
            ? IconButton(
                tooltip: 'Clear Search',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              )
            : null,
      ),
    );
  }
}

class _ResumeGrid extends StatelessWidget {
  const _ResumeGrid({
    required this.resumes,
    required this.onEdit,
    required this.onPreview,
  });

  final List<ResumeModel> resumes;

  final void Function(ResumeModel resume) onEdit;

  final void Function(ResumeModel resume) onPreview;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final columns = switch (deviceType) {
          DeviceType.mobile => 1,
          DeviceType.tablet => 2,
          DeviceType.desktop => constraints.maxWidth >= 1250 ? 3 : 2,
        };

        const spacing = AppSpacing.lg;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: resumes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: deviceType == DeviceType.mobile ? 410 : 430,
          ),
          itemBuilder: (context, index) {
            final resume = resumes[index];

            return ResumeCard(
              key: ValueKey(resume.id),
              resume: resume,
              onEdit: () {
                onEdit(resume);
              },
              onPreview: () {
                onPreview(resume);
              },
            );
          },
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 460,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),

            SizedBox(height: AppSpacing.lg),

            Text('Loading your resumes...'),
          ],
        ),
      ),
    );
  }
}
