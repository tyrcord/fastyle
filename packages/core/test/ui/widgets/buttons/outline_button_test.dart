// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(Widget child) {
  return FastApp(
    routesForMediaType: (mediaType) => [
      GoRoute(
        path: '/',
        builder: (_, __) => Material(
          child: child,
        ),
      ),
    ],
  );
}

void main() {
  group('FastOutlineButton', () {
    const buttonText = 'BUTTON';

    testWidgets('should draw its text', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildApp(const FastOutlineButton(
          onTap: noop,
          text: buttonText,
        )),
      );

      await tester.pumpAndSettle();

      final button = find.byType(FastOutlineButton);
      final text = find.text(buttonText);

      expect(button, findsOneWidget);
      expect(text, findsOneWidget);
    });

    testWidgets('should draw its child', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildApp(const FastOutlineButton(
          onTap: noop,
          child: Text(buttonText),
        )),
      );
      await tester.pumpAndSettle();

      final button = find.byType(FastOutlineButton);
      final text = find.text(buttonText);

      expect(button, findsOneWidget);
      expect(text, findsOneWidget);
    });

    testWidgets('should react to user interactions',
        (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildApp(FastOutlineButton(
          text: buttonText,
          onTap: () {
            tapped = true;
          },
        )),
      );

      await tester.pumpAndSettle();

      final button = find.byType(FastOutlineButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should react to user interactions if disabled',
        (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildApp(FastOutlineButton(
          text: buttonText,
          onTap: () {
            tapped = true;
          },
          isEnabled: false,
        )),
      );

      await tester.pumpAndSettle();

      final button = find.byType(FastOutlineButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('should should trottle time if required',
        (WidgetTester tester) async {
      var count = 0;

      await tester.pumpWidget(
        _buildApp(FastOutlineButton(
          text: buttonText,
          onTap: () {
            count++;
          },
          shouldTrottleTime: true,
        )),
      );

      await tester.pumpAndSettle();

      final button = find.byType(FastOutlineButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();

      expect(count, equals(1));
    });

    testWidgets('should should trottle time for a certain amount of time',
        (WidgetTester tester) async {
      var count = 0;

      await tester.pumpWidget(
        _buildApp(FastOutlineButton(
          text: buttonText,
          onTap: () {
            count++;
          },
          shouldTrottleTime: true,
          trottleTimeDuration: const Duration(milliseconds: 500),
        )),
      );

      await tester.pumpAndSettle();

      final button = find.byType(FastOutlineButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(button);
      await tester.pump();

      expect(count, equals(2));
    });
  });
}
