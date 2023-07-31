// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastRaisedButton extends FastButton {
  final Color? backgroundColor;
  final double? elevation;

  const FastRaisedButton({
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
  FastRaisedButtonState createState() => FastRaisedButtonState();
}

class FastRaisedButtonState extends State<FastRaisedButton>
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
          context: context,
          darkColor: ThemeHelper.texts.getButtonTextStyle(context).color!,
          lightColor: palette.whiteColor,
          backgroundColor: backgroundColor,
        );

    return ElevatedButton(
      onPressed: throttleOnTapIfNeeded(),
      style: ElevatedButton.styleFrom(
        foregroundColor: widget.highlightColor,
        padding: widget.padding,
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        disabledBackgroundColor: backgroundColor.withOpacity(0.5),
        backgroundColor: backgroundColor,
      ),
      child: widget.child ?? buildButtonLabel(textColor),
    );
  }
}
