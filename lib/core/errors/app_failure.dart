enum FailureType {
  validation,
  authentication,
  authorization,
  notFound,
  conflict,
  network,
  timeout,
  rateLimited,
  cancelled,
  serviceUnavailable,
  firebase,
  unknown,
}

class AppFailure {
  const AppFailure({
    required this.code,
    required this.message,
    required this.type,
    this.cause,
    this.stackTrace,
  });

  final String code;
  final String message;
  final FailureType type;

  final Object? cause;
  final StackTrace? stackTrace;

  bool get isRetryable {
    return switch (type) {
      FailureType.network ||
      FailureType.timeout ||
      FailureType.rateLimited ||
      FailureType.serviceUnavailable => true,

      _ => false,
    };
  }

  @override
  String toString() {
    return 'AppFailure('
        'code: $code, '
        'type: $type, '
        'message: $message'
        ')';
  }
}
