import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../authentication/controllers/authentication_controller.dart';

class LegalConsentView extends StatefulWidget {
  const LegalConsentView({super.key});

  @override
  State<LegalConsentView> createState() => _LegalConsentViewState();
}

class _LegalConsentViewState extends State<LegalConsentView> {
  late final AuthController _controller;

  bool _accepted = false;

  @override
  void initState() {
    super.initState();

    _controller = Get.find<AuthController>();
  }

  Future<void> _continue() async {
    if (!_accepted) {
      return;
    }

    final success = await _controller.acceptCurrentLegalDocuments();

    if (!mounted) {
      return;
    }

    if (success) {
      Get.offAllNamed(AppRoutes.splash);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Privacy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Review and continue',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Please review and accept the current Terms & Conditions and Privacy Policy before continuing.',
                ),
                const SizedBox(height: AppSpacing.xl),
                CheckboxListTile(
                  value: _accepted,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    setState(() {
                      _accepted = value ?? false;
                    });
                  },
                  title: const Text(
                    'I accept the current Terms & Conditions and Privacy Policy.',
                  ),
                ),
                Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.termsAndConditions);
                      },
                      child: const Text('Terms & Conditions'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.privacyPolicy);
                      },
                      child: const Text('Privacy Policy'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => FilledButton(
                    onPressed: !_accepted || _controller.isLoading
                        ? null
                        : _continue,
                    child: _controller.isAcceptingLegalConsent
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Accept & Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
