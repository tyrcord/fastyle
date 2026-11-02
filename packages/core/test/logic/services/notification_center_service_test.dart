// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

late BuildContext _context;

Widget _buildApp() {
  return FastIconHelper(
    useProIcons: false,
    child: MaterialApp(
      home: Material(
        child: Builder(
          builder: (context) {
            _context = context;

            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
}

/// Shows [message] as an error and returns how many times it is on screen
/// once its entrance animation is over.
Future<int> _notify(WidgetTester tester, String message) async {
  FastNotificationCenter.error(_context, message);

  await tester.pump();
  await tester.pump(const Duration(seconds: 1));

  final count = find.text(message).evaluate().length;

  // Let the notification hide itself before the next check.
  await tester.pumpAndSettle(const Duration(milliseconds: 100));

  return count;
}

void main() {
  group('FastNotificationCenter', () {
    setUp(FastNotificationCenter.resetThrottle);

    testWidgets('should show a message', (WidgetTester tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(await _notify(tester, 'Quote unavailable'), 1);
    });

    testWidgets('should not show the same message twice in a row', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(await _notify(tester, 'Quote unavailable'), 1);
      expect(await _notify(tester, 'Quote unavailable'), 0);
    });

    testWidgets('should still show a different message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(await _notify(tester, 'Quote unavailable'), 1);
      expect(await _notify(tester, 'An error occurred'), 1);
    });

    testWidgets('should show a repeated message again after a reset', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(await _notify(tester, 'Quote unavailable'), 1);

      FastNotificationCenter.resetThrottle();

      expect(await _notify(tester, 'Quote unavailable'), 1);
    });
  });
}
