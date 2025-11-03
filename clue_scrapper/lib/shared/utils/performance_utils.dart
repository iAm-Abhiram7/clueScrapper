import 'package:flutter/material.dart';

/// Performance utilities for memory management and optimization
class PerformanceUtils {
  /// Dispose multiple disposable objects at once
  static void disposeAll(List<dynamic> disposables) {
    for (final item in disposables) {
      if (item is TextEditingController ||
          item is ScrollController ||
          item is AnimationController ||
          item is FocusNode) {
        (item as dynamic).dispose();
      }
    }
  }

  /// Create a dispose helper for common controllers
  static void disposeControllers({
    List<TextEditingController>? textControllers,
    List<ScrollController>? scrollControllers,
    List<AnimationController>? animationControllers,
    List<FocusNode>? focusNodes,
  }) {
    textControllers?.forEach((c) => c.dispose());
    scrollControllers?.forEach((c) => c.dispose());
    animationControllers?.forEach((c) => c.dispose());
    focusNodes?.forEach((f) => f.dispose());
  }

  /// Check if widget is still mounted before setState
  static bool canSetState(State state) {
    return state.mounted;
  }

  /// Safe setState that checks if widget is mounted
  static void safeSetState(State state, VoidCallback fn) {
    if (state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(fn);
    }
  }

  /// Debounce function calls to reduce unnecessary executions
  static Function debounce(
    Function func, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    DateTime? lastExecution;
    
    return () {
      final now = DateTime.now();
      
      if (lastExecution == null ||
          now.difference(lastExecution!) > delay) {
        lastExecution = now;
        func();
      }
    };
  }

  /// Throttle function calls to limit execution rate
  static Function throttle(
    Function func, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    bool isThrottled = false;
    
    return () {
      if (!isThrottled) {
        func();
        isThrottled = true;
        Future.delayed(delay, () => isThrottled = false);
      }
    };
  }

  /// Calculate optimal batch size for list operations
  static int calculateBatchSize({
    required int totalItems,
    int maxBatchSize = 20,
    int minBatchSize = 5,
  }) {
    if (totalItems <= minBatchSize) return totalItems;
    if (totalItems >= maxBatchSize * 2) return maxBatchSize;
    return (totalItems / 2).ceil();
  }

  /// Memory size formatter
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
