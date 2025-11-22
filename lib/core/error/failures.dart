import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
    : super(message);
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

/// Failure for network-related errors
class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'Network error occurred. Please check your connection.',
  ]) : super(message);
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred'])
    : super(message);
}

/// Failure for not found errors
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
    : super(message);
}
