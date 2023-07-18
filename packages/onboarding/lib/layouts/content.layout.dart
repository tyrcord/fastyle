// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

const _handsetIconSize = 168.0;
const _tabletIconSize = 192.0;

/// A layout that displays a centered icon, a primary text, a secondary text
/// and a list of children widgets.
class FastOnboardingContentLayout extends StatelessWidget {
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
  final Widget icon;

  const FastOnboardingContentLayout({
    super.key,
    required this.icon,
    this.handsetIconSize,
    this.tabletIconSize,
    this.secondaryText,
    this.primaryText,
    this.onActionTap,
    this.actionText,
    this.children,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        final isHandset = mediaType < FastMediaType.tablet;

        return FractionallySizedBox(
          widthFactor: isHandset ? 1 : 0.55,
          child: buildLayout(context, mediaType),
        );
      },
    );
  }

  Widget buildLayout(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;
    final padding = isHandset ? kFastSizedBox48 : kFastSizedBox64;

    return Column(
      children: [
        padding,
        Center(child: buildIcon(context, mediaType)),
        padding,
        if (primaryText != null) buildPrimaryText(context, mediaType),
        if (secondaryText != null) buildSecondaryText(context, mediaType),
        if (actionText != null) buildAction(context, mediaType),
        if (children != null) ...children!,
      ],
    );
  }

  Widget buildPrimaryText(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        FastBody(text: primaryText!, textAlign: TextAlign.center),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }

  Widget buildSecondaryText(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        FastSecondaryBody(text: secondaryText!, textAlign: TextAlign.center),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }

  Widget buildAction(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        FastRaisedButton(
          text: actionText!,
          onTap: () {
            if (onActionTap != null) {
              onActionTap!();
            }
          },
        ),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }

  Widget buildIcon(BuildContext context, FastMediaType mediaType) {
    return FastRoundedDuotoneIcon(
      size: _getIconSize(context, mediaType),
      palette: _getPalette(context),
      icon: icon,
    );
  }

  double _getIconSize(BuildContext context, FastMediaType mediaType) {
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final textScaleFactor = scaleFactor > 1 ? scaleFactor : scaleFactor;

    if (mediaType == FastMediaType.tablet) {
      return (tabletIconSize ?? _tabletIconSize) * textScaleFactor;
    }

    return (handsetIconSize ?? _handsetIconSize) * textScaleFactor;
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).blueGray;
    }

    return palette!;
  }
}
