abstract final class AppRoutes {
  // ─────────────────────────────────────────────
  // Bootstrap
  // ─────────────────────────────────────────────

  static const String splash = '/';

  // ─────────────────────────────────────────────
  // Authentication
  // ─────────────────────────────────────────────

  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // ─────────────────────────────────────────────
  // Onboarding
  // ─────────────────────────────────────────────

  static const String pathSelector = '/path-selector';

  // ─────────────────────────────────────────────
  // Main Application
  // ─────────────────────────────────────────────

  static const String dashboard = '/dashboard';

  // ─────────────────────────────────────────────
  // Resumes
  // ─────────────────────────────────────────────

  static const String resumes = '/resumes';

  static const String createResume = '/resumes/create';

  static const String editResume = '/resumes/:id/edit';

  static const String resumePreview = '/resumes/:id/preview';

  // ─────────────────────────────────────────────
  // AI Tools
  // ─────────────────────────────────────────────

  static const String aiTools = '/ai-tools';

  static const String atsAnalyzer = '/ai-tools/ats-analyzer';

  static const String bulletPolish = '/ai-tools/bullet-polish';

  static const String coverLetter = '/ai-tools/cover-letter';

  // ─────────────────────────────────────────────
  // User / Account
  // ─────────────────────────────────────────────

  static const String profile = '/profile';

  static const String settings = '/settings';

  static const String subscription = '/subscription';

  // ─────────────────────────────────────────────
  // Legal
  // ─────────────────────────────────────────────

  static const String privacyPolicy = '/privacy-policy';

  static const String termsAndConditions = '/terms-and-conditions';

  static const String legalConsent = '/legal-consent';

  // ─────────────────────────────────────────────
  // Error
  // ─────────────────────────────────────────────

  static const String notFound = '/not-found';

  // ─────────────────────────────────────────────
  // Dynamic Route Helpers
  // ─────────────────────────────────────────────

  static String editResumePath(String resumeId) {
    return '/resumes/$resumeId/edit';
  }

  static String resumePreviewPath(String resumeId) {
    return '/resumes/$resumeId/preview';
  }
}
