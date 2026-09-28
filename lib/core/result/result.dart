import '../errors/app_failure.dart';

part 'failure.dart';
part 'success.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  T? get dataOrNull {
    return switch (this) {
      Success<T>(data: final data) => data,
      Failure<T>() => null,
    };
  }

  AppFailure? get failureOrNull {
    return switch (this) {
      Success<T>() => null,
      Failure<T>(failure: final failure) => failure,
    };
  }

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),

      Failure<T>(failure: final failure) => onFailure(failure),
    };
  }
}
