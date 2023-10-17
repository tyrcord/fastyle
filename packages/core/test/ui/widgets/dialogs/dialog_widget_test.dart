// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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
  group('FastDialog', () {
    const titleText = 'dialog';

    testWidgets('should draw its title', (WidgetTester tester) async {
      final children = [const Text('42')];

      await tester.pumpWidget(
        _buildApp(FastDialog(
          titleText: titleText,
          children: children,
        )),
      );

      await tester.pumpAndSettle();

      final text = find.text(titleText);

      expect(text, findsOneWidget);
    });

    testWidgets('should draw its children', (WidgetTester tester) async {
      final children = [const Text('42')];

      await tester.pumpWidget(
        _buildApp(FastDialog(
          titleText: titleText,
          children: children,
        )),
      );

      await tester.pumpAndSettle();

      final dialog = find.byType(FastDialog);

      expect(dialog, findsOneWidget);
    });
  });
}
