// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_core_example/pages/buttons.dart';
import 'package:fastyle_core_example/pages/cards.dart';
import 'package:fastyle_core_example/pages/colors.dart';
import 'package:fastyle_core_example/pages/fields.dart';
import 'package:fastyle_core_example/pages/indicators.dart';
import 'package:fastyle_core_example/pages/lists.dart';
import 'package:fastyle_core_example/pages/naviagtion_bar_view.dart';
import 'package:fastyle_core_example/pages/notifications.dart';
import 'package:fastyle_core_example/pages/responsive.dart';
import 'package:fastyle_core_example/pages/split_view.dart';
import 'package:fastyle_core_example/pages/tabs.dart';
import 'package:fastyle_core_example/pages/typography.dart';

final options = List<FastItem>.generate(50, (int index) {
  return FastItem(labelText: index.toString(), value: index);
});

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final kAppRoutes = [
  GoRoute(
    path: 'onboarding',
    pageBuilder: (context, state) {
      const slideText1 = 'slide 1';
      const slideText2 = 'slide 2';
      const slide1 = Text(slideText1);
      const slide2 = Text(slideText2);

      return const MaterialPage(
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
    builder: (context, state) => const ButtonsPage(),
  ),
  GoRoute(
    path: 'typography',
    builder: (context, state) => const TypographyPage(),
  ),
  GoRoute(
    path: 'tabs',
    builder: (context, state) => const TabsPage(),
  ),
  GoRoute(
    path: 'cards',
    builder: (context, state) => const CardsPage(),
  ),
  GoRoute(
    path: 'list',
    builder: (context, state) => const ListsPage(),
  ),
  GoRoute(
    path: 'fields',
    builder: (context, state) => const FieldsPage(),
  ),
  GoRoute(
    path: 'notifications',
    builder: (context, state) => const NotificationsPage(),
  ),
  GoRoute(
    path: 'colors',
    builder: (context, state) => const ColorsPage(),
  ),
  GoRoute(
    path: 'page',
    builder: (context, state) => FastSectionPage(
      loadingBuilder: (_) {
        return const Text('loading...');
      },
      errorBuilder: (_) {
        return const Text('An error occured');
      },
      loadingFuture: Future.delayed(
        const Duration(milliseconds: 10000),
        () => true,
      ),
      loadingTimeout: const Duration(milliseconds: 5000),
      child: const Text('done'),
    ),
  ),
  GoRoute(
    path: 'responsive',
    builder: (context, state) => const ResponsivePage(),
  ),
  GoRoute(
    path: 'split-view',
    builder: (context, state) => const SplitViewPage(),
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
            child: const FastSectionPage(
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
            child: const FastSectionPage(
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
    builder: (context, state) => const IndicatorsPage(),
  ),
];
