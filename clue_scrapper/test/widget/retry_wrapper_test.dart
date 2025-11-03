import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/shared/widgets/common/retry_wrapper.dart';
import 'package:clue_scrapper/core/errors/app_exceptions.dart';

void main() {
  group('RetryWrapper Widget Tests', () {
    testWidgets('Shows child when no error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWrapper(
              onRetry: () async {},
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWrapper(
              onRetry: () async {},
              isLoading: true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Content'), findsNothing);
    });

    testWidgets('Shows error UI when error is present', (tester) async {
      const error = NetworkException('Connection failed');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWrapper(
              onRetry: () async {},
              error: error,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Content'), findsNothing);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('Calls onRetry when retry button tapped', (tester) async {
      var retryCalled = false;
      const error = NetworkException('Connection failed');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWrapper(
              onRetry: () async => retryCalled = true,
              error: error,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, true);
    });

    testWidgets('Shows custom error message when provided', (tester) async {
      const error = NetworkException('Connection failed');
      const customMessage = 'Custom error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWrapper(
              onRetry: () async {},
              error: error,
              customMessage: customMessage,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.textContaining('Custom error message'), findsOneWidget);
    });
  });
}
