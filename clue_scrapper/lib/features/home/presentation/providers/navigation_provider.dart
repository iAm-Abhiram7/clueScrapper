import 'package:flutter/foundation.dart';

/// Provider for managing bottom navigation state
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  /// Set the current tab index
  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
      debugPrint('NavigationProvider: Tab changed to index $index');
    }
  }

  /// Navigate to specific tab
  void navigateToTab(int index) {
    setIndex(index);
  }

  /// Quick navigation to new chat tab
  void navigateToNewChat() {
    setIndex(0); // Assuming new chat is at index 0
  }

  /// Get current tab name for analytics
  String getCurrentTabName() {
    switch (_currentIndex) {
      case 0:
        return 'Chats';
      case 1:
        return 'Reports';
      case 2:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  /// Reset to home tab
  void resetToHome() {
    setIndex(0);
  }
}
