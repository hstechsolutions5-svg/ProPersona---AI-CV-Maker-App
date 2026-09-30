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
  late final AuthController _authController;

  bool _accepted = false;

  @override
  void initState() {
    super.initState();

    _authController = Get.find<AuthController>();
  }

  Future<void> _continue() async {
    if (!_accepted) {
      return;
    }

    final success = await _authController.acceptCurrentLegalDocuments();

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _authController.failure?.message ?? 'Consent could not be saved.',
            ),
          ),
        );

      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Your preferences have been updated.')),
      );

    // Phase 1.14 handles the next destination.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Privacy')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Review and continue',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: AppSpacing.md),

                const Text(
                  'Before continuing with ProPersona, please review and accept the current Terms & Conditions and Privacy Policy.',
                ),

                const SizedBox(height: AppSpacing.xxl),

                CheckboxListTile(
                  value: _accepted,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
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
                  spacing: AppSpacing.xm,
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

                const SizedBox(height: AppSpacing.xxl),

                Obx(
                  () => FilledButton(
                    onPressed: !_accepted || _authController.isLoading
                        ? null
                        : _continue,
                    child: _authController.isAcceptingLegalConsent
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
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
