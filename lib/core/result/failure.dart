part of 'result.dart';

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;

  @override
  String toString() {
    return 'Failure<$T>($failure)';
  }
}
