import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/input_validators.dart';
import '../controllers/authentication_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  late final AuthController _authController;

  bool _emailSent = false;

  @override
  void initState() {
    super.initState();

    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    FocusScope.of(context).unfocus();

    _authController.clearFailure();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final success = await _authController.resetPassword(
      email: _emailController.text,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      final message =
          _authController.failure?.message ??
          'Password reset could not be completed.';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));

      return;
    }

    setState(() {
      _emailSent = true;
    });
  }

  void _tryAnotherEmail() {
    _authController.clearFailure();

    setState(() {
      _emailSent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, deviceType, constraints) {
            return switch (deviceType) {
              DeviceType.mobile => _buildMobile(),

              DeviceType.tablet => _buildTablet(),

              DeviceType.desktop => _buildDesktop(),
            };
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Mobile
  // ─────────────────────────────────────────────

  Widget _buildMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: _buildContent(),
    );
  }

  // ─────────────────────────────────────────────
  // Tablet
  // ─────────────────────────────────────────────

  Widget _buildTablet() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _buildCard(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Desktop
  // ─────────────────────────────────────────────

  Widget _buildDesktop() {
    return Row(
      children: [
        Expanded(flex: 5, child: _buildBrandPanel()),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: _buildCard(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _emailSent ? _buildSuccessState() : _buildResetForm(),
    );
  }

  // ─────────────────────────────────────────────
  // Reset Form
  // ─────────────────────────────────────────────

  Widget _buildResetForm() {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('reset-form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMobileBrand(),

          const SizedBox(height: AppSpacing.xxl),

          _buildIcon(Icons.lock_reset_rounded),

          const SizedBox(height: AppSpacing.xxl),

          Text('Forgot your password?', style: theme.textTheme.headlineMedium),

          SizedBox(height: AppSpacing.xm),

          Text(
            'Enter the email address associated with your ProPersona account and we will send you a password reset link.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          TextFormField(
            controller: _emailController,
            validator: InputValidators.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email, AutofillHints.username],
            autocorrect: false,
            enableSuggestions: false,
            onFieldSubmitted: (_) => _sendResetEmail(),
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          Obx(() {
            final isLoading = _authController.isResettingPassword;

            return FilledButton(
              onPressed: _authController.isLoading ? null : _sendResetEmail,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isLoading
                    ? const SizedBox(
                        key: ValueKey('reset-loading'),
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Send Reset Link',
                        key: ValueKey('reset-text'),
                      ),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.lg),

          TextButton.icon(
            onPressed: () {
              Get.offNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Success State
  // ─────────────────────────────────────────────

  Widget _buildSuccessState() {
    final theme = Theme.of(context);

    final email = _emailController.text.trim();

    return Column(
      key: const ValueKey('reset-success'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMobileBrand(),

        const SizedBox(height: AppSpacing.xxl),

        _buildSuccessIcon(),

        const SizedBox(height: AppSpacing.xxl),

        Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          'If an eligible ProPersona account is associated with:',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        SizedBox(height: AppSpacing.xm),

        Text(
          email,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary),
        ),

        SizedBox(height: AppSpacing.xm),

        Text(
          'you should receive instructions for resetting your password.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: AppSpacing.xxxl),

        FilledButton(
          onPressed: () {
            Get.offNamed(AppRoutes.login);
          },
          child: const Text('Return to Sign In'),
        ),

        const SizedBox(height: AppSpacing.md),

        TextButton(
          onPressed: _tryAnotherEmail,
          child: const Text('Use another email address'),
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'If you do not see the email, check your spam or junk folder.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Branding
  // ─────────────────────────────────────────────

  Widget _buildMobileBrand() {
    return Row(
      children: [
        _buildLogoMark(size: 42),

        const SizedBox(width: AppSpacing.md),

        Text(
          'ProPersona',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildBrandPanel() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.page),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogoMark(size: 72, inverted: true),

          const SizedBox(height: AppSpacing.xxl),

          Text(
            'Welcome back to your career journey.',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Reset your password securely and continue building professional, ATS-friendly career documents with ProPersona.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),

          const SizedBox(height: AppSpacing.page),

          Text(
            'A product by Huzentra Technologies',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoMark({required double size, bool inverted = false}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: inverted
            ? Colors.white.withValues(alpha: 0.14)
            : AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Text(
        'P',
        style: TextStyle(
          fontSize: size * 0.52,
          fontWeight: FontWeight.w800,
          color: inverted ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Icon(icon, color: AppColors.primary, size: 28),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mark_email_read_outlined,
          color: AppColors.success,
          size: 34,
        ),
      ),
    );
  }
}
