// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

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
  const trailingIcon = Icon(Icons.radio);

  const item = FastItem(
    labelText: 'label 2',
    descriptionText: 'description 2',
    isEnabled: false,
    descriptor: FastListItemDescriptor(
      leading: itemIcon,
      trailing: trailingIcon,
    ),
  );

  group('FastNavigationListItem', () {
    group('#onTap()', () {
      testWidgets('should be called when the toggle switch is used',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastNavigationListItem(
                onTap: () => called = true,
                labelText: labelText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastNavigationListItem));
        await tester.pumpAndSettle();

        expect(called, isTrue);
      });
    });

    group('#isEnabled', () {
      testWidgets('should be set to true by default',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastNavigationListItem(
                onTap: () => called = true,
                labelText: labelText,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastNavigationListItem));
        await tester.pumpAndSettle();

        expect(called, isTrue);
      });

      testWidgets('should not allow to use the switch toggle when set to false',
          (WidgetTester tester) async {
        var called = false;

        await tester.pumpWidget(
          _buildApp(Column(
            children: [
              FastNavigationListItem(
                onTap: () => called = true,
                labelText: labelText,
                isEnabled: false,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FastNavigationListItem));
        await tester.pumpAndSettle();

        expect(called, isFalse);
      });
    });

    group('#titleText', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
                labelText: labelText,
                capitalizeLabelText: false,
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
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
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
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
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

    group('#trailing', () {
      testWidgets('should draw it when set', (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
                labelText: labelText,
                descriptionText: descriptionText,
                trailing: icon,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(
          find.widgetWithIcon(FastNavigationListItem, Icons.pages),
          findsOneWidget,
        );
      });
    });

    group('#item', () {
      testWidgets('should be used when titleText is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
                labelText: labelText,
                descriptionText: descriptionText,
                capitalizeLabelText: false,
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
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
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
              FastNavigationListItem(
                onTap: () => called = true,
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

        await tester.tap(find.byType(FastNavigationListItem));
        await tester.pumpAndSettle();

        expect(called, isFalse);
      });

      testWidgets('should be used when descriptor\'s leading is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
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

      testWidgets('should be used when descriptor\'s trailing is set',
          (WidgetTester tester) async {
        const icon = Icon(Icons.pages);

        await tester.pumpWidget(
          _buildApp(const Column(
            children: [
              FastNavigationListItem(
                onTap: noop,
                labelText: labelText,
                descriptionText: descriptionText,
                trailing: icon,
                item: item,
              ),
            ],
          )),
        );
        await tester.pumpAndSettle();

        expect(
          find.widgetWithIcon(FastNavigationListItem, Icons.radio),
          findsOneWidget,
        );
      });
    });
  });
}
