import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities for better app accessibility
class AccessibilityHelper {
  /// Announce a message to screen readers
  static void announce(
    BuildContext context,
    String message, {
    TextDirection textDirection = TextDirection.ltr,
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    SemanticsService.announce(
      message,
      textDirection,
      assertiveness: assertiveness,
    );
  }

  /// Announce success message to screen readers
  static void announceSuccess(BuildContext context, String message) {
    announce(
      context,
      'Success: $message',
      assertiveness: Assertiveness.polite,
    );
  }

  /// Announce error message to screen readers
  static void announceError(BuildContext context, String message) {
    announce(
      context,
      'Error: $message',
      assertiveness: Assertiveness.assertive,
    );
  }

  /// Create semantics wrapper for buttons
  static Widget buttonSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: onTap != null,
      child: child,
    );
  }

  /// Create semantics wrapper for images
  static Widget imageSemantics({
    required Widget child,
    required String label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      image: true,
      child: child,
    );
  }

  /// Create semantics wrapper for headings
  static Widget headingSemantics({
    required Widget child,
    required String label,
  }) {
    return Semantics(
      label: label,
      header: true,
      child: child,
    );
  }

  /// Create semantics wrapper for links
  static Widget linkSemantics({
    required Widget child,
    required String label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      link: true,
      child: child,
    );
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    final data = MediaQuery.of(context);
    return data.accessibleNavigation;
  }

  /// Get recommended tap target size
  static double getMinimumTapTargetSize() {
    return 48.0; // Material Design minimum
  }

  /// Create accessible text field with proper semantics
  static Widget accessibleTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
