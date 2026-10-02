import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../controllers/authentication_controller.dart';
import '../models/session_state.dart';
import '../services/session_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final SessionService _session;

  Worker? _sessionWorker;

  bool _routing = false;

  @override
  void initState() {
    super.initState();

    _session = Get.find<SessionService>();

    _sessionWorker = ever<SessionState>(_session.stateRx, _resolveSession);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveSession(_session.state);
    });
  }

  void _resolveSession(SessionState state) {
    if (_routing) {
      return;
    }

    if (state.isInitializing) {
      return;
    }

    if (state.hasError) {
      return;
    }

    String? destination;

    if (state.isUnauthenticated) {
      destination = AppRoutes.login;
    } else if (state.requiresProfileCreation) {
      // Stay on Splash.
      // Recovery UI is shown below.
      return;
    } else if (state.needsLegalConsent) {
      destination = AppRoutes.legalConsent;
    } else if (state.needsOnboarding) {
      destination = AppRoutes.pathSelector;
    } else if (state.canEnterApplication) {
      destination = AppRoutes.dashboard;
    }

    if (destination == null) {
      return;
    }

    _routing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      Get.offAllNamed(destination!);
    });
  }

  @override
  void dispose() {
    _sessionWorker?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Obx(() {
              final state = _session.state;

              if (state.hasError) {
                return _buildErrorState(state);
              }

              if (state.requiresProfileCreation) {
                return _buildMissingProfileState();
              }

              return _buildLoadingState();
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(),

        const SizedBox(height: AppSpacing.xxl),

        Text(
          'ProPersona',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: AppSpacing.xm),

        Text(
          'The ATS Friendly CV Maker',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: AppSpacing.xxxl),

        const SizedBox(
          height: 26,
          width: 26,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'Preparing your workspace...',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildErrorState(SessionState state) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 52,
            color: AppColors.error,
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'We could not load your session',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSpacing.xm),

          Text(
            state.failure?.message ?? 'Please try again.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxl),

          FilledButton.icon(
            onPressed: () async {
              _routing = false;

              await _session.refreshProfile();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingProfileState() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_off_outlined, size: 52),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'Profile setup incomplete',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSpacing.xm),

          const Text(
            'Your authentication account exists, but your ProPersona profile could not be found.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxl),

          OutlinedButton.icon(
            onPressed: () async {
              final controller = Get.find<AuthController>();

              final success = await controller.logout();

              if (success) {
                Get.offAllNamed(AppRoutes.login);
              }
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 72,
      width: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Text(
        'P',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
