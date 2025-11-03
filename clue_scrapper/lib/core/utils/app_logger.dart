import 'package:flutter/foundation.dart';

/// Centralized logging utility for the application
/// Provides structured logging with different severity levels
class AppLogger {
  static const bool _enableLogging = kDebugMode; // Auto-disable in production

  /// Log informational messages
  static void info(String message, [String? tag]) {
    if (_enableLogging) {
      debugPrint('ℹ️ ${tag ?? 'INFO'}: $message');
    }
  }

  /// Log error messages with optional error object and stack trace
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (_enableLogging) {
      debugPrint('❌ ERROR: $message');
      if (error != null) debugPrint('Error details: $error');
      if (stackTrace != null) debugPrint('Stack trace: $stackTrace');
    }
    // TODO: In production, send to crash reporting service (Firebase Crashlytics, Sentry)
  }

  /// Log success messages
  static void success(String message, [String? tag]) {
    if (_enableLogging) {
      debugPrint('✅ ${tag ?? 'SUCCESS'}: $message');
    }
  }

  /// Log warning messages
  static void warning(String message, [String? tag]) {
    if (_enableLogging) {
      debugPrint('⚠️ ${tag ?? 'WARNING'}: $message');
    }
  }

  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (_enableLogging && kDebugMode) {
      debugPrint('🔍 ${tag ?? 'DEBUG'}: $message');
    }
  }

  /// Log network-related messages
  static void network(String message, {String? method, String? endpoint}) {
    if (_enableLogging) {
      final prefix = method != null ? '[$method]' : '';
      final url = endpoint ?? '';
      debugPrint('🌐 NETWORK $prefix $url: $message');
    }
  }

  /// Log database operations
  static void database(String message, [String? operation]) {
    if (_enableLogging) {
      debugPrint('💾 DATABASE ${operation ?? ''}: $message');
    }
  }

  /// Log navigation events
  static void navigation(String message, [String? route]) {
    if (_enableLogging) {
      debugPrint('🧭 NAVIGATION ${route ?? ''}: $message');
    }
  }
}
