/// Custom exceptions for ClueScraper application

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppException: $message ${code != null ? '(Code: $code)' : ''}';
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.details});

  @override
  String toString() => 'StorageException: $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.details});

  @override
  String toString() => 'AuthException: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});

  @override
  String toString() => 'NetworkException: $message';
}

/// AI service exceptions
class AIException extends AppException {
  const AIException(super.message, {super.code, super.details});

  @override
  String toString() => 'AIException: $message';
}

/// Data validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.details});

  @override
  String toString() => 'ValidationException: $message';
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.details});

  @override
  String toString() => 'NotFoundException: $message';
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.details});

  @override
  String toString() => 'PermissionException: $message';
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.details});

  @override
  String toString() => 'CacheException: $message';
}

/// File system exceptions
class FileSystemException extends AppException {
  const FileSystemException(super.message, {super.code, super.details});

  @override
  String toString() => 'FileSystemException: $message';
}
