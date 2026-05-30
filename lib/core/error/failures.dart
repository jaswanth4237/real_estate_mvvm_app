import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
///
/// Subclasses represent specific failure categories (network, cache, etc.).
/// Use the [message] field to surface human-readable error descriptions in the UI.
abstract class Failure extends Equatable {
  /// A human-readable description of the failure.
  final String message;

  /// Creates a [Failure] with the given [message].
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Indicates a failure originating from the remote server.
class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with an optional custom [message].
  const ServerFailure([String message = 'Server Error']) : super(message);
}

/// Indicates a failure reading from or writing to the local cache.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with an optional custom [message].
  const CacheFailure([String message = 'Cache Error']) : super(message);
}

/// Indicates a network connectivity failure.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure] with an optional custom [message].
  const NetworkFailure([String message = 'No Internet Connection'])
      : super(message);
}

/// Indicates a data validation failure.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with an optional custom [message].
  const ValidationFailure([String message = 'Validation Error']) : super(message);
}
