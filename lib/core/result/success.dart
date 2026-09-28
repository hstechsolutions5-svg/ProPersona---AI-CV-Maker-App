part of 'result.dart';

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  String toString() {
    return 'Success<$T>($data)';
  }
}
