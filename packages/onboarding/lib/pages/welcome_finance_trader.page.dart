// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  /// A list of widgets to display below the primary and secondary texts.
  final List<Widget>? children;

  /// The text to display below the icon.
  final String? primaryText;

  /// The text to display below the primary text.
  final String? secondaryText;

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
    this.secondaryText,
    this.primaryText,
    this.onActionTap,
    this.controller,
    this.titleText,
    this.children,
    this.palette,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingWelcome(
      secondaryText: _getSecondaryText(),
      primaryText: _getPrimaryText(),
      titleText: _getTitleText(),
      children: children,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightDoorOpen);
    }

    return const FaIcon(FontAwesomeIcons.doorOpen);
  }

  String _getTitleText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_welcome_finance_traders_title.tr();
  }

  String _getPrimaryText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_welcome_finance_traders_description
            .tr();
  }

  String _getSecondaryText() {
    return secondaryText ??
        OnboardingLocaleKeys.onboarding_welcome_finance_traders_notes.tr();
  }
}
