import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/responsive/device_type.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/input_validators.dart';
import '../controllers/authentication_controller.dart';
import '../widgets/google_sign_in_button.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<bool>> _legalConsentKey =
      GlobalKey<FormFieldState<bool>>();

  bool _legalConsentAccepted = false;

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final AuthController _authController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    _authController = Get.find<AuthController>();

    _passwordController.addListener(_refreshPasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_refreshPasswordStrength);

    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _refreshPasswordStrength() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    _authController.clearFailure();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final success = await _authController.signup(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      legalConsentAccepted: _legalConsentAccepted,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      final message =
          _authController.failure?.message ??
          'Your account could not be created.';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));

      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Your ProPersona account has been created.'),
        ),
      );

    // Phase 1.14 will automatically route
    // newly registered users to Path Selector
    // based on SessionService state.
  }

  Future<void> _googleSignIn() async {
    FocusScope.of(context).unfocus();

    _authController.clearFailure();

    final success = await _authController.signInWithGoogle(
      legalConsentAccepted: _legalConsentAccepted,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      final failure = _authController.failure;

      if (failure?.type == FailureType.cancelled) {
        return;
      }

      final message =
          failure?.message ?? 'Google Sign-In could not be completed.';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));

      return;
    }

    final legalValid = _legalConsentKey.currentState?.validate() ?? false;

    if (!legalValid) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Google authentication completed successfully.'),
        ),
      );

    // Session state determines whether this
    // user needs onboarding. Routing comes
    // in Phase 1.14.
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
      child: _buildSignupForm(),
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
          constraints: const BoxConstraints(maxWidth: 520),
          child: _buildSignupCard(),
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
                constraints: const BoxConstraints(maxWidth: 500),
                child: _buildSignupCard(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Card
  // ─────────────────────────────────────────────

  Widget _buildSignupCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: _buildSignupForm(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Form
  // ─────────────────────────────────────────────

  Widget _buildSignupForm() {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMobileBrand(),

            const SizedBox(height: AppSpacing.xxl),

            Text('Create your account', style: theme.textTheme.headlineMedium),

            SizedBox(height: AppSpacing.xm),

            Text(
              'Start building a professional, ATS-friendly career profile with ProPersona.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Full Name
            TextFormField(
              controller: _fullNameController,
              validator: InputValidators.fullName,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Muhammad Huzaifa',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Email
            TextFormField(
              controller: _emailController,
              validator: InputValidators.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username,
              ],
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Password
            TextFormField(
              controller: _passwordController,
              validator: InputValidators.signupPassword,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            _PasswordRequirements(password: _passwordController.text),

            const SizedBox(height: AppSpacing.lg),

            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              validator: (value) {
                return InputValidators.confirmPassword(
                  value: value,
                  password: _passwordController.text,
                );
              },
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _signup(),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscureConfirmPassword
                      ? 'Show password'
                      : 'Hide password',
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            FormField<bool>(
              key: _legalConsentKey,
              initialValue: false,
              validator: (value) {
                if (value != true) {
                  return 'You must accept the Terms & Privacy Policy.';
                }

                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _legalConsentAccepted,
                          onChanged: (value) {
                            final accepted = value ?? false;

                            setState(() {
                              _legalConsentAccepted = accepted;
                            });

                            field.didChange(accepted);
                          },
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text('I agree to the '),

                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Get.toNamed(AppRoutes.termsAndConditions);
                                  },
                                  child: const Text('Terms & Conditions'),
                                ),

                                const Text(' and '),

                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Get.toNamed(AppRoutes.privacyPolicy);
                                  },
                                  child: const Text('Privacy Policy'),
                                ),

                                const Text('.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          field.errorText!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                  ],
                );
              },
            ),

            Obx(() {
              final loading = _authController.isSigningUp;

              return FilledButton(
                onPressed: _authController.isLoading ? null : _signup,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: loading
                      ? const SizedBox(
                          key: ValueKey('signup-loading'),
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          key: ValueKey('signup-text'),
                        ),
                ),
              );
            }),

            const SizedBox(height: AppSpacing.xxl),

            _buildDivider(),

            const SizedBox(height: AppSpacing.xxl),

            // Google activation comes in 1.11.
            Obx(
              () => GoogleSignInButton(
                isLoading: _authController.isGoogleSigningIn,
                enabled:
                    !_authController.isLoading ||
                    _authController.isGoogleSigningIn,
                onPressed: _googleSignIn,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: theme.textTheme.bodyMedium,
                ),

                TextButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.login);
                  },
                  child: const Text('Sign In'),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xm),
          ],
        ),
      ),
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
            'Build your career story.',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Create professional resumes, improve ATS compatibility, and prepare stronger applications with ProPersona.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          const _BrandFeature(
            icon: Icons.edit_document,
            label: 'Build structured professional resumes',
          ),

          const SizedBox(height: AppSpacing.lg),

          const _BrandFeature(
            icon: Icons.analytics_outlined,
            label: 'Improve ATS compatibility',
          ),

          const SizedBox(height: AppSpacing.lg),

          const _BrandFeature(
            icon: Icons.auto_awesome_outlined,
            label: 'Use intelligent career tools',
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text('OR', style: Theme.of(context).textTheme.labelSmall),
        ),

        const Expanded(child: Divider()),
      ],
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Requirement(
          label: 'At least 8 characters',
          completed: password.length >= 8,
        ),
        _Requirement(
          label: 'One uppercase letter',
          completed: RegExp(r'[A-Z]').hasMatch(password),
        ),
        _Requirement(
          label: 'One lowercase letter',
          completed: RegExp(r'[a-z]').hasMatch(password),
        ),
        _Requirement(
          label: 'One number',
          completed: RegExp(r'[0-9]').hasMatch(password),
        ),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({required this.label, required this.completed});

  final String label;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? AppColors.success
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            size: 16,
            color: color,
          ),

          SizedBox(width: AppSpacing.xm),

          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _BrandFeature extends StatelessWidget {
  const _BrandFeature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: Colors.white),
        ),

        const SizedBox(width: AppSpacing.lg),

        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
