import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../resumes/models/resume_experience_model.dart';
import 'resume_form_widgets.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({
    required this.items,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    super.key,
  });

  final List<ResumeExperienceModel> items;

  final VoidCallback onAdd;

  final ValueChanged<ResumeExperienceModel> onUpdate;

  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          ResumeEntryCard(
            key: ValueKey(items[index].id),
            title: 'Experience ${index + 1}',
            onDelete: () {
              onRemove(items[index].id);
            },
            child: _ExperienceFields(item: items[index], onUpdate: onUpdate),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Experience'),
        ),
      ],
    );
  }
}

class _ExperienceFields extends StatelessWidget {
  const _ExperienceFields({required this.item, required this.onUpdate});

  final ResumeExperienceModel item;

  final ValueChanged<ResumeExperienceModel> onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: item.jobTitle,
          decoration: const InputDecoration(labelText: 'Job Title'),
          onChanged: (value) {
            onUpdate(item.copyWith(jobTitle: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.company,
          decoration: const InputDecoration(labelText: 'Company'),
          onChanged: (value) {
            onUpdate(item.copyWith(company: value));
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
          title: const Text('I currently work here'),
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

        const SizedBox(height: AppSpacing.xm),

        ResumeStringListEditor(
          values: item.bullets,
          label: 'Achievement',
          addLabel: 'Add Achievement',
          onChanged: (values) {
            onUpdate(item.copyWith(bullets: values));
          },
        ),
      ],
    );
  }
}
