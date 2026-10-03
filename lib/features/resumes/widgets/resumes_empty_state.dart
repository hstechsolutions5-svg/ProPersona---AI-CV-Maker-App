import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class ResumesEmptyState extends StatelessWidget {
  const ResumesEmptyState({
    required this.onCreateResume,
    this.searchQuery,
    super.key,
  });

  final VoidCallback onCreateResume;

  final String? searchQuery;

  bool get _isSearching => searchQuery?.trim().isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 64,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              _isSearching
                  ? Icons.search_off_rounded
                  : Icons.description_outlined,
              size: 34,
              color: scheme.primary,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            _isSearching ? 'No matching resumes' : 'Create your first resume',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.xm),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              _isSearching
                  ? 'No resumes match "$searchQuery". Try a different title or target role.'
                  : 'Build a structured, ATS-friendly resume tailored to your career stage.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),

          if (!_isSearching) ...[
            const SizedBox(height: AppSpacing.xl),

            FilledButton.icon(
              onPressed: onCreateResume,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Resume'),
            ),
          ],
        ],
      ),
    );
  }
}
