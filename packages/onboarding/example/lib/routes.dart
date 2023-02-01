import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_onboarding/fastyle_onboarding.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final kAppRoutes = [
  GoRoute(
    path: 'notifications',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastOnboardingNotifications(
        icon: const FaIcon(FontAwesomeIcons.envelope),
        onActionTap: () {
          debugPrint('Notifications action tapped');
        },
      ),
    ),
  ),
  GoRoute(
    path: 'ads',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastOnboardingPersonalizedAds(
        palette: ThemeHelper.getPaletteColors(context).mint,
        onActionTap: () {
          debugPrint('Personalized Ads action tapped');
        },
      ),
    ),
  ),
];
