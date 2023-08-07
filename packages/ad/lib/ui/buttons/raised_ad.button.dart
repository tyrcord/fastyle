// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAdRaisedButton extends FastButton {
  final Color? backgroundColor;
  final double? elevation;

  const FastAdRaisedButton({
    required super.onTap,
    super.trottleTimeDuration,
    super.shouldTrottleTime,
    super.highlightColor,
    super.isEnabled,
    super.textColor,
    super.padding,
    super.child,
    super.text,
    super.key,
    this.backgroundColor,
    this.elevation,
  })  : assert(
          child == null || text == null,
          'child and text properties cannot be initialized at the same time',
        ),
        assert(
          child != null || text != null,
          'child or text properties must be initialized',
        );

  @override
  FastAdRaisedButtonState createState() => FastAdRaisedButtonState();
}

class FastAdRaisedButtonState extends State<FastAdRaisedButton>
    with FastThrottleButtonMixin, FastButtonSyleMixin {
  @override
  void dispose() {
    unsubscribeToTrottlerEventsIfNeeded();
    trottler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeHelper.colors;
    final backgroundColor =
        widget.backgroundColor ?? colors.getPrimaryColor(context);
    final palette = ThemeHelper.getPaletteColors(context);
    final textColor = widget.textColor ??
        colors.getColorWithBestConstrast(
          darkColor: ThemeHelper.texts.getButtonTextStyle(context).color!,
          backgroundColor: backgroundColor,
          lightColor: palette.whiteColor,
          context: context,
        );

    return GestureDetector(
      onTap: throttleOnTapIfNeeded(),
      child: FastShadowLayout(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: widget.isEnabled
                    ? backgroundColor
                    : backgroundColor.withOpacity(0.5),
              ),
              padding: _scaledPadding(context),
              alignment: Alignment.center,
              child: widget.child ?? buildButtonLabel(textColor),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsetsGeometry _scaledPadding(BuildContext context) {
    const double padding1x = 12.0;

    return ButtonStyleButton.scaledPadding(
      const EdgeInsets.symmetric(horizontal: padding1x),
      const EdgeInsets.symmetric(horizontal: padding1x / 2),
      const EdgeInsets.symmetric(horizontal: padding1x / 2 / 2),
      MediaQuery.textScaleFactorOf(context),
    );
  }
}
