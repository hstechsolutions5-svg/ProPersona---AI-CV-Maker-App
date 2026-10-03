import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../resumes/models/resume_education_model.dart';
import 'resume_form_widgets.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({
    required this.items,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    super.key,
  });

  final List<ResumeEducationModel> items;

  final VoidCallback onAdd;

  final ValueChanged<ResumeEducationModel> onUpdate;

  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _EducationCard(
            key: ValueKey(items[index].id),
            item: items[index],
            index: index,
            onUpdate: onUpdate,
            onRemove: onRemove,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Education'),
        ),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({
    required this.item,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    super.key,
  });

  final ResumeEducationModel item;
  final int index;

  final ValueChanged<ResumeEducationModel> onUpdate;

  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return ResumeEntryCard(
      title: 'Education ${index + 1}',
      onDelete: () {
        onRemove(item.id);
      },
      child: Column(
        children: [
          TextFormField(
            initialValue: item.institution,
            decoration: const InputDecoration(labelText: 'Institution'),
            onChanged: (value) {
              onUpdate(item.copyWith(institution: value));
            },
          ),

          const SizedBox(height: AppSpacing.md),

          TextFormField(
            initialValue: item.degree,
            decoration: const InputDecoration(labelText: 'Degree'),
            onChanged: (value) {
              onUpdate(item.copyWith(degree: value));
            },
          ),

          const SizedBox(height: AppSpacing.md),

          TextFormField(
            initialValue: item.fieldOfStudy,
            decoration: const InputDecoration(labelText: 'Field of Study'),
            onChanged: (value) {
              onUpdate(item.copyWith(fieldOfStudy: value));
            },
          ),

          const SizedBox(height: AppSpacing.md),

          TextFormField(
            initialValue: item.location,
            decoration: const InputDecoration(labelText: 'Location'),
            onChanged: (value) {
              onUpdate(item.copyWith(location: value));
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
                  onChanged: item.isCurrent
                      ? (_) {}
                      : (value) {
                          onUpdate(item.copyWith(endDate: value));
                        },
                ),
              ),
            ],
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Currently studying here'),
            value: item.isCurrent,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              final isCurrent = value ?? false;

              onUpdate(
                item.copyWith(
                  isCurrent: isCurrent,
                  endDate: isCurrent ? null : item.endDate,
                ),
              );
            },
          ),

          TextFormField(
            initialValue: item.grade,
            decoration: const InputDecoration(labelText: 'Grade / GPA'),
            onChanged: (value) {
              onUpdate(item.copyWith(grade: value));
            },
          ),

          const SizedBox(height: AppSpacing.md),

          TextFormField(
            initialValue: item.description,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
            ),
            onChanged: (value) {
              onUpdate(item.copyWith(description: value));
            },
          ),
        ],
      ),
    );
  }
}
