// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(Widget child) {
  return FastApp(
      homeBuilder: (_) => FastHomePage(
            children: [child],
          ));
}

void main() {
  const labelText = 'label';

  group('FastReadOnlyTextField', () {
    group('#valueText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastReadOnlyTextField(
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
              FastReadOnlyTextField(
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

    group('#child', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastReadOnlyTextField(
                labelText: labelText,
                child: Text('42'),
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        final text = find.text('42');
        expect(text, findsOneWidget);
      });
    });
  });
}