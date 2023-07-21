// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

/// A page widget that displays a status with an optional title, description,
/// and buttons.
class FastStatusPage extends StatelessWidget {
  /// The text to be displayed as the title.
  final String? titleText;

  /// The text to be displayed as the description.
  final String? descriptionText;

  /// The text to be displayed on the valid button.
  final String? validButtonText;

  /// The text to be displayed on the cancel button.
  final String? cancelButtonText;

  /// A callback function when the valid button is tapped.
  final VoidCallback? onValidTap;

  /// A callback function when the cancel button is tapped.
  final VoidCallback? onCancelTap;

  /// The padding around the content of the page.
  final EdgeInsets contentPadding;

  /// The color scheme to be used for the widgets.
  final FastPaletteScheme? palette;

  /// The color of the icon.
  final Color? iconColor;

  /// The background color of the page.
  final Color? backgroundColor;

  /// The icon to be displayed on the page.
  final Widget? icon;

  /// Creates a [FastStatusPage].
  ///
  /// The [titleText] parameter is required.
  /// The [contentPadding] parameter defaults to [kFastEdgeInsets16].
  const FastStatusPage({
    Key? key,
    this.titleText,
    this.descriptionText,
    this.validButtonText,
    this.cancelButtonText,
    this.onValidTap,
    this.onCancelTap,
    this.contentPadding = kFastEdgeInsets16,
    this.palette,
    this.iconColor,
    this.backgroundColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FastPadding16(
        padding: contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildTitle(),
            Expanded(
              child: buildContent(),
            ),
            buildCancelButton(),
            buildValidButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the widget for the title.
  Widget buildTitle() {
    if (titleText != null) {
      return FastHeadline(text: titleText!);
    }

    return const SizedBox.shrink();
  }

  /// Builds the widget for the content.
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...[
          buildIcon(),
          kFastSizedBox64,
        ],
        if (descriptionText != null)
          FastBody(
            textAlign: TextAlign.center,
            text: descriptionText!,
          ),
      ],
    );
  }

  /// Builds the widget for the icon.
  Widget buildIcon() {
    return FastRoundedDuotoneIcon(
      icon: icon!,
      palette: palette,
      size: kFastImageSizeXxl,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  /// Builds the widget for the cancel button.
  Widget buildCancelButton() {
    if (onCancelTap != null) {
      return FastOutlineButton(
        onTap: onCancelTap!,
        text: cancelButtonText,
      );
    }

    return const SizedBox.shrink();
  }

  /// Builds the widget for the valid button.
  Widget buildValidButton() {
    if (onValidTap != null) {
      return FastRaisedButton(
        onTap: onValidTap!,
        text: validButtonText,
      );
    }

    return const SizedBox.shrink();
  }
}
