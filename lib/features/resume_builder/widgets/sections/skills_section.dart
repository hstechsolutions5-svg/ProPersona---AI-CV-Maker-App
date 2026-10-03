import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({
    required this.skills,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<String> skills;

  final ValueChanged<String> onAdd;

  final ValueChanged<String> onRemove;

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    widget.onAdd(value);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Skill',
                  hintText: 'e.g. Flutter',
                  prefixIcon: Icon(Icons.bolt_outlined),
                ),
                onSubmitted: (_) {
                  _add();
                },
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            FilledButton.icon(
              onPressed: _add,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        if (widget.skills.isEmpty)
          Text(
            'No skills added yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.xm,
            runSpacing: AppSpacing.xm,
            children: [
              for (final skill in widget.skills)
                InputChip(
                  label: Text(skill),
                  onDeleted: () {
                    widget.onRemove(skill);
                  },
                ),
            ],
          ),
      ],
    );
  }
}
