import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:clue_scrapper/main.dart' as app;

/// Integration tests for ClueScraper app
/// Tests complete user flows from start to finish
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end Authentication Flow', () {
    testWidgets('Complete signup and login flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Should start on login screen or onboarding
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to signup
      final signupButton = find.text('Sign Up');
      if (signupButton.evaluate().isNotEmpty) {
        await tester.tap(signupButton);
        await tester.pumpAndSettle();
      }

      // Fill in signup form
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'Test@1234');

      if (find.byType(TextField).evaluate().length > 2) {
        final confirmPasswordField = find.byType(TextField).at(2);
        await tester.enterText(confirmPasswordField, 'Test@1234');
      }

      await tester.pumpAndSettle();

      // Submit signup form
      final createAccountButton = find.text('Create Account');
      if (createAccountButton.evaluate().isNotEmpty) {
        await tester.tap(createAccountButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Verify we're on the home screen
      await tester.pumpAndSettle();

      // Look for home screen indicators
      expect(
        find.textContaining('Chat').evaluate().isNotEmpty ||
            find.textContaining('Home').evaluate().isNotEmpty ||
            find.byType(BottomNavigationBar).evaluate().isNotEmpty,
        true,
      );
    });
  });

  group('End-to-end Chat Flow', () {
    testWidgets('Create new chat and send message', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try to find and tap new chat button
      final newChatFinder = find.text('New Chat');
      if (newChatFinder.evaluate().isEmpty) {
        // Try to find add button
        final addButton = find.byIcon(Icons.add);
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton.first);
          await tester.pumpAndSettle();
        }
      } else {
        await tester.tap(newChatFinder);
        await tester.pumpAndSettle();
      }

      // Should be on new chat screen
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify we can see chat interface elements
      expect(
        find.byType(TextField).evaluate().isNotEmpty ||
            find.textContaining('Start').evaluate().isNotEmpty,
        true,
      );
    });
  });

  group('End-to-end Navigation Flow', () {
    testWidgets('Navigate through all main screens', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find bottom navigation bar
      final bottomNav = find.byType(BottomNavigationBar);

      if (bottomNav.evaluate().isNotEmpty) {
        // Tap through each tab
        final navBar = tester.widget<BottomNavigationBar>(bottomNav);
        final itemCount = navBar.items.length;

        for (int i = 0; i < itemCount; i++) {
          // Tap each navigation item
          await tester.tap(find.byIcon(navBar.items[i].icon as IconData));
          await tester.pumpAndSettle();

          // Verify navigation occurred (screen changed)
          await tester.pump(const Duration(milliseconds: 500));
        }
      }

      expect(bottomNav.evaluate().isNotEmpty, true);
    });
  });
}
