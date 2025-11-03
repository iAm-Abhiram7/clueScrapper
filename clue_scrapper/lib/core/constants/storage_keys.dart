/// Storage keys for Hive boxes and secure storage
class StorageKeys {
  // Hive Box Names
  static const String userBox = 'user_box';
  static const String chatBox = 'chat_box';
  static const String messageBox = 'message_box';
  static const String evidenceBox = 'evidence_box';
  static const String reportBox = 'report_box';

  // Secure Storage Keys
  static const String currentUserIdKey = 'current_user_id';
  static const String authTokenKey = 'auth_token';
  static const String isLoggedInKey = 'is_logged_in';
  static const String lastLoginKey = 'last_login';
  static const String geminiApiKey = 'gemini_api_key';

  // Preferences Keys
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String autoSaveEnabled = 'auto_save_enabled';

  // Cache Keys
  static const String lastSyncTime = 'last_sync_time';
  static const String cacheVersion = 'cache_version';
}
