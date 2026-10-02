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
import '../widgets/google_sign_in_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late final AuthController _authController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    _authController.clearFailure();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final success = await _authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      final message =
          _authController.failure?.message ?? 'Login could not be completed.';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));

      return;
    }

    Get.offAllNamed(AppRoutes.splash);
  }

  Future<void> _googleSignIn() async {
    FocusScope.of(context).unfocus();

    _authController.clearFailure();

    final success = await _authController.signInWithGoogle(
      legalConsentAccepted: false,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Get.offAllNamed(AppRoutes.splash);

      return;
    }

    Get.offAllNamed(AppRoutes.splash);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
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

              DeviceType.tablet => _buildWide(maxFormWidth: 480),

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
      child: _buildLoginForm(),
    );
  }

  // ─────────────────────────────────────────────
  // Tablet
  // ─────────────────────────────────────────────

  Widget _buildWide({required double maxFormWidth}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxFormWidth),
          child: _buildLoginCard(),
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
                child: _buildLoginCard(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Login Card
  // ─────────────────────────────────────────────

  Widget _buildLoginCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: _buildLoginForm(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Form
  // ─────────────────────────────────────────────

  Widget _buildLoginForm() {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMobileBrand(),

            const SizedBox(height: AppSpacing.xxl),

            Text('Welcome back', style: theme.textTheme.headlineMedium),

            SizedBox(height: AppSpacing.xm),

            Text(
              'Sign in to continue building and improving your professional profile.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            TextFormField(
              controller: _emailController,
              validator: InputValidators.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
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

            TextFormField(
              controller: _passwordController,
              validator: InputValidators.password,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _login(),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.forgotPassword);
                },
                child: const Text('Forgot password?'),
              ),
            ),

            SizedBox(height: AppSpacing.xm),

            Obx(
              () => GoogleSignInButton(
                isLoading: _authController.isGoogleSigningIn,
                onPressed: _googleSignIn,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            _buildDivider(),

            const SizedBox(height: AppSpacing.xxl),

            Obx(() {
              final loading = _authController.isLoggingIn;

              return FilledButton(
                onPressed: _authController.isLoading ? null : _login,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sign In'),
              );
            }),

            const SizedBox(height: AppSpacing.xxl),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: theme.textTheme.bodyMedium,
                ),

                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.signup);
                  },
                  child: const Text('Create Account'),
                ),
              ],
            ),
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
      mainAxisSize: MainAxisSize.min,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogoMark(size: 72, inverted: true),

          const SizedBox(height: AppSpacing.xxl),

          Text(
            'ProPersona',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'The ATS Friendly CV Maker',
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Create professional resumes, improve ATS compatibility, and build your career profile with intelligent tools.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          _BrandFeature(
            icon: Icons.description_outlined,
            label: 'Professional Resume Builder',
          ),

          const SizedBox(height: AppSpacing.lg),

          _BrandFeature(
            icon: Icons.analytics_outlined,
            label: 'ATS-Focused Career Tools',
          ),

          const SizedBox(height: AppSpacing.lg),

          _BrandFeature(
            icon: Icons.auto_awesome_outlined,
            label: 'AI-Assisted Optimization',
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
