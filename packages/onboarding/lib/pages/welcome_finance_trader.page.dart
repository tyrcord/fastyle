// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_onboarding/fastyle_onboarding.dart';

class FastOnboardingFinanceTraderWelcome extends StatelessWidget {
  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The title text to display.
  final String? titleText;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  final List<Widget>? children;

  final String? introText;

  final String? descriptionText;

  final String? notesText;

  /// The text to display as an action.
  final String? actionText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The callback to call when the action is tapped.
  final VoidCallback? onActionTap;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  const FastOnboardingFinanceTraderWelcome({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.descriptionText,
    this.introText,
    this.onActionTap,
    this.controller,
    this.titleText,
    this.children,
    this.palette,
    this.icon,
    this.notesText,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingWelcome(
      descriptionText: _getDescriptionText(),
      handsetIconSize: handsetIconSize,
      tabletIconSize: tabletIconSize,
      introText: _getIntroText(),
      titleText: _getTitleText(),
      onActionTap: onActionTap,
      controller: controller,
      actionText: actionText,
      notesText: notesText,
      palette: palette,
      icon: icon,
      children: children,
    );
  }

  String _getTitleText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_welcome_finance_traders_title.tr();
  }

  String _getIntroText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_welcome_finance_traders_intro.tr();
  }

  String _getDescriptionText() {
    return descriptionText ??
        OnboardingLocaleKeys.onboarding_welcome_finance_traders_description
            .tr();
  }
}
