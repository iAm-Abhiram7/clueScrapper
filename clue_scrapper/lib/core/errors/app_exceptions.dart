/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message ${code != null ? '($code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Storage/Database exceptions
class StorageException extends AppException {
  const StorageException(
    super.message, {
    super.code,
    super.details,
  });
}

/// AI service exceptions
class AIException extends AppException {
  const AIException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Resource not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException(
    super.message, {
    super.code,
    super.details,
  });
}

/// File operation exceptions
class FileException extends AppException {
  const FileException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(
    super.message, {
    super.code,
    super.details,
  });
}
