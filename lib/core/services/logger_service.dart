import 'dart:developer' as developer;

import 'package:get/get.dart';

import '../config/environment_config.dart';

enum AppLogLevel { debug, info, warning, error }

class LoggerService extends GetxService {
  static const String _defaultName = 'ProPersona';

  void debug(String message, {String name = _defaultName}) {
    _write(AppLogLevel.debug, message, name: name);
  }

  void info(String message, {String name = _defaultName}) {
    _write(AppLogLevel.info, message, name: name);
  }

  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = _defaultName,
  }) {
    _write(
      AppLogLevel.warning,
      message,
      error: error,
      stackTrace: stackTrace,
      name: name,
    );
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = _defaultName,
  }) {
    _write(
      AppLogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      name: name,
    );
  }

  void _write(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    required String name,
  }) {
    if (!_shouldLog(level)) {
      return;
    }

    final isProduction = EnvironmentConfig.isProduction;

    developer.log(
      message,
      name: name,
      level: _developerLevel(level),

      // Avoid exposing detailed exception
      // information in production logs.
      error: isProduction ? null : error,

      stackTrace: isProduction ? null : stackTrace,
    );
  }

  bool _shouldLog(AppLogLevel level) {
    if (!EnvironmentConfig.isProduction) {
      return true;
    }

    return switch (level) {
      AppLogLevel.warning || AppLogLevel.error => true,

      AppLogLevel.debug || AppLogLevel.info => false,
    };
  }

  int _developerLevel(AppLogLevel level) {
    return switch (level) {
      AppLogLevel.debug => 500,
      AppLogLevel.info => 800,
      AppLogLevel.warning => 900,
      AppLogLevel.error => 1000,
    };
  }
}
