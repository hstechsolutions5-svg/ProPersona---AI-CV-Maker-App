import 'app_environment.dart';

abstract final class EnvironmentConfig {
  static const String _environmentValue = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static final AppEnvironment environment = AppEnvironment.fromString(
    _environmentValue,
  );

  static bool get isDevelopment => environment == AppEnvironment.development;

  static bool get isStaging => environment == AppEnvironment.staging;

  static bool get isProduction => environment == AppEnvironment.production;

  static String get name => environment.name;
}
