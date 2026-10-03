import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ResumeEntryCard extends StatelessWidget {
  const ResumeEntryCard({
    required this.title,
    required this.child,
    required this.onDelete,
    super.key,
  });

  final String title;
  final Widget child;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Remove',
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: scheme.error),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class ResumeDateField extends StatelessWidget {
  const ResumeDateField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year + 10),
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = value == null
        ? 'Select date'
        : DateFormat('MMM yyyy').format(value!);

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_month_outlined),
          suffixIcon: value != null
              ? IconButton(
                  tooltip: 'Clear',
                  onPressed: () {
                    onChanged(null);
                  },
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
        ),
        child: Text(formatted),
      ),
    );
  }
}

class ResumeStringListEditor extends StatelessWidget {
  const ResumeStringListEditor({
    required this.values,
    required this.label,
    required this.addLabel,
    required this.onChanged,
    super.key,
  });

  final List<String> values;
  final String label;
  final String addLabel;

  final ValueChanged<List<String>> onChanged;

  void _add() {
    onChanged([...values, '']);
  }

  void _remove(int index) {
    final updated = [...values];

    updated.removeAt(index);

    onChanged(updated);
  }

  void _update(int index, String value) {
    final updated = [...values];

    updated[index] = value;

    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < values.length; index++) ...[
          TextFormField(
            key: ValueKey('$label-$index'),
            initialValue: values[index],
            maxLines: 2,
            decoration: InputDecoration(
              labelText: '$label ${index + 1}',
              suffixIcon: IconButton(
                tooltip: 'Remove',
                onPressed: () {
                  _remove(index);
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            onChanged: (value) {
              _update(index, value);
            },
          ),
          const SizedBox(height: AppSpacing.xm),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
            label: Text(addLabel),
          ),
        ),
      ],
    );
  }
}
