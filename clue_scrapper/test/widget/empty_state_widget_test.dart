import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/shared/widgets/common/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget Tests', () {
    testWidgets('Displays icon, title, and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'No Items',
              message: 'You have no items yet',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No Items'), findsOneWidget);
      expect(find.text('You have no items yet'), findsOneWidget);
    });

    testWidgets('Shows action button when provided', (tester) async {
      var actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.chat,
              title: 'No Chats',
              message: 'Start a new conversation',
              actionLabel: 'New Chat',
              onAction: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('New Chat'), findsOneWidget);

      await tester.tap(find.text('New Chat'));
      await tester.pump();

      expect(actionCalled, true);
    });

    testWidgets('Does not show button when action not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Empty',
              message: 'No action available',
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Shows custom illustration when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Custom',
              message: 'With custom illustration',
              customIllustration: Container(
                key: const Key('custom_illustration'),
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_illustration')), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsNothing); // Icon should not show
    });
  });
}
