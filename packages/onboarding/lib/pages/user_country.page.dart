// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:fastyle_settings/fastyle_settings.dart';

class FastOnboardingUserCountry extends StatelessWidget {
  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The title text to display.
  final String? titleText;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  final List<Widget>? children;

  final String? introText;

  final String? notesText;

  final String? descriptionText;

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

  /// A callback that is called when the user selects a new country.
  final void Function(String?)? onCountryChanged;

  const FastOnboardingUserCountry({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.notesText,
    this.introText,
    this.descriptionText,
    this.onActionTap,
    this.controller,
    this.actionText,
    this.titleText,
    this.children,
    this.palette,
    this.icon,
    this.onCountryChanged,
  });

  void handleCountryChanged(String? code) {
    final bloc = FastAppSettingsBloc.instance;
    final event = FastAppSettingsBlocEvent.countryCodeChanged(code);
    onCountryChanged?.call(code);

    bloc.addEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    return FastOnboardingPage(
      titleText: _getTitleText(),
      children: [
        FastOnboardingContentLayout(
          descriptionText: descriptionText,
          handsetIconSize: handsetIconSize,
          tabletIconSize: tabletIconSize,
          palette: _getPalette(context),
          notesText: _getNotesText(),
          introText: _getIntroText(),
          actionBuilder: buildAction,
          onActionTap: onActionTap,
          icon: buildIcon(context),
          children: children,
        ),
      ],
    );
  }

  Widget buildAction(BuildContext context) {
    return FastAppSettingsUserCountrySelectField(
      onCountryChanged: handleCountryChanged,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.earthEurope);
    }

    return const FaIcon(FontAwesomeIcons.globe);
  }

  String _getTitleText() {
    return titleText ?? OnboardingLocaleKeys.onboarding_user_country_title.tr();
  }

  String _getIntroText() {
    return introText ?? OnboardingLocaleKeys.onboarding_user_country_intro.tr();
  }

  String _getNotesText() {
    return notesText ?? OnboardingLocaleKeys.onboarding_user_country_notes.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).brown;
    }

    return palette!;
  }
}
