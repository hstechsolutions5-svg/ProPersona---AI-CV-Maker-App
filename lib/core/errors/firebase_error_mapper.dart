import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_exception.dart';
import 'app_failure.dart';

abstract final class FirebaseErrorMapper {
  static AppFailure map(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error.toFailure();
    }

    if (error is FirebaseAuthException) {
      return _mapAuthException(error, stackTrace);
    }

    if (error is FirebaseFunctionsException) {
      return _mapFunctionsException(error, stackTrace);
    }

    if (error is FirebaseException) {
      return _mapFirebaseException(error, stackTrace);
    }

    return AppFailure(
      code: 'UNKNOWN_ERROR',
      message: 'Something went wrong. Please try again.',
      type: FailureType.unknown,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  static AppFailure _mapAuthException(
    FirebaseAuthException exception,
    StackTrace? stackTrace,
  ) {
    final code = exception.code;

    switch (code) {
      case 'invalid-email':
        return _failure(
          code: code,
          message: 'Please enter a valid email address.',
          type: FailureType.validation,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'weak-password':
        return _failure(
          code: code,
          message: 'Please choose a stronger password.',
          type: FailureType.validation,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'email-already-in-use':
        return _failure(
          code: code,
          message: 'An account already exists with this email address.',
          type: FailureType.conflict,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return _failure(
          code: code,
          message: 'The email or password you entered is incorrect.',
          type: FailureType.authentication,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'user-disabled':
        return _failure(
          code: code,
          message: 'This account has been disabled.',
          type: FailureType.authorization,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'too-many-requests':
        return _failure(
          code: code,
          message: 'Too many attempts were made. Please wait and try again.',
          type: FailureType.rateLimited,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'network-request-failed':
        return _failure(
          code: code,
          message: 'Please check your internet connection and try again.',
          type: FailureType.network,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'operation-not-allowed':
        return _failure(
          code: code,
          message: 'This sign-in method is currently unavailable.',
          type: FailureType.serviceUnavailable,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'requires-recent-login':
        return _failure(
          code: code,
          message: 'Please sign in again before continuing.',
          type: FailureType.authentication,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'account-exists-with-different-credential':
      case 'credential-already-in-use':
        return _failure(
          code: code,
          message:
              'This account is already associated with another sign-in method.',
          type: FailureType.conflict,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return _failure(
          code: code,
          message: 'The sign-in process was cancelled.',
          type: FailureType.cancelled,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'popup-blocked':
        return _failure(
          code: code,
          message: 'The sign-in popup was blocked by your browser.',
          type: FailureType.validation,
          cause: exception,
          stackTrace: stackTrace,
        );

      default:
        return _failure(
          code: code,
          message: 'Authentication could not be completed. Please try again.',
          type: FailureType.firebase,
          cause: exception,
          stackTrace: stackTrace,
        );
    }
  }

  static AppFailure _mapFirebaseException(
    FirebaseException exception,
    StackTrace? stackTrace,
  ) {
    final code = exception.code;

    switch (code) {
      case 'permission-denied':
        return _failure(
          code: code,
          message: 'You do not have permission to perform this action.',
          type: FailureType.authorization,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'unauthenticated':
        return _failure(
          code: code,
          message: 'Please sign in to continue.',
          type: FailureType.authentication,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'not-found':
        return _failure(
          code: code,
          message: 'The requested information could not be found.',
          type: FailureType.notFound,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'already-exists':
        return _failure(
          code: code,
          message: 'The requested item already exists.',
          type: FailureType.conflict,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'resource-exhausted':
        return _failure(
          code: code,
          message:
              'The service usage limit has been reached. Please try again later.',
          type: FailureType.rateLimited,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'deadline-exceeded':
        return _failure(
          code: code,
          message: 'The request took too long to complete. Please try again.',
          type: FailureType.timeout,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'unavailable':
        return _failure(
          code: code,
          message: 'The service is temporarily unavailable. Please try again.',
          type: FailureType.serviceUnavailable,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'cancelled':
        return _failure(
          code: code,
          message: 'The operation was cancelled.',
          type: FailureType.cancelled,
          cause: exception,
          stackTrace: stackTrace,
        );

      default:
        return _failure(
          code: code,
          message: 'A service error occurred. Please try again.',
          type: FailureType.firebase,
          cause: exception,
          stackTrace: stackTrace,
        );
    }
  }

  static AppFailure _mapFunctionsException(
    FirebaseFunctionsException exception,
    StackTrace? stackTrace,
  ) {
    final code = exception.code;

    switch (code) {
      case 'invalid-argument':
        return _failure(
          code: code,
          message: 'The request contains invalid information.',
          type: FailureType.validation,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'unauthenticated':
        return _failure(
          code: code,
          message: 'Please sign in to continue.',
          type: FailureType.authentication,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'permission-denied':
        return _failure(
          code: code,
          message: 'You do not have permission to perform this action.',
          type: FailureType.authorization,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'not-found':
        return _failure(
          code: code,
          message: 'The requested resource could not be found.',
          type: FailureType.notFound,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'already-exists':
        return _failure(
          code: code,
          message: 'The requested resource already exists.',
          type: FailureType.conflict,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'resource-exhausted':
        return _failure(
          code: code,
          message: 'Your current usage limit has been reached.',
          type: FailureType.rateLimited,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'deadline-exceeded':
        return _failure(
          code: code,
          message: 'The request timed out. Please try again.',
          type: FailureType.timeout,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'unavailable':
        return _failure(
          code: code,
          message: 'The service is temporarily unavailable.',
          type: FailureType.serviceUnavailable,
          cause: exception,
          stackTrace: stackTrace,
        );

      case 'cancelled':
        return _failure(
          code: code,
          message: 'The request was cancelled.',
          type: FailureType.cancelled,
          cause: exception,
          stackTrace: stackTrace,
        );

      default:
        return _failure(
          code: code,
          message: 'The requested operation could not be completed.',
          type: FailureType.firebase,
          cause: exception,
          stackTrace: stackTrace,
        );
    }
  }

  static AppFailure _failure({
    required String code,
    required String message,
    required FailureType type,
    required Object cause,
    StackTrace? stackTrace,
  }) {
    return AppFailure(
      code: code.toUpperCase().replaceAll('-', '_'),
      message: message,
      type: type,
      cause: cause,
      stackTrace: stackTrace,
    );
  }
}
