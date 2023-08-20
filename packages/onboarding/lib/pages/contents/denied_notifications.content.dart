// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

class FastOnboardingDeniedNotificationsContent extends StatelessWidget {
  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  final List<Widget>? children;

  /// The text to display below the icon.
  final String? introText;
  final String? descriptionText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  final String? notesText;

  const FastOnboardingDeniedNotificationsContent({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.introText,
    this.children,
    this.palette,
    this.notesText,
    this.icon,
    this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingContentLayout(
      descriptionText: _getDescriptionText(),
      handsetIconSize: handsetIconSize,
      tabletIconSize: tabletIconSize,
      palette: _getPalette(context),
      introText: _getIntroText(),
      notesText: _getNotesText(),
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
      return const FaIcon(FastFontAwesomeIcons.lightFaceZipper);
    }

    return const FaIcon(FontAwesomeIcons.bell);
  }

  String _getIntroText() {
    return introText ??
        OnboardingLocaleKeys.onboarding_notifications_denied_intro.tr();
  }

  String _getDescriptionText() {
    return descriptionText ??
        OnboardingLocaleKeys.onboarding_notifications_denied_description.tr();
  }

  String _getNotesText() {
    return notesText ??
        OnboardingLocaleKeys.onboarding_notifications_denied_notes.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).red;
    }

    return palette!;
  }
}
