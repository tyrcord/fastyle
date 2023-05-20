import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
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
        titleText: OnboardingLocaleKeys.onboarding_notifications_title.tr(),
        primaryText:
            OnboardingLocaleKeys.onboarding_notifications_description.tr(),
        secondaryText: OnboardingLocaleKeys.onboarding_notifications_notes.tr(),
        actionText: OnboardingLocaleKeys.onboarding_notifications_action.tr(),
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
        titleText: OnboardingLocaleKeys.onboarding_personalized_ads_title.tr(),
        primaryText:
            OnboardingLocaleKeys.onboarding_personalized_ads_description.tr(),
        secondaryText:
            OnboardingLocaleKeys.onboarding_personalized_ads_notes.tr(),
        actionText:
            OnboardingLocaleKeys.onboarding_personalized_ads_action.tr(),
      ),
    ),
  ),
];
