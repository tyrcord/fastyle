// Flutter imports:
import 'package:fastyle_ad_example/pages/custom_ads.page.dart';
import 'package:fastyle_ad_example/pages/loading_ads.page.dart';

// Package imports:
import 'package:go_router/go_router.dart';

final kAppRoutes = [
  GoRoute(
    path: 'custom',
    builder: (context, state) => const CustomAdsPage(),
  ),
  GoRoute(
    path: 'loading',
    builder: (context, state) => const LoadingAdsPage(),
  ),
];
