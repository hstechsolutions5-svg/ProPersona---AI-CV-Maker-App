enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment fromString(String value) {
    switch (value.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;

      case 'staging':
        return AppEnvironment.staging;

      case 'development':
      case 'dev':
      default:
        return AppEnvironment.development;
    }
  }
}
