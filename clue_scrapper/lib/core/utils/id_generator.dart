import 'package:uuid/uuid.dart';

/// ID generation utilities using UUID
class IdGenerator {
  static const Uuid _uuid = Uuid();

  /// Generate a unique user ID
  static String generateUserId() {
    return 'user_${_uuid.v4()}';
  }

  /// Generate a unique chat ID
  static String generateChatId() {
    return 'chat_${_uuid.v4()}';
  }

  /// Generate a unique message ID
  static String generateMessageId() {
    return 'msg_${_uuid.v4()}';
  }

  /// Generate a unique evidence ID
  static String generateEvidenceId() {
    return 'evidence_${_uuid.v4()}';
  }

  /// Generate a unique report ID
  static String generateReportId() {
    return 'report_${_uuid.v4()}';
  }

  /// Generate a generic UUID without prefix
  static String generateUuid() {
    return _uuid.v4();
  }

  /// Generate a timestamped ID for file naming
  static String generateTimestampedId(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$timestamp';
  }

  /// Validate UUID format
  static bool isValidUuid(String id) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    // Remove prefix if present
    final uuidPart = id.contains('_') ? id.split('_').last : id;

    return uuidRegex.hasMatch(uuidPart);
  }
}
