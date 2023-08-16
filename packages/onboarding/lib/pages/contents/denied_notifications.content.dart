import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:flutter/material.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastOnboardingDeniedNotificationsContent extends StatelessWidget {
  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  /// A list of widgets to display below the primary and secondary texts.
  final List<Widget>? children;

  /// The text to display below the icon.
  final String? primaryText;

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
    this.primaryText,
    this.children,
    this.palette,
    this.notesText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingContentLayout(
      handsetIconSize: handsetIconSize,
      primaryText: _getPrimaryText(),
      tabletIconSize: tabletIconSize,
      notesText: _getNotesText(),
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
      return const FaIcon(FastFontAwesomeIcons.lightFaceZipper);
    }

    return const FaIcon(FontAwesomeIcons.bell);
  }

  String _getPrimaryText() {
    return primaryText ?? 'Ok, no problem. We will not disturb you.';
  }

  String _getNotesText() {
    return notesText ?? 'Note that you can always change your mind later.';
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).red;
    }

    return palette!;
  }
}
