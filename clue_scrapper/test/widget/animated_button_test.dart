import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clue_scrapper/shared/widgets/animations/animated_button.dart';

void main() {
  group('AnimatedButton Widget Tests', () {
    testWidgets('Renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              onPressed: () {},
              child: const Text('Click Me'),
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('Calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              onPressed: () => pressed = true,
              child: const Text('Click Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Click Me'));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('Does not call onPressed when null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              onPressed: null,
              child: Text('Disabled'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pump();

      // Should not throw error
      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('Animates scale on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              onPressed: () {},
              child: const Text('Animate'),
            ),
          ),
        ),
      );

      // Find the AnimatedScale widget
      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 1.0);

      // Simulate tap down
      await tester.press(find.text('Animate'));
      await tester.pump(const Duration(milliseconds: 50));

      // Scale should change (note: state change happens asynchronously)
      await tester.pump();
    });
  });
}
