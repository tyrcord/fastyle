// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(FastOnboardingView onboarding) {
  return FastApp(homeBuilder: (_) => onboarding);
}

void main() {
  const slideText1 = 'slide 1';
  const slideText2 = 'slide 2';
  const slide1 = Text(slideText1);
  const slide2 = Text(slideText2);

  group('FastOnboardingView', () {
    group('#slides', () {
      testWidgets('should display the first slide',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
          )),
        );
        await tester.pumpAndSettle();

        final child = find.byWidget(slide1);

        expect(child, findsOneWidget);
      });

      testWidgets('should display the second slide after tapping on next',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('next'));
        await tester.pumpAndSettle();
        final child = find.byWidget(slide2);

        expect(child, findsOneWidget);
      });
    });

    group('#allowToSkip', () {
      testWidgets('should be set to false by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text('skip'), findsNothing);
      });

      testWidgets('should allow to skip the onboarding view when set to true',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
            allowToSkip: true,
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text('skip'), findsOneWidget);
      });

      testWidgets(
          'should not displayed a skip option when there is only one slide',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1],
            allowToSkip: true,
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text('skip'), findsNothing);
      });
    });

    group('#doneText', () {
      testWidgets('should allow to override the done label',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1],
            doneText: 'OK',
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text('OK'), findsOneWidget);
      });
    });

    group('#nextText', () {
      testWidgets('should allow to override the next label',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
            nextText: 'CONTINUE',
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text('CONTINUE'), findsOneWidget);
      });
    });

    group('#skipText', () {
      testWidgets('should allow to override the skip label',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
            allowToSkip: true,
            skipText: 'PASS',
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text('PASS'), findsOneWidget);
      });
    });

    group('#onDone', () {
      testWidgets('should allow to override the done label',
          (WidgetTester tester) async {
        var done = false;

        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1],
            onDone: () => done = true,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('done'));
        await tester.pumpAndSettle();

        expect(done, isTrue);
      });
    });

    group('#onSkip', () {
      testWidgets('should allow to override the done label',
          (WidgetTester tester) async {
        var skipped = false;

        await tester.pumpWidget(
          _buildApp(FastOnboardingView(
            slides: [slide1, slide2],
            allowToSkip: true,
            onSkip: () => skipped = true,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('skip'));
        await tester.pumpAndSettle();

        expect(skipped, isTrue);
      });
    });
  });
}
