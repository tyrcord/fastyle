import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_core_example/pages/buttons.dart';
import 'package:fastyle_core_example/pages/cards.dart';
import 'package:fastyle_core_example/pages/colors.dart';
import 'package:fastyle_core_example/pages/fields.dart';
import 'package:fastyle_core_example/pages/indicators.dart';
import 'package:fastyle_core_example/pages/lists.dart';
import 'package:fastyle_core_example/pages/naviagtion_bar_view.dart';
import 'package:fastyle_core_example/pages/notifications.dart';
import 'package:fastyle_core_example/pages/responsive.dart';
import 'package:fastyle_core_example/pages/split-view.dart';
import 'package:fastyle_core_example/pages/tabs.dart';
import 'package:fastyle_core_example/pages/typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final options = List<FastItem>.generate(50, (int index) {
  return FastItem(labelText: index.toString(), value: index);
});

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final AppRoutes = [
  GoRoute(
    path: 'onboarding',
    pageBuilder: (context, state) {
      const slideText1 = 'slide 1';
      const slideText2 = 'slide 2';
      const slide1 = Text(slideText1);
      const slide2 = Text(slideText2);

      return MaterialPage(
        fullscreenDialog: true,
        child: FastOnboardingView(
          slides: [slide1, slide2],
          allowToSkip: true,
        ),
      );
    },
  ),
  GoRoute(
    path: 'buttons',
    builder: (context, state) => ButtonsPage(),
  ),
  GoRoute(
    path: 'typography',
    builder: (context, state) => TypographyPage(),
  ),
  GoRoute(
    path: 'tabs',
    builder: (context, state) => TabsPage(),
  ),
  GoRoute(
    path: 'cards',
    builder: (context, state) => CardsPage(),
  ),
  GoRoute(
    path: 'list',
    builder: (context, state) => ListsPage(),
  ),
  GoRoute(
    path: 'fields',
    builder: (context, state) => FieldsPage(),
  ),
  GoRoute(
    path: 'notifications',
    builder: (context, state) => NotificationsPage(),
  ),
  GoRoute(
    path: 'colors',
    builder: (context, state) => ColorsPage(),
  ),
  GoRoute(
    path: 'page',
    builder: (context, state) => FastSectionPage(
      loadingBuilder: (_) {
        return Text('loading...');
      },
      errorBuilder: (_) {
        return Text('An error occured');
      },
      loadingFuture: Future.delayed(
        const Duration(milliseconds: 10000),
        () => true,
      ),
      loadingTimeout: Duration(milliseconds: 5000),
      child: Container(
        child: Text('done'),
      ),
    ),
  ),
  GoRoute(
    path: 'responsive',
    builder: (context, state) => ResponsivePage(),
  ),
  GoRoute(
    path: 'split-view',
    builder: (context, state) => SplitViewPage(),
  ),
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) => NavigationBarViewPage(
      child: child,
    ),
    routes: [
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: 'navigation-bar-view/explore',
        pageBuilder: (context, state) {
          return FastFadeTransitionPage(
            child: FastSectionPage(
              titleText: 'Commute',
              showAppBar: false,
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: 'navigation-bar-view/commute',
        pageBuilder: (context, state) {
          return FastFadeTransitionPage(
            child: FastSectionPage(
              titleText: 'Explore',
              showAppBar: false,
              isViewScrollable: false,
              contentPadding: EdgeInsets.zero,
              child: FastSelectableListView(
                showItemDivider: true,
                items: options,
                sortItems: false,
                onSelectionChanged: (FastItem option) {
                  debugPrint('${option.labelText} selected');
                },
              ),
            ),
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _shellNavigatorKey,
        path: 'navigation-bar-view/saved',
        pageBuilder: (context, state) {
          return FastFadeTransitionPage(
            child: FastSectionPage(
              titleText: 'Saved',
              showAppBar: false,
            ),
            key: state.pageKey,
          );
        },
      ),
    ],
  ),
  GoRoute(
    path: 'indicators',
    builder: (context, state) => IndicatorsPage(),
  ),
];
