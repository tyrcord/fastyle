// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

const _kFastBackIcon = FaIcon(FontAwesomeIcons.chevronLeft);
const _kFastDoneIcon = FaIcon(FontAwesomeIcons.check);

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
  const items = [
    FastItem(labelText: '1'),
    FastItem(labelText: '0'),
    FastItem(labelText: '2'),
    FastItem(labelText: '4'),
    FastItem(labelText: 'grappe'),
    FastItem(labelText: 'apple'),
    FastItem(labelText: 'banana'),
  ];

  group('FastSearchBar', () {
    group('#onSuggestions()', () {
      testWidgets('should be called when the search query is not empty',
          (WidgetTester tester) async {
        var called = false;
        final controller = TextEditingController();
        List<FastItem>? suggestions;
        String? searchQuery;

        await tester.pumpWidget(
          _buildApp(FastSearchBar(
            items: items,
            textEditingController: controller,
            onSuggestions: (List<FastItem<dynamic>>? items, String? query) {
              called = true;
              suggestions = items;
              searchQuery = query;
            },
          )),
        );
        await tester.pumpAndSettle();
        controller.value = const TextEditingValue(text: 'ap');

        expect(called, isTrue);
        expect(searchQuery, equals('ap'));
        expect(
          suggestions?.map((e) => e.labelText),
          containsAll(['apple', 'grappe']),
        );
      });
    });

    group('#onSearchFilter()', () {
      testWidgets('should be called when the search query is not empty',
          (WidgetTester tester) async {
        var called = false;
        final controller = TextEditingController();
        List<FastItem<dynamic>>? suggestions;
        String? searchQuery;

        await tester.pumpWidget(
          _buildApp(FastSearchBar(
            items: items,
            textEditingController: controller,
            onSearchFilter: (FastItem option, String? query) {
              called = true;

              return option.labelText == 'apple';
            },
            onSuggestions: (List<FastItem<dynamic>>? items, String? query) {
              suggestions = items;
              searchQuery = query;
            },
          )),
        );
        await tester.pumpAndSettle();
        controller.value = const TextEditingValue(text: 'ap');

        expect(called, isTrue);
        expect(searchQuery, equals('ap'));
        expect(suggestions!.length, equals(1));
        expect(
          suggestions!.map((e) => e.labelText),
          containsAll(['apple']),
        );
      });
    });

    group('#placeholderText', () {
      testWidgets('should allow to set the search placeholder text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const FastSearchBar(
            items: items,
            placeholderText: 'Search',
          )),
        );
        await tester.pumpAndSettle();

        final searchField =
            tester.firstWidget(find.byType(FastSearchField)) as FastSearchField;
        expect(find.byType(FastSearchField), findsOneWidget);
        expect(searchField.placeholderText, 'Search');
      });
    });

    group('#onLeadingButtonTap()', () {
      testWidgets('should be called when a user tap on the leading button',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(FastSearchBar(
            items: items,
            onLeadingButtonTap: () => called = true,
            placeholderText: 'Search',
          )),
        );
        await tester.pumpAndSettle();

        final finder = find.byWidget(_kFastBackIcon);

        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(called, isTrue);
      });
    });

    group('#showLeadingIcon', () {
      testWidgets('should be set to true by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const FastSearchBar(
            items: items,
          )),
        );
        await tester.pumpAndSettle();
        final finder = find.byWidget(_kFastBackIcon);

        expect(finder, findsOneWidget);
      });

      testWidgets('should not draw the leading icon when to false',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const FastSearchBar(
            items: items,
            showLeadingIcon: false,
          )),
          const Duration(milliseconds: 60),
        );

        final finder = find.byWidget(_kFastBackIcon);

        expect(finder, findsNothing);
      });
    });

    group('#clearSearchIcon', () {
      testWidgets('should draw it', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const FastSearchBar(
            items: items,
            clearSearchIcon: _kFastDoneIcon,
          )),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(_kFastDoneIcon), findsOneWidget);
      });
    });
  });
}
