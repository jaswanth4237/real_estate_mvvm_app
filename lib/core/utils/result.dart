import '../error/failures.dart';

/// A discriminated union representing the outcome of an operation.
///
/// An operation either returns a [Success] containing the result value [T],
/// or a [FailureResult] containing a domain [Failure].
///
/// Use [fold] to handle both cases ergonomically, or check [isSuccess] /
/// [isFailure] before accessing [data] or [failure].
abstract class Result<T> {
  const Result();

  /// Returns `true` if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this is a [FailureResult].
  bool get isFailure => this is FailureResult<T>;

  /// The success value. Throws a [TypeError] if called on a [FailureResult].
  T get data => (this as Success<T>).value;

  /// The domain failure. Throws a [TypeError] if called on a [Success].
  Failure get failure => (this as FailureResult<T>).error;

  /// Transforms this [Result] into a value of type [R].
  ///
  /// [onSuccess] is called with the unwrapped value when this is [Success].
  /// [onFailure] is called with the [Failure] when this is [FailureResult].
  R fold<R>(R Function(T data) onSuccess, R Function(Failure failure) onFailure) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as FailureResult<T>).error);
    }
  }
}

/// A [Result] subtype representing a successful operation.
class Success<T> extends Result<T> {
  /// The unwrapped success value.
  final T value;
  const Success(this.value);
}

/// A [Result] subtype representing a failed operation.
class FailureResult<T> extends Result<T> {
  /// The domain failure describing what went wrong.
  final Failure error;
  const FailureResult(this.error);
}
