import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../resumes/models/resume_project_model.dart';
import 'resume_form_widgets.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({
    required this.items,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    super.key,
  });

  final List<ResumeProjectModel> items;

  final VoidCallback onAdd;

  final ValueChanged<ResumeProjectModel> onUpdate;

  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          ResumeEntryCard(
            key: ValueKey(items[index].id),
            title: 'Project ${index + 1}',
            onDelete: () {
              onRemove(items[index].id);
            },
            child: _ProjectFields(item: items[index], onUpdate: onUpdate),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Project'),
        ),
      ],
    );
  }
}

class _ProjectFields extends StatelessWidget {
  const _ProjectFields({required this.item, required this.onUpdate});

  final ResumeProjectModel item;

  final ValueChanged<ResumeProjectModel> onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: item.name,
          decoration: const InputDecoration(labelText: 'Project Name'),
          onChanged: (value) {
            onUpdate(item.copyWith(name: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.role,
          decoration: const InputDecoration(labelText: 'Your Role'),
          onChanged: (value) {
            onUpdate(item.copyWith(role: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.description,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Project Description',
            alignLabelWithHint: true,
          ),
          onChanged: (value) {
            onUpdate(item.copyWith(description: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: ResumeDateField(
                label: 'Start Date',
                value: item.startDate,
                onChanged: (value) {
                  onUpdate(item.copyWith(startDate: value));
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ResumeDateField(
                label: 'End Date',
                value: item.endDate,
                onChanged: (value) {
                  onUpdate(item.copyWith(endDate: value));
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.projectUrl,
          decoration: const InputDecoration(
            labelText: 'Project URL',
            prefixIcon: Icon(Icons.link_rounded),
          ),
          onChanged: (value) {
            onUpdate(item.copyWith(projectUrl: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.repositoryUrl,
          decoration: const InputDecoration(
            labelText: 'Repository URL',
            prefixIcon: Icon(Icons.code_rounded),
          ),
          onChanged: (value) {
            onUpdate(item.copyWith(repositoryUrl: value));
          },
        ),

        const SizedBox(height: AppSpacing.lg),

        ResumeStringListEditor(
          values: item.technologies,
          label: 'Technology',
          addLabel: 'Add Technology',
          onChanged: (values) {
            onUpdate(item.copyWith(technologies: values));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        ResumeStringListEditor(
          values: item.bullets,
          label: 'Project Achievement',
          addLabel: 'Add Achievement',
          onChanged: (values) {
            onUpdate(item.copyWith(bullets: values));
          },
        ),
      ],
    );
  }
}
