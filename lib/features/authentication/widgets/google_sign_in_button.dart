import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    required this.isLoading,
    super.key,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  static bool get isSupported {
    if (kIsWeb) {
      return true;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,

      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.fuchsia => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final supported = isSupported;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: supported && enabled && !isLoading ? onPressed : null,
          icon: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.login_rounded),
          label: Text(
            isLoading ? 'Connecting to Google...' : 'Continue with Google',
          ),
        ),

        if (!supported) ...[
          const SizedBox(height: AppSpacing.xm),
          Text(
            'Google Sign-In is not available on this platform.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
