// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:tenhance/tenhance.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

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

  /// The color scheme to be used for the widgets.
  final FastPaletteScheme? palette;

  /// The color of the icon.
  final Color? iconColor;

  /// The background color of the page.
  final Color? backgroundColor;

  /// The icon to be displayed on the page.
  final Widget? icon;

  final Widget? child;

  final String? subTitleText;

  final bool isValidButtonPending;

  /// Creates a [FastStatusPage].
  ///
  /// The [titleText] parameter is required.
  /// The [contentPadding] parameter defaults to [kFastEdgeInsets16].
  const FastStatusPage({
    super.key,
    this.titleText,
    this.descriptionText,
    this.validButtonText,
    this.cancelButtonText,
    this.onValidTap,
    this.onCancelTap,
    this.palette,
    this.iconColor,
    this.backgroundColor,
    this.icon,
    this.child,
    this.subTitleText,
    bool? isValidButtonPending,
  }) : isValidButtonPending = isValidButtonPending ?? false;

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTitle(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: buildLayout(context, mediaType),
                ),
              ),
              buildActions(context, mediaType),
            ],
          ),
        );
      },
    );
  }

  Widget buildLayout(BuildContext context, FastMediaType mediaType) {
    final isHandset = mediaType < FastMediaType.tablet;
    final spacer = isHandset ? kFastSizedBox48 : kFastSizedBox72;

    return FractionallySizedBox(
      widthFactor: isHandset ? 1 : 0.55,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (icon != null) ...[
                      spacer,
                      buildIcon(),
                      spacer,
                    ],
                    buildContent(),
                  ],
                ),
              ),
            ),
          );
        },
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
        if (subTitleText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FastSubhead(
              textAlign: TextAlign.center,
              text: subTitleText!,
            ),
          ),
        if (descriptionText != null)
          FastBody(
            textAlign: TextAlign.center,
            text: descriptionText!,
          ),
        if (child != null)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: child,
          ),
      ],
    );
  }

  Widget buildActions(BuildContext context, FastMediaType mediaType) {
    if (mediaType >= FastMediaType.tablet) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (onCancelTap != null) ...[
            buildCancelButton(),
            ThemeHelper.spacing.getHorizontalSpacing(context),
          ],
          buildValidButton(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildCancelButton(),
        buildValidButton(),
      ],
    );
  }

  /// Builds the widget for the icon.
  Widget buildIcon() {
    return FastPageHeaderRoundedDuotoneIconLayout(
      palette: palette,
      hasShadow: true,
      icon: icon!,
    );
  }

  /// Builds the widget for the cancel button.
  Widget buildCancelButton() {
    if (onCancelTap != null && cancelButtonText != null) {
      return FastOutlineButton(onTap: onCancelTap, text: cancelButtonText);
    }

    return const SizedBox.shrink();
  }

  /// Builds the widget for the valid button.
  Widget buildValidButton() {
    if (onValidTap != null && validButtonText != null) {
      return FastPendingRaisedButton(
        isPending: isValidButtonPending,
        text: validButtonText,
        onTap: onValidTap,
      );
    }

    return const SizedBox.shrink();
  }
}
