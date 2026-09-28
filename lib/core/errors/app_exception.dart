import 'app_failure.dart';

class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.type = FailureType.unknown,
    this.cause,
    this.stackTrace,
  });

  final String code;
  final String message;
  final FailureType type;

  final Object? cause;
  final StackTrace? stackTrace;

  AppFailure toFailure() {
    return AppFailure(
      code: code,
      message: message,
      type: type,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    return 'AppException('
        'code: $code, '
        'type: $type, '
        'message: $message'
        ')';
  }
}
