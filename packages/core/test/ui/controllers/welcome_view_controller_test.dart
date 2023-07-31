// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

const _kPending = 'pending';
const _kResumed = 'resumed';

FastApp _buildApp(
  ValueListenable<bool> valueListenable,
) {
  return FastApp(
    homeBuilder: (_) => ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (BuildContext context, bool isPending, Widget? child) {
        var text = isPending ? _kPending : _kResumed;

        return Text('$text');
      },
    ),
  );
}

void main() {
  late FastOnboardingViewController controller;

  setUp(() {
    controller = FastOnboardingViewController();
  });

  group('FastOnboardingViewController', () {
    testWidgets(
      'controller default value should be set to false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(controller),
        );

        await tester.pumpAndSettle();
        final text = find.text(_kResumed);
        expect(text, findsOneWidget);
      },
    );

    testWidgets(
      '#pause() should set controller value to true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(controller),
        );

        await tester.pumpAndSettle();

        controller.pause();
        await tester.pumpAndSettle();

        final text = find.text(_kPending);
        expect(text, findsOneWidget);
      },
    );

    testWidgets(
      '#resume() should set controller value to false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(controller),
        );

        await tester.pumpAndSettle();
        controller.resume();
        await tester.pumpAndSettle();

        final text = find.text(_kResumed);
        expect(text, findsOneWidget);
      },
    );
  });
}
