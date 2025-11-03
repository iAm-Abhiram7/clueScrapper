import 'package:flutter/material.dart';
import 'app_exceptions.dart';
import '../utils/app_logger.dart';

/// Global error handler for user-friendly error messages and retry logic
class ErrorHandler {
  /// Convert technical exceptions to user-friendly messages
  static String getUserFriendlyMessage(Object error) {
    AppLogger.error('Converting error to user message', error);

    if (error is NetworkException) {
      return 'Unable to connect. Please check your internet connection.';
    } else if (error is AuthException) {
      return 'Authentication failed. Please try logging in again.';
    } else if (error is StorageException) {
      return 'Failed to save data. Please try again.';
    } else if (error is AIException) {
      return 'AI service unavailable. Please try again later.';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is NotFoundException) {
      return 'Requested data not found.';
    } else if (error is PermissionException) {
      return 'Permission denied. Please grant necessary permissions.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Show error in SnackBar with consistent styling
  static void showErrorSnackBar(BuildContext context, Object error) {
    final message = getUserFriendlyMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFB85C5C), // Error color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success message in SnackBar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF87A878), // Success color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show warning message in SnackBar
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD4A574), // Warning color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show info message in SnackBar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5C8CA8), // Info color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
