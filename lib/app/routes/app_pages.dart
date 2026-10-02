import 'package:get/get.dart';
import 'package:pro_persona/features/authentication/views/forget_password_view.dart';
import 'package:pro_persona/features/authentication/views/signup_view.dart';
import 'package:pro_persona/features/authentication/views/splash_view.dart';
import 'package:pro_persona/features/legal/widgets/privacy_policy_view.dart';
import 'package:pro_persona/features/legal/widgets/terms_and_conditions_view.dart';
import 'package:pro_persona/features/onboarding/bindings/onboarding_binding.dart';
import 'package:pro_persona/features/onboarding/views/path_selector_view.dart';
import '../../core/widgets/route_placeholder_view.dart';
import '../../features/legal/views/legal_consent_view.dart';
import '../../shared/widgets/navigation/app_shell_placeholder_view.dart';
import 'app_routes.dart';
import 'middleware/auth_middleware.dart';
import 'middleware/guest_middleware.dart';
import 'middleware/onboarding_middleware.dart';
import '../../features/authentication/views/login_view.dart';

abstract final class AppPages {
  static const String initial = AppRoutes.splash;

  static List<GetMiddleware> get authenticatedMiddlewares => [AuthMiddleware()];

  static List<GetMiddleware> get protectedMiddlewares => [
    AuthMiddleware(),
    OnboardingMiddleware(),
  ];

  static final List<GetPage<dynamic>> pages = [
    // ─────────────────────────────────────
    // Authentication
    // ─────────────────────────────────────
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),

    GetPage(name: AppRoutes.login, page: () => const LoginView()),

    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      middlewares: [GuestMiddleware()],
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      middlewares: [GuestMiddleware()],
    ),

    // ─────────────────────────────────────
    // Onboarding
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.pathSelector,
      page: () => const PathSelectorView(),
      binding: OnboardingBinding(),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    // ─────────────────────────────────────
    // Dashboard
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const AppShellPlaceholderView(
        title: 'Dashboard',
        route: AppRoutes.dashboard,
        description: 'Your ProPersona career workspace will appear here.',
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    // ─────────────────────────────────────
    // Resume Management
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.resumes,
      page: () => const AppShellPlaceholderView(
        title: 'My Resumes',
        route: AppRoutes.resumes,
        description: 'Create, manage and improve your resumes.',
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    GetPage(
      name: AppRoutes.createResume,
      page: () => const AppShellPlaceholderView(
        title: 'Create Resume',
        route: AppRoutes.createResume,
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    GetPage(
      name: AppRoutes.editResume,
      page: () => const AppShellPlaceholderView(
        title: 'Resume Builder',
        route: AppRoutes.editResume,
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    GetPage(
      name: AppRoutes.resumePreview,
      page: () => const AppShellPlaceholderView(
        title: 'Resume Preview',
        route: AppRoutes.resumePreview,
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    // ─────────────────────────────────────
    // AI Tools
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.aiTools,
      page: () => const AppShellPlaceholderView(
        title: 'AI Tools',
        route: AppRoutes.aiTools,
        description:
            'ATS analysis and AI-assisted career tools will appear here.',
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    GetPage(
      name: AppRoutes.atsAnalyzer,
      page: () => const RoutePlaceholderView(title: 'ATS Analyzer'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.bulletPolish,
      page: () => const RoutePlaceholderView(title: 'Bullet Point Polish'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.coverLetter,
      page: () => const RoutePlaceholderView(title: 'Cover Letter Generator'),
      middlewares: protectedMiddlewares,
    ),

    // ─────────────────────────────────────
    // Profile
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.profile,
      page: () => const AppShellPlaceholderView(
        title: 'Profile',
        route: AppRoutes.profile,
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const AppShellPlaceholderView(
        title: 'Settings',
        route: AppRoutes.settings,
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    GetPage(
      name: AppRoutes.subscription,
      page: () => const AppShellPlaceholderView(
        title: 'Subscription',
        route: AppRoutes.subscription,
      ),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    // ─────────────────────────────────────
    // Legal
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
    ),

    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const TermsAndConditionsView(),
    ),

    // ──────────────────────────────
    // Authenticated legal consent
    // ──────────────────────────────
    GetPage(
      name: AppRoutes.legalConsent,
      page: () => const LegalConsentView(),
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),

    // ─────────────────────────────────────
    // Fallback
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.notFound,
      page: () => const RoutePlaceholderView(
        title: '404',
        subtitle: 'The requested page could not be found.',
      ),
    ),
  ];

  static final GetPage<dynamic> unknownRoute = GetPage(
    name: AppRoutes.notFound,
    page: () => const RoutePlaceholderView(
      title: '404',
      subtitle: 'The requested page could not be found.',
    ),
  );
}
