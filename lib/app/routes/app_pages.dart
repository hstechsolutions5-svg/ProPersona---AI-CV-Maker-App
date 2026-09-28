import 'package:get/get.dart';
import '../../core/widgets/route_placeholder_view.dart';
import 'app_routes.dart';
import 'middleware/auth_middleware.dart';
import 'middleware/onboarding_middleware.dart';

abstract final class AppPages {
  static const String initial = AppRoutes.splash;

  static List<GetMiddleware> get authenticatedMiddlewares => [AuthMiddleware()];

  static List<GetMiddleware> get protectedMiddlewares => [
    AuthMiddleware(),
    OnboardingMiddleware(),
  ];

  static final List<GetPage<dynamic>> pages = [
    // ─────────────────────────────────────
    // Bootstrap
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.splash,
      page: () => const RoutePlaceholderView(
        title: 'ProPersona',
        subtitle: 'ATS Friendly CV Maker',
      ),
    ),

    // ─────────────────────────────────────
    // Authentication
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.login,
      page: () => const RoutePlaceholderView(title: 'Login'),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => const RoutePlaceholderView(title: 'Create Account'),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const RoutePlaceholderView(title: 'Forgot Password'),
    ),

    // ─────────────────────────────────────
    // Onboarding
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.pathSelector,
      page: () => const RoutePlaceholderView(title: 'Choose Your Career Path'),
      middlewares: authenticatedMiddlewares,
    ),

    // ─────────────────────────────────────
    // Dashboard
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const RoutePlaceholderView(title: 'Dashboard'),
      middlewares: protectedMiddlewares,
    ),

    // ─────────────────────────────────────
    // Resume Management
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.resumes,
      page: () => const RoutePlaceholderView(title: 'My Resumes'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.createResume,
      page: () => const RoutePlaceholderView(title: 'Create Resume'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.editResume,
      page: () => const RoutePlaceholderView(title: 'Edit Resume'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.resumePreview,
      page: () => const RoutePlaceholderView(title: 'Resume Preview'),
      middlewares: protectedMiddlewares,
    ),

    // ─────────────────────────────────────
    // AI Tools
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.aiTools,
      page: () => const RoutePlaceholderView(title: 'AI Tools'),
      middlewares: protectedMiddlewares,
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
      page: () => const RoutePlaceholderView(title: 'Profile'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const RoutePlaceholderView(title: 'Settings'),
      middlewares: protectedMiddlewares,
    ),

    GetPage(
      name: AppRoutes.subscription,
      page: () => const RoutePlaceholderView(title: 'Subscription'),
      middlewares: protectedMiddlewares,
    ),

    // ─────────────────────────────────────
    // Legal
    // ─────────────────────────────────────
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const RoutePlaceholderView(title: 'Privacy Policy'),
    ),

    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const RoutePlaceholderView(title: 'Terms & Conditions'),
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
