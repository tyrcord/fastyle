// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastOnboardingContentLayout extends StatelessWidget {
  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  /// A list of widgets to display below the primary and secondary texts.
  final List<Widget>? children;

  final String? introText;

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
  final Widget icon;

  final WidgetBuilder? actionBuilder;

  final String? notesText;

  const FastOnboardingContentLayout({
    super.key,
    required this.icon,
    this.handsetIconSize,
    this.tabletIconSize,
    this.descriptionText,
    this.introText,
    this.onActionTap,
    this.actionText,
    this.children,
    this.palette,
    this.actionBuilder,
    this.notesText,
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
        if (introText != null) buildIntroText(context, mediaType),
        if (descriptionText != null) buildDescriptionText(context, mediaType),
        if (actionText != null || actionBuilder != null)
          buildAction(context, mediaType),
        if (notesText != null) buildNotesText(context, mediaType),
        if (children != null) ...children!,
      ],
    );
  }

  Widget buildIcon(BuildContext context, FastMediaType mediaType) {
    return FastPageHeaderRoundedDuotoneIconLayout(
      palette: _getPalette(context),
      hasShadow: true,
      icon: icon,
    );
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).blueGray;
    }

    return palette!;
  }

  Widget buildIntroText(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        FastBody(text: introText!, textAlign: TextAlign.center),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }

  Widget buildDescriptionText(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        FastSecondaryBody(text: descriptionText!, textAlign: TextAlign.center),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }

  Widget buildAction(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        if (actionBuilder != null)
          Builder(builder: actionBuilder!)
        else
          FastRaisedButton(onTap: () => onActionTap?.call(), text: actionText!),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }

  Widget buildNotesText(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;

    return Column(
      children: [
        FastSecondaryBody(
          text: notesText!,
          textAlign: TextAlign.center,
          fontSize: 14,
        ),
        isHandset ? kFastSizedBox24 : kFastSizedBox32,
      ],
    );
  }
}
