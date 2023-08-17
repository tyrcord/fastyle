// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FastOnboardingWelcome extends StatelessWidget {
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

  const FastOnboardingWelcome({
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
    return FastOnboardingPage(
      titleText: _getTitleText(),
      children: [
        FastOnboardingContentLayout(
          descriptionText: descriptionText,
          handsetIconSize: handsetIconSize,
          tabletIconSize: tabletIconSize,
          palette: _getPalette(context),
          icon: buildIcon(context),
          onActionTap: onActionTap,
          actionText: actionText,
          introText: introText,
          notesText: notesText,
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
      return const FaIcon(FastFontAwesomeIcons.lightDoorOpen);
    }

    return const FaIcon(FontAwesomeIcons.doorOpen);
  }

  String _getTitleText() {
    return titleText ?? CoreLocaleKeys.core_message_welcome.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).orange;
    }

    return palette!;
  }
}
