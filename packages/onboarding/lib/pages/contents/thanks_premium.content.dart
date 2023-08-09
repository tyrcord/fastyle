import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

class FastOnboardingThanksPremiumContent extends StatelessWidget {
  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

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

  /// The icon to display at the top of the layout.
  final Widget? icon;

  final String? notesText;

  const FastOnboardingThanksPremiumContent({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.secondaryText,
    this.primaryText,
    this.controller,
    this.children,
    this.palette,
    this.notesText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingContentLayout(
      notesText: notesText,
      handsetIconSize: handsetIconSize,
      primaryText: _getPrimaryText(),
      secondaryText: secondaryText,
      tabletIconSize: tabletIconSize,
      palette: _getPalette(context),
      icon: buildIcon(context),
      children: children,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightRocketLaunch);
    }

    return const FaIcon(FontAwesomeIcons.rocket);
  }

  String _getPrimaryText() {
    return primaryText ??
        PurchasesLocaleKeys.purchases_message_enjoy_premium_version.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).green;
    }

    return palette!;
  }
}
