// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastTextButton extends FastButton {
  @override
  const FastTextButton({
    required super.onTap,
    super.trottleTimeDuration,
    super.shouldTrottleTime,
    super.highlightColor,
    super.isEnabled,
    super.textColor,
    super.upperCase,
    super.emphasis,
    super.padding,
    super.child,
    super.text,
    super.key,
  })  : assert(
          child == null || text == null,
          'child and text properties cannot be initialized at the same time',
        ),
        assert(
          child != null || text != null,
          'child or text properties must be initialized',
        );

  @override
  FastTextButtonState createState() => FastTextButtonState();
}

class FastTextButtonState extends State<FastTextButton>
    with FastThrottleButtonMixin, FastButtonSyleMixin {
  @override
  void dispose() {
    unsubscribeToTrottlerEventsIfNeeded();
    trottler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.textColor ??
        (widget.emphasis == FastButtonEmphasis.high
            ? ThemeHelper.colors.getPrimaryColor(context)
            : ThemeHelper.texts.getButtonTextStyle(context).color!);

    return TextButton(
      style: ButtonStyle(
        overlayColor: getOverlayColor(textColor),
        padding: getButtonPadding(),
        shape: getButtonShape(),
      ),
      onPressed: throttleOnTapIfNeeded(),
      child: widget.child ??
          buildButtonLabel(
            textColor,
            upperCase: widget.upperCase,
          ),
    );
  }
}
