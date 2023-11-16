// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_ad_example/pages/admob_rewarded_ads.page.dart';
import 'package:fastyle_ad_example/pages/custom_ads.page.dart';
import 'package:fastyle_ad_example/pages/loading_ads.page.dart';
import 'package:fastyle_ad_example/pages/smart_native_ads.page.dart';

final kAppRoutes = [
  GoRoute(
    path: '/custom',
    builder: (context, state) => const CustomAdsPage(),
  ),
  GoRoute(
    path: '/loading',
    builder: (context, state) => const LoadingAdsPage(),
  ),
  GoRoute(
    path: '/smart-native',
    builder: (context, state) => const SmartNativeAdsPage(),
    routes: [
      GoRoute(
        path: 'cover',
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: FastSectionPage(),
        ),
      ),
    ],
  ),
  GoRoute(
    path: '/rewarded',
    builder: (context, state) => const AdmobRewardedAdsPage(),
  ),
];
