import 'package:intl/intl.dart';

/// Date and time formatting utilities
class DateFormatter {
  /// Format date as "MMM dd, yyyy" (e.g., "Jan 15, 2024")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format time as "hh:mm a" (e.g., "02:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format full datetime as "MMM dd, yyyy hh:mm a"
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  /// Format for chat timestamps (relative or absolute based on recency)
  static String formatChatTimestamp(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return formatDate(date);
    }
  }

  /// Format for message timestamps in chat
  static String formatMessageTimestamp(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return formatTime(date);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${formatTime(date)}';
    } else {
      return formatDateTime(date);
    }
  }

  /// Format report generation date
  static String formatReportDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(date);
  }

  /// Format date for file naming (safe for filenames)
  static String formatForFilename(DateTime date) {
    return DateFormat('yyyy-MM-dd_HHmmss').format(date);
  }

  /// Parse ISO 8601 string to DateTime
  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get time difference in human-readable format
  static String getTimeDifference(DateTime start, DateTime end) {
    final difference = end.difference(start);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''}';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Format relative time (alias for formatChatTimestamp for testing)
  static String formatRelative(DateTime date) {
    return formatChatTimestamp(date);
  }
}
