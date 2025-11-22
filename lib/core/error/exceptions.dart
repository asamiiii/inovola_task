/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception for server-related errors
class ServerException extends AppException {
  ServerException([String message = 'Server error occurred']) : super(message);
}

/// Exception for cache-related errors
class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred']) : super(message);
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred'])
    : super(message);
}

/// Exception for validation errors
class ValidationException extends AppException {
  ValidationException([String message = 'Validation error occurred'])
    : super(message);
}

/// Exception for not found errors
class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found']) : super(message);
}
