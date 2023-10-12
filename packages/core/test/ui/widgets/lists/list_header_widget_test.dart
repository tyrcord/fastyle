// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

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
  const captionText = 'caption';

  group('FastListHeader', () {
    group('#categoryText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const FastListHeader(
            categoryText: labelText,
          )),
        );
        await tester.pumpAndSettle();

        final text = find.text(labelText.toUpperCase());
        expect(text, findsOneWidget);
      });
    });

    group('#captionText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const FastListHeader(
            categoryText: labelText,
            captionText: captionText,
          )),
        );
        await tester.pumpAndSettle();

        final text = find.text(labelText.toUpperCase());
        final caption = find.text(captionText);
        expect(text, findsOneWidget);
        expect(caption, findsOneWidget);
      });
    });
  });
}
