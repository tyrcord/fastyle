// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_onboarding/fastyle_onboarding.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

final kAppRoutes = [
  GoRoute(
    path: 'notifications',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastOnboardingNotifications(
        onActionTap: () {
          debugPrint('Notifications action tapped');
        },
      ),
    ),
  ),
  GoRoute(
    path: 'ads',
    builder: (context, state) => const FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastOnboardingPersonalizedAds(),
    ),
  ),
  GoRoute(
    path: 'premium',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastOnboardingPremiumUser(
        premiumProductId: 'premium',
        palette: ThemeHelper.getPaletteColors(context).orange,
        onActionTap: () {
          debugPrint('Select currency action tapped');
        },
        actionText: OnboardingLocaleKeys.onboarding_restore_premium_action.tr(),
      ),
    ),
  ),
];
