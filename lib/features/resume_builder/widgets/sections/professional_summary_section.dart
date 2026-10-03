import 'package:flutter/material.dart';

class ProfessionalSummarySection extends StatelessWidget {
  const ProfessionalSummarySection({
    required this.summary,
    required this.onChanged,
    super.key,
  });

  final String summary;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: summary,
      maxLines: 8,
      minLines: 6,
      maxLength: 1200,
      decoration: const InputDecoration(
        labelText: 'Professional Summary',
        hintText:
            'Write a concise summary of your background, strengths, achievements and target role.',
        alignLabelWithHint: true,
      ),
      onChanged: onChanged,
    );
  }
}
