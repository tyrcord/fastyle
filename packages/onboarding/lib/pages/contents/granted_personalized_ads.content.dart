// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

class FastOnboardingGrantedPersonalizedAdsContent extends StatelessWidget {
  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  final List<Widget>? children;

  final String? introText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  final String? notesText;
  final String? descriptionText;

  const FastOnboardingGrantedPersonalizedAdsContent({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.introText,
    this.children,
    this.palette,
    this.notesText,
    this.descriptionText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingContentLayout(
      descriptionText: _getDescriptionText(),
      handsetIconSize: handsetIconSize,
      introText: _getIntroText(),
      notesText: _getNotesText(),
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
      return const FaIcon(FastFontAwesomeIcons.megaphone);
    }

    return const FaIcon(FontAwesomeIcons.bullhorn);
  }

  String _getIntroText() {
    return introText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_granted_intro.tr();
  }

  String _getDescriptionText() {
    return descriptionText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_granted_description
            .tr();
  }

  String _getNotesText() {
    return notesText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_granted_notes.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).green;
    }

    return palette!;
  }
}
