// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

//TODO: @need-review: code from fastyle_dart

class FastOutlineButton extends FastButton {
  final Color? borderColor;

  const FastOutlineButton({
    required super.onTap,
    super.trottleTimeDuration,
    super.shouldTrottleTime,
    super.highlightColor,
    super.isEnabled,
    super.textColor,
    super.emphasis,
    super.padding,
    super.child,
    super.text,
    super.key,
    this.borderColor,
  })  : assert(
          child == null || text == null,
          'child and text properties cannot be initialized at the same time',
        ),
        assert(
          child != null || text != null,
          'child or text properties must be initialized',
        );

  @override
  FastOutlineButtonState createState() => FastOutlineButtonState();
}

class FastOutlineButtonState extends State<FastOutlineButton>
    with FastThrottleButtonMixin, FastButtonSyleMixin {
  @override
  void dispose() {
    unsubscribeToTrottlerEventsIfNeeded();
    trottler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = ThemeHelper.texts.getButtonTextStyle(context);
    final borderColor = widget.borderColor ??
        (widget.emphasis == FastButtonEmphasis.high
            ? ThemeHelper.colors.getPrimaryColor(context)
            : buttonTextStyle.color!);

    final disabledColor = borderColor.withAlpha(kDisabledAlpha);
    final textColor = widget.textColor ?? borderColor;

    return OutlinedButtonTheme(
      data: const OutlinedButtonThemeData(
        style: ButtonStyle(),
      ),
      child: OutlinedButton(
        onPressed: throttleOnTapIfNeeded(),
        style: ButtonStyle(
          overlayColor: getOverlayColor(textColor),
          padding: getButtonPadding(),
          shape: getButtonShape(),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(
            color: widget.isEnabled ? borderColor : disabledColor,
          )),
        ),
        child: widget.child ??
            buildButtonLabel(
              textColor,
              disabledTextColor: disabledColor,
            ),
      ),
    );
  }
}
