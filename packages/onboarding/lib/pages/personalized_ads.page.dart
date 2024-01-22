// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_onboarding/pages/pages.dart';

class FastOnboardingPersonalizedAds extends StatelessWidget {
  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The title text to display.
  final String? titleText;

  final List<Widget>? children;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  const FastOnboardingPersonalizedAds({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.controller,
    this.titleText,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return FastAppTrackingPermissionBuilder(
      builder: (context, state) {
        late Widget content;

        if (state.trackingPermission == FastAppPermission.granted) {
          content = FastOnboardingGrantedPersonalizedAdsContent(
            handsetIconSize: handsetIconSize,
            tabletIconSize: tabletIconSize,
            children: children,
          );
        } else if (state.trackingPermission == FastAppPermission.denied) {
          content = FastOnboardingDeniedPersonalizedAdsContent(
            handsetIconSize: handsetIconSize,
            tabletIconSize: tabletIconSize,
            children: children,
          );
        } else {
          content = FastOnboardingRequestPersonalizedAdsContent(
            handsetIconSize: handsetIconSize,
            tabletIconSize: tabletIconSize,
            controller: controller,
            children: children,
          );
        }

        return FastOnboardingPage(
          titleText: _getTitleText(),
          children: [content],
        );
      },
    );
  }

  String _getTitleText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_title.tr();
  }
}
