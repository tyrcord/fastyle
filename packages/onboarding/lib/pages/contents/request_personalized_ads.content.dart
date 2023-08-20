// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

class FastOnboardingRequestPersonalizedAdsContent extends StatelessWidget {
  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  final List<Widget>? children;

  final String? introText;

  final String? descriptionText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  final String? notesText;

  /// The text to display as an action.
  final String? actionText;

  /// The callback to call when the action is tapped.
  final VoidCallback? onActionTap;

  const FastOnboardingRequestPersonalizedAdsContent({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.descriptionText,
    this.introText,
    this.controller,
    this.children,
    this.palette,
    this.notesText,
    this.actionText,
    this.onActionTap,
    this.icon,
  });

  void handleAction() async {
    controller?.pause();
    final status = await AppTrackingTransparency.requestTrackingAuthorization();

    final permission = getTrackingPermission(status);
    final event = FastAppPermissionsBlocEvent.updateTrackingPermission(
      permission,
    );

    FastAppPermissionsBloc.instance.addEvent(event);

    onActionTap?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller?.resume());
  }

  @override
  Widget build(BuildContext context) {
    return FastOnboardingContentLayout(
      descriptionText: _getDescriptionText(),
      handsetIconSize: handsetIconSize,
      tabletIconSize: tabletIconSize,
      introText: _getIntroText(),
      palette: _getPalette(context),
      actionText: _getActionText(),
      onActionTap: handleAction,
      icon: buildIcon(context),
      notesText: notesText,
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
        OnboardingLocaleKeys.onboarding_personalized_ads_intro.tr();
  }

  String _getDescriptionText() {
    return descriptionText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_description.tr();
  }

  String _getActionText() {
    return actionText ??
        OnboardingLocaleKeys.onboarding_personalized_ads_action.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).teal;
    }

    return palette!;
  }
}
