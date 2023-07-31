// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(FastSearchPage child) {
  return FastApp(homeBuilder: (_) => child);
}

void main() {
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

  group('FastSearchPage', () {
    group('#items', () {
      testWidgets('should draw its items', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            items: items,
          )),
        );

        await tester.pumpAndSettle();

        final listItems = find.byType(FastSelectableListItem);
        expect(listItems, findsNWidgets(7));
      });
    });

    group('#groupByCategory', () {
      testWidgets('should group items by categories when set to true',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );

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
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            allCategoryText: 'Toutes',
            items: items,
          )),
        );

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
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            items: items,
            searchPlaceholderText: 'Search',
          )),
        );

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
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );

        await tester.pumpAndSettle();

        final link =
            tester.firstWidget(find.byType(FastTextButton)) as FastTextButton;
        expect(find.byType(FastTextButton), findsOneWidget);
        expect(link.text, kFastClearSelectionText);
      });

      testWidgets('should not be visible whether set to false',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            items: items,
            canClearSelection: false,
          )),
        );

        await tester.pumpAndSettle();

        expect(find.byType(FastTextButton), findsNothing);
      });
    });

    group('#clearSelectionText', () {
      testWidgets('should be used for the "clear selection" text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            clearSelectionText: 'Nettoyer',
            items: items,
          )),
        );

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
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );

        await tester.pumpAndSettle();

        final listItems = find.byType(FastListItemLayout);
        expect(listItems, findsNWidgets(7));
      });

      testWidgets('should select a category for a given index',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            intialCategoryIndex: 1,
            items: items,
          )),
        );

        await tester.pumpAndSettle();
        final listItems = find.byType(FastListItemLayout);
        expect(listItems, findsNWidgets(3));
      });
    });

    group('#sortItems', () {
      testWidgets('should sort items by default', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            intialCategoryIndex: 1,
            items: items,
          )),
        );

        await tester.pumpAndSettle();
        final listItems = find.byType(FastListItemLayout);
        final item = tester.firstWidget(listItems) as FastListItemLayout;
        expect(listItems, findsNWidgets(3));
        expect(item.labelText, equals('apple'));
      });

      testWidgets('should not sort items when set to false',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastSearchPage(
            categories: categories,
            groupByCategory: true,
            intialCategoryIndex: 1,
            sortItems: false,
            items: items,
          )),
        );

        await tester.pumpAndSettle();
        final listItems = find.byType(FastListItemLayout);
        final item = tester.firstWidget(listItems) as FastListItemLayout;
        expect(listItems, findsNWidgets(3));
        expect(item.labelText, equals('grappe'));
      });
    });
  });
}
