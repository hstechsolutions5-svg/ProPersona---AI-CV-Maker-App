import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    required this.isLoading,
    this.enabled = true,
    super.key,
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
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isSupported && !isLoading ? onPressed : null,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.login_rounded),
      label: Text(isLoading ? 'Connecting...' : 'Continue with Google'),
    );
  }
}
