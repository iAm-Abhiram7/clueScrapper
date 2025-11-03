/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'ClueScraper';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-Powered Forensic Analysis Tool';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);

  // Limits
  static const int maxImagesPerChat = 10;
  static const int maxMessageLength = 5000;
  static const int maxChatHistory = 100;
  static const int passwordMinLength = 8;
  static const int emailMaxLength = 100;

  // Image Constraints
  static const int maxImageSizeMB = 10;
  static const int imageQuality = 85;
  static const double maxImageWidth = 1920;
  static const double maxImageHeight = 1080;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Session
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration autoSaveInterval = Duration(seconds: 30);

  // Evidence Types
  static const List<String> evidenceTypes = [
    'weapon',
    'biological',
    'document',
    'fingerprint',
    'digital',
    'trace',
    'other',
  ];

  // Chat Status
  static const String chatStatusActive = 'active';
  static const String chatStatusArchived = 'archived';
  static const String chatStatusDeleted = 'deleted';

  // Confidence Levels
  static const double confidenceHigh = 0.8;
  static const double confidenceMedium = 0.5;
  static const double confidenceLow = 0.3;
}
