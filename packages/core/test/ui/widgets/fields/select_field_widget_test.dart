// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(FastSelectField child) {
  return FastApp(homeBuilder: (_) => child);
}

void main() {
  const labelText = 'label';
  const numbersCategory = FastCategory(
    labelText: 'Numbers',
    valueText: 'numbers',
    weight: 1,
  );
  const fruitsCategory = FastCategory(
    labelText: 'Fruits',
    valueText: 'fruit',
    weight: 2,
  );
  const items = [
    FastItem(labelText: '1', categories: [numbersCategory]),
    FastItem(labelText: '0', categories: [numbersCategory]),
    FastItem(labelText: '2', categories: [numbersCategory]),
    FastItem(labelText: '4', categories: [numbersCategory]),
    FastItem(labelText: 'grappe', categories: [fruitsCategory]),
    FastItem(labelText: 'apple', categories: [fruitsCategory]),
    FastItem(labelText: 'banana', categories: [fruitsCategory]),
  ];

  const categories = [numbersCategory, fruitsCategory];

  group('FastSelectField', () {
    group('#items', () {
      testWidgets('should draw its items', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final listItems = find.byType(FastSelectableListItem);
        expect(listItems, findsNWidgets(7));
      });
    });

    group('#onSelectionChanged()', () {
      testWidgets('should be called when a user select an item',
          (WidgetTester tester) async {
        var called = false;
        FastItem<dynamic>? selection;

        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {
              called = true;
              selection = item;
            },
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        var listItems = find.byType(FastSelectableListItem);

        await tester.tap(listItems.first);
        expect(called, isTrue);
      });

      testWidgets('should close the search page when a user select an item',
          (WidgetTester tester) async {
        var called = false;
        FastItem<dynamic>? selection;

        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {
              called = true;
              selection = item;
            },
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        var listItems = find.byType(FastSelectableListItem);

        await tester.tap(listItems.first);
        await tester.pumpAndSettle();

        expect(called, isTrue);
        expect(selection!.labelText, '0');

        listItems = find.byType(FastSelectableListItem);
        expect(listItems, findsNothing);

        expect(find.text('0'), findsOneWidget);
      });
    });

    group('#groupByCategory', () {
      testWidgets('should group items by categories when set to true',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final allText = find.text('All');
        final fruitsText = find.text('Fruits');
        final numbersText = find.text('Numbers');

        expect(allText, findsOneWidget);
        expect(fruitsText, findsOneWidget);
        expect(numbersText, findsOneWidget);
      });
    });

    group('#allCategoryText', () {
      testWidgets('should be used for the "All" category',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            allCategoryText: 'Toutes',
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final allText = find.text('Toutes');
        final fruitsText = find.text('Fruits');
        final numbersText = find.text('Numbers');
        expect(allText, findsOneWidget);
        expect(fruitsText, findsOneWidget);
        expect(numbersText, findsOneWidget);
      });
    });

    group('#searchPlaceholderText', () {
      testWidgets('should allow to set the search placeholder text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            items: items,
            searchPlaceholderText: 'Search',
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final searchField =
            tester.firstWidget(find.byType(FastSearchField)) as FastSearchField;
        expect(find.byType(FastSearchField), findsOneWidget);
        expect(searchField.placeholderText, 'Search');
      });
    });

    group('#canClearSelection', () {
      testWidgets('should be set to true by default',
          (WidgetTester tester) async {
        var called = false;
        FastItem<dynamic>? selection;

        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {
              called = true;
              selection = item;
            },
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        var listItems = find.byType(FastSelectableListItem);

        await tester.tap(listItems.first);
        await tester.pumpAndSettle();

        expect(called, isTrue);
        expect(selection!.labelText, '0');
        expect(find.text('0'), findsOneWidget);

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();
        expect(find.byType(FastSelectableListItem), findsNWidgets(7));

        final link =
            tester.firstWidget(find.byType(FastTextButton)) as FastTextButton;
        expect(find.byType(FastTextButton), findsOneWidget);
        expect(link.text, kFastClearSelectionText);

        await tester.tap(find.byType(FastTextButton));
        await tester.pumpAndSettle();

        expect(find.text('0'), findsNothing);
      });

      testWidgets('should not be visible whether set to false',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            items: items,
            canClearSelection: false,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        expect(find.byType(FastLink), findsNothing);
      });
    });

    group('#clearSelectionText', () {
      testWidgets('should be used for the "clear selection" text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            clearSelectionText: 'Nettoyer',
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final link =
            tester.firstWidget(find.byType(FastTextButton)) as FastTextButton;
        expect(find.byType(FastTextButton), findsOneWidget);
        expect(link.text, 'Nettoyer');
      });
    });

    group('#intialCategoryIndex', () {
      testWidgets('The "All" category should be selected by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final listItems = find.byType(FastListItemLayout);
        expect(listItems, findsNWidgets(7));
      });

      testWidgets('should select a category for a given index',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            intialCategoryIndex: 1,
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final listItems = find.byType(FastListItemLayout);
        expect(listItems, findsNWidgets(3));
      });
    });

    group('#sortItems', () {
      testWidgets('should sort items by default', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            intialCategoryIndex: 1,
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final listItems = find.byType(FastListItemLayout);
        final item = tester.firstWidget(listItems) as FastListItemLayout;
        expect(listItems, findsNWidgets(3));
        expect(item.labelText, equals('apple'));
      });

      testWidgets('should not sort items when set to false',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSelectField(
            labelText: labelText,
            onSelectionChanged: (FastItem<dynamic>? item) {},
            categories: categories,
            groupByCategory: true,
            intialCategoryIndex: 1,
            sortItems: false,
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastSelectField));
        await tester.pumpAndSettle();

        final listItems = find.byType(FastListItemLayout);
        final item = tester.firstWidget(listItems) as FastListItemLayout;
        expect(listItems, findsNWidgets(3));
        expect(item.labelText, equals('grappe'));
      });
    });
  });
}
