// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

/// A page that displays a layout with an icon, a primary text, a secondary text
/// and a list of children widgets.
class FastOnboardingPersonalizedAds extends StatelessWidget {
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

  const FastOnboardingPersonalizedAds({
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

  void handleTap() async {
    controller?.pause();
    await AppTrackingTransparency.requestTrackingAuthorization();
    onActionTap?.call();
    await Future.microtask(() => controller?.resume());
  }

  @override
  Widget build(BuildContext context) {
    return FastOnboardingPage(
      titleText: _getTitleText(),
      children: [
        FastOnboardingContentLayout(
          secondaryText: _getSecondaryText(),
          handsetIconSize: handsetIconSize,
          tabletIconSize: tabletIconSize,
          primaryText: _getPrimaryText(),
          palette: _getPalette(context),
          actionText: _getActionText(),
          icon: buildIcon(context),
          onActionTap: handleTap,
          children: children,
        ),
      ],
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.megaphone);
    }

    return const FaIcon(FontAwesomeIcons.bullhorn);
  }

  String _getTitleText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_title.tr();
  }

  String _getPrimaryText() {
    return primaryText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_description.tr();
  }

  String _getSecondaryText() {
    return secondaryText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_notes.tr();
  }

  String _getActionText() {
    return actionText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_action.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).pink;
    }

    return palette!;
  }
}
