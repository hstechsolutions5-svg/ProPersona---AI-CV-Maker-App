abstract final class AppRoutes {
  static const String splash = '/';

  static const String login = '/login';

  static const String signup = '/signup';

  static const String forgotPassword = '/forgot-password';

  static const String pathSelector = '/path-selector';

  static const String legalConsent = '/legal-consent';

  static const String dashboard = '/dashboard';

  static const String resumes = '/resumes';

  static const String createResume = '/resumes/create';

  static const String editResume = '/resumes/:id/edit';

  static const String resumePreview = '/resumes/:id/preview';

  static const String aiTools = '/ai-tools';

  static const String atsAnalyzer = '/ai-tools/ats-analyzer';

  static const String bulletPolish = '/ai-tools/bullet-polish';

  static const String coverLetter = '/ai-tools/cover-letter';

  static const String profile = '/profile';

  static const String settings = '/settings';

  static const String subscription = '/subscription';

  static const String privacyPolicy = '/privacy-policy';

  static const String termsAndConditions = '/terms-and-conditions';

  static const String notFound = '/not-found';

  static String editResumePath(String resumeId) {
    return '/resumes/$resumeId/edit';
  }

  static String resumePreviewPath(String resumeId) {
    return '/resumes/$resumeId/preview';
  }
}
