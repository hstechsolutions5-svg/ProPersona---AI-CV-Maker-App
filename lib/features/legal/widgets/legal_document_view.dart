import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class LegalSection {
  const LegalSection({required this.title, required this.body});

  final String title;
  final String body;
}

class LegalDocumentView extends StatelessWidget {
  const LegalDocumentView({
    required this.title,
    required this.version,
    required this.effectiveDate,
    required this.sections,
    super.key,
  });

  final String title;
  final String version;
  final String effectiveDate;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.headlineLarge),

                  const SizedBox(height: AppSpacing.xm),

                  Text(
                    'Version $version • Effective $effectiveDate',
                    style: theme.textTheme.bodySmall,
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  for (final section in sections) ...[
                    Text(section.title, style: theme.textTheme.titleLarge),

                    const SizedBox(height: AppSpacing.xm),

                    Text(section.body, style: theme.textTheme.bodyMedium),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
