//ignore_for_file: no-empty-block

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

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
  const labelText = 'label';
  const descriptionText = 'description';
  const itemIcon = Icon(Icons.icecream);
  const item = FastItem(
      labelText: 'label 2',
      descriptionText: 'description 2',
      isEnabled: false,
      descriptor: FastListItemDescriptor(leading: itemIcon));

  group('FastListHeader', () {
    group('#onValueChanged()', () {
      testWidgets('should be called when the toggle switch is used',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) => called = true,
                labelText: labelText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        expect(called, isTrue);
      });
    });

    group('#isChecked', () {
      testWidgets('should be set to false by default',
          (WidgetTester tester) async {
        late bool oldValue;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) => oldValue = !checked,
                labelText: labelText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        expect(oldValue, isFalse);
      });
    });

    group('#isEnabled', () {
      testWidgets('should be set to true by default',
          (WidgetTester tester) async {
        late bool value;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) => value = checked,
                labelText: labelText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        expect(value, isTrue);
      });

      testWidgets('should not allow to use the switch toggle when set to false',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) => called = true,
                labelText: labelText,
                isEnabled: false,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        expect(called, isFalse);
      });
    });

    group('#titleText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) {},
                labelText: labelText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text(labelText), findsOneWidget);
      });
    });

    group('#descriptionText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) {},
                labelText: labelText,
                descriptionText: descriptionText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text(descriptionText), findsOneWidget);
      });
    });

    group('#leading', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) {},
                labelText: labelText,
                descriptionText: descriptionText,
                leading: icon,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(icon), findsOneWidget);
      });
    });

    group('#item', () {
      testWidgets('should be used when titleText is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) {},
                labelText: labelText,
                descriptionText: descriptionText,
                leading: icon,
                item: item,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text(item.labelText), findsOneWidget);
      });

      testWidgets('should be used when descriptionText is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) {},
                labelText: labelText,
                descriptionText: descriptionText,
                leading: icon,
                item: item,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.text(item.descriptionText!), findsOneWidget);
      });

      testWidgets('should be used when isEnabled is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) => called = true,
                labelText: labelText,
                descriptionText: descriptionText,
                leading: icon,
                item: item,
                isEnabled: true,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        expect(called, isFalse);
      });

      testWidgets('should be used when descriptor\'s leading is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastToggleListItem(
                onValueChanged: (bool checked) {},
                labelText: labelText,
                descriptionText: descriptionText,
                leading: icon,
                item: item,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(itemIcon), findsOneWidget);
      });
    });
  });
}
