// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(Widget child) {
  return FastApp(homeBuilder: (_) => child);
}

void main() {
  const labelText = 'label';
  const labelTextCapitalized = 'Label';
  const captionText = 'caption';
  const captionTextCapitalized = 'Caption';
  const helperText = 'helper';
  const helperTextCapitalized = 'Helper';
  const control = Text('control');

  group('FastFieldLayout', () {
    group('#control', () {
      testWidgets('should be drawn', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastFieldLayout(
            labelText: labelText,
            control: control,
          )),
        );

        await tester.pumpAndSettle();

        final field = find.byType(FastFieldLayout);
        expect(field, findsOneWidget);
      });
    });

    group('#labelText', () {
      testWidgets('should be capitalized by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastFieldLayout(
            labelText: labelText,
            control: control,
          )),
        );

        await tester.pumpAndSettle();

        final text = find.text(labelTextCapitalized);
        expect(text, findsOneWidget);
      });
    });

    group('#capitalizeLabelText', () {
      testWidgets(
        'should not capitalized the label it\'s set to false',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            _buildApp(FastFieldLayout(
              labelText: labelText,
              capitalizeLabelText: false,
              control: control,
            )),
          );

          await tester.pumpAndSettle();

          final text = find.text(labelText);
          expect(text, findsOneWidget);
        },
      );
    });

    group('#captionText', () {
      testWidgets('should be drawn when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastFieldLayout(
            labelText: labelText,
            captionText: captionText,
            control: control,
          )),
        );

        await tester.pumpAndSettle();

        final text = find.text(captionTextCapitalized);
        expect(text, findsOneWidget);
      });
    });

    group('#helperText', () {
      testWidgets('should be drawn when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastFieldLayout(
            helperText: helperText,
            control: control,
          )),
        );

        await tester.pumpAndSettle();

        final text = find.text(helperTextCapitalized);
        expect(text, findsOneWidget);
      });
    });

    group('#suffixIcon', () {
      testWidgets('should be drawn when set', (WidgetTester tester) async {
        var icon = Icon(Icons.access_alarm);

        await tester.pumpWidget(
          _buildApp(FastFieldLayout(
            suffixIcon: icon,
            control: control,
          )),
        );

        await tester.pumpAndSettle();

        final iconFound = find.byWidget(icon);
        expect(iconFound, findsOneWidget);
      });
    });

    group('#helperTextColor', () {
      testWidgets('should set helper text color', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastFieldLayout(
            helperText: helperText,
            helperTextColor: Colors.red,
            control: control,
          )),
        );

        await tester.pumpAndSettle();

        final text = find.text(helperTextCapitalized);
        final helper = tester.firstWidget(text) as Text;

        expect(helper.style!.color, equals(Colors.red));
      });
    });
  });
}
