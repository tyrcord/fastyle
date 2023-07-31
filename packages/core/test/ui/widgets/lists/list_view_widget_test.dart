// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastApp _buildApp(Widget child) {
  return FastApp(homeBuilder: (_) => Material(child: child));
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

  group('FastListView', () {
    group('#items', () {
      testWidgets('should draw its items', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastListView(
            items: items,
          )),
        );
        await tester.pumpAndSettle();

        final listItems = find.byType(FastListItemLayout);
        expect(listItems, findsNWidgets(7));
      });
    });

    group('#groupByCategory', () {
      testWidgets('should group items by categories when set to true',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastListView(
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

    group('#listItemBuilder', () {
      testWidgets('should be used for building items',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastListView(
            items: items,
            listItemBuilder: (BuildContext context, FastItem item, int index) {
              return FastLink(text: item.labelText, onTap: () {});
            },
          )),
        );
        await tester.pumpAndSettle();

        final listItems = find.byType(FastLink);
        expect(listItems, findsNWidgets(7));
      });
    });

    group('#sortItems', () {
      testWidgets('should sort items by default', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastListView(
            categories: categories,
            groupByCategory: true,
            items: items,
          )),
        );
        await tester.pumpAndSettle();
        final listItems = find.byType(FastListItemLayout);
        final item = tester.firstWidget(listItems) as FastListItemLayout;
        expect(listItems, findsNWidgets(7));
        expect(item.labelText, equals('0'));
      });

      testWidgets('should not sort items when set to false',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(FastListView(
            categories: categories,
            groupByCategory: true,
            sortItems: false,
            items: items,
          )),
        );
        await tester.pumpAndSettle();
        final listItems = find.byType(FastListItemLayout);
        final item = tester.firstWidget(listItems) as FastListItemLayout;
        expect(listItems, findsNWidgets(7));
        expect(item.labelText, equals('1'));
      });
    });
  });
}
