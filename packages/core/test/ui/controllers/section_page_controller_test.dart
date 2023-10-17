// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

const _kLoaded = 'LOADED';
const _kLoading = 'LOADING';
const _kError = 'ERROR';

FastApp _buildApp({
  Future<bool>? loadingFuture,
  Duration? loadingTimeout,
}) {
  return FastApp(
    routesForMediaType: (mediaType) => [
      GoRoute(
        path: '/',
        builder: (_, __) => FastSectionPageController(
          loadingBuilder: (context) => const FastBody(text: _kLoading),
          loadedBuilder: (context) => const FastBody(text: _kLoaded),
          errorBuilder: (context) => const FastBody(text: _kError),
          loadingTimeout: loadingTimeout,
          loadingFuture: loadingFuture,
        ),
      ),
    ],
  );
}

void main() {
  testWidgets(
    'FastSectionPageController should use contentBuilder by default',
    (WidgetTester tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final text = find.text(_kLoaded);
      expect(text, findsOneWidget);
    },
  );

  testWidgets(
    'FastSectionPageController should use contentBuilder '
    'once content is loaded',
    (WidgetTester tester) async {
      await tester.pumpWidget(_buildApp(
        loadingFuture: Future.delayed(
          const Duration(milliseconds: 80),
          () => true,
        ),
      ));

      await tester.pumpAndSettle();

      final text = find.text(_kLoaded);
      expect(text, findsOneWidget);
    },
  );

  // FIXME: https://github.com/flutter/flutter/issues/34499
  // testWidgets(
  //   'FastSectionPageController should use errorBuilder '
  //   'once content has failed to load',
  //   (WidgetTester tester) async {
  //     await tester.runAsync(() async {
  //       await tester.pumpWidget(
  //         _buildApp(
  //           loadingFuture: Future.error(_kError),
  //         ),
  //       );

  //       await tester.pumpAndSettle();

  //       final text = find.text(_kError);
  //       expect(text, findsOneWidget);
  //     });
  //   },
  // );

  // testWidgets(
  //   'FastSectionPageController should use errorBuilder '
  //   'once load timeout occurred',
  //   (WidgetTester tester) async {
  //     await tester.pumpWidget(_buildApp(
  //       loadingFuture: Future.delayed(
  //         const Duration(milliseconds: 1000),
  //         () => true,
  //       ),
  //       loadingTimeout: Duration(milliseconds: 100),
  //     ));

  //     await tester.pumpAndSettle(const Duration(milliseconds: 1000));

  //     final text = find.text(_kLoading);

  //     log('yup');
  //     expect(text, findsOneWidget);
  //     log('yuppy');

  //     await tester.pumpAndSettle();
  //   },
  // );

  testWidgets(
    'FastSectionPageController should use loadingBuilder when loading',
    (WidgetTester tester) async {
      final loadingFuture = Future<bool>.delayed(
        const Duration(milliseconds: 600),
        () => true,
      );

      await tester.pumpWidget(
        _buildApp(loadingFuture: loadingFuture),
      );

      await tester.pumpAndSettle();

      final text = find.text(_kLoading);
      expect(text, findsOneWidget);

      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      final loadedText = find.text(_kLoaded);
      expect(loadedText, findsOneWidget);
    },
  );
}
