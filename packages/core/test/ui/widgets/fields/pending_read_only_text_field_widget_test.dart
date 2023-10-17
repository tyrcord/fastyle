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
  const labelText = 'label';

  group('FastPendingReadOnlyTextField', () {
    group('#valueText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastPendingReadOnlyTextField(
                labelText: labelText,
                valueText: '42',
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        final text = find.text('42');
        expect(text, findsOneWidget);
      });
    });

    group('#placeholderText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastPendingReadOnlyTextField(
                labelText: labelText,
                placeholderText: '42',
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        final text = find.text('42');
        expect(text, findsOneWidget);
      });
    });

    group('#pendingText', () {
      testWidgets('should not draw it by default when set',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastPendingReadOnlyTextField(
                labelText: labelText,
                pendingText: '42',
                isPending: false,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        final text = find.text('42');
        expect(text, findsNothing);
      });
    });
  });
}
