import 'package:fastyle_text/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets(
    'FastAnimatedNumberText initializes with a value of 0',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: FastAnimatedNumberText(endValue: 50),
      ));

      expect(find.text('0'), findsOneWidget);
    },
  );

  testWidgets(
    'FastAnimatedNumberText animates to the specified endValue',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: FastAnimatedNumberText(endValue: 50),
      ));

      // Wait for the animation to finish
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('50'), findsOneWidget);
    },
  );

  testWidgets(
    'FastAnimatedNumberText uses the provided text styling properties',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: FastAnimatedNumberText(
          endValue: 100,
          textColor: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ));

      final textFinder = find.byType(Text);
      final Text textWidget = tester.widget(textFinder);
      expect(textWidget.style?.color, Colors.red);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    },
  );
}
