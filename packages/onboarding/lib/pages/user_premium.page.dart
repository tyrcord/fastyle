// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// A page that displays a layout with an icon, a primary text, a secondary text
/// and a list of children widgets.
class FastOnboardingPremiumUser extends StatelessWidget {
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

  /// The text to display as an action.
  final String? actionText;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  const FastOnboardingPremiumUser({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.secondaryText,
    this.primaryText,
    this.onActionTap,
    this.controller,
    this.actionText,
    this.titleText,
    this.children,
    this.palette,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingPage(
      titleText: _getRestorePurchasesText(),
      children: [
        FastOnboardingContentLayout(
          icon: icon ?? const FaIcon(FontAwesomeIcons.crown),
          secondaryText: _getSecondaryText(),
          handsetIconSize: handsetIconSize,
          primaryText: _getPrimaryText(),
          tabletIconSize: tabletIconSize,
          onActionTap: onActionTap,
          actionText: actionText,
          palette: palette,
          children: children,
        ),
      ],
    );
  }

  String _getRestorePurchasesText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_restore_premium_title.tr();
  }

  String _getPrimaryText() {
    return primaryText ??
        OnboardingLocaleKeys.onboarding_restore_premium_description.tr();
  }

  String _getSecondaryText() {
    return secondaryText ??
        OnboardingLocaleKeys.onboarding_restore_premium_notes.tr();
  }
}
