import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../resumes/models/resume_certification_model.dart';
import 'resume_form_widgets.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({
    required this.items,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    super.key,
  });

  final List<ResumeCertificationModel> items;

  final VoidCallback onAdd;

  final ValueChanged<ResumeCertificationModel> onUpdate;

  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          ResumeEntryCard(
            key: ValueKey(items[index].id),
            title: 'Certification ${index + 1}',
            onDelete: () {
              onRemove(items[index].id);
            },
            child: _CertificationFields(item: items[index], onUpdate: onUpdate),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Certification'),
        ),
      ],
    );
  }
}

class _CertificationFields extends StatelessWidget {
  const _CertificationFields({required this.item, required this.onUpdate});

  final ResumeCertificationModel item;

  final ValueChanged<ResumeCertificationModel> onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: item.name,
          decoration: const InputDecoration(labelText: 'Certification Name'),
          onChanged: (value) {
            onUpdate(item.copyWith(name: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.issuer,
          decoration: const InputDecoration(labelText: 'Issuing Organization'),
          onChanged: (value) {
            onUpdate(item.copyWith(issuer: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: ResumeDateField(
                label: 'Issue Date',
                value: item.issueDate,
                onChanged: (value) {
                  onUpdate(item.copyWith(issueDate: value));
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ResumeDateField(
                label: 'Expiry Date',
                value: item.expiryDate,
                onChanged: (value) {
                  onUpdate(item.copyWith(expiryDate: value));
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.credentialId,
          decoration: const InputDecoration(labelText: 'Credential ID'),
          onChanged: (value) {
            onUpdate(item.copyWith(credentialId: value));
          },
        ),

        const SizedBox(height: AppSpacing.md),

        TextFormField(
          initialValue: item.credentialUrl,
          decoration: const InputDecoration(
            labelText: 'Credential URL',
            prefixIcon: Icon(Icons.link_rounded),
          ),
          onChanged: (value) {
            onUpdate(item.copyWith(credentialUrl: value));
          },
        ),
      ],
    );
  }
}
