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

  const options = [
    FastItem(labelText: 'option 1', value: 1),
    FastItem(labelText: 'option 2', value: 2),
  ];

  group('FastSegmentField', () {
    group('#labelText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastSegmentField<int>(
                labelText: labelText,
                options: options,
              ),
            ],
          )),
        );

        await tester.pumpAndSettle();

        final text = find.text('Label');
        expect(text, findsOneWidget);
      });
    });

    group('#options', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastSegmentField<int>(
                labelText: labelText,
                options: options,
              ),
            ],
          )),
        );

        await tester.pumpAndSettle();

        final segements = find.byType(FastBody);
        expect(segements, findsNWidgets(2));
      });
    });

    group('#onValueChanged()', () {
      testWidgets('should be called when the toggle switch is used',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastSegmentField<int>(
                onValueChanged: (dynamic value) => called = true,
                labelText: labelText,
                options: options,
              ),
            ],
          )),
        );

        await tester.pumpAndSettle();

        final finder = find.widgetWithText(FastBody, 'option 2');

        await tester.tap(finder);
        await tester.pumpAndSettle();

        final option = tester.firstWidget(finder) as FastBody;

        expect(option.textColor, equals(const Color(0xFFfcfcfc)));
        expect(called, isTrue);
      });
    });

    group('#selectedIndex', () {
      testWidgets('should select the first segment by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastSegmentField<int>(
                labelText: labelText,
                options: options,
              ),
            ],
          )),
        );

        await tester.pumpAndSettle();

        final option1 = tester.firstWidget(find.byType(FastBody)) as FastBody;
        expect(option1.textColor, equals(const Color(0xFFfcfcfc)));
      });

      testWidgets('should select the second segment by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastSegmentField<int>(
                labelText: labelText,
                options: options,
                selectedIndex: 1,
              ),
            ],
          )),
        );

        await tester.pumpAndSettle();

        final finder = find.widgetWithText(FastBody, 'option 2');
        final option = tester.firstWidget(finder) as FastBody;

        expect(option.textColor, equals(const Color(0xFFfcfcfc)));
      });
    });
  });
}
