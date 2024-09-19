// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastPendingRaisedButton extends FastRaisedButton2 {
  final bool isPending;
  final bool expand;

  const FastPendingRaisedButton({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    super.upperCase = false,
    super.isEnabled = true,
    this.isPending = false,
    this.expand = false,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    super.textAlignment,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.textStyle,
    super.labelText,
    super.textColor,
    super.flexible,
    super.padding,
    super.tooltip,
    super.onTap,
    super.color,
    super.size,
  });

  @override
  FastPendingRaisedButtonState createState() => FastPendingRaisedButtonState();
}

class FastPendingRaisedButtonState extends State<FastPendingRaisedButton>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastPendingRaisedButton> {
  @override
  Widget build(BuildContext context) {
    final isPending = widget.isPending;
    final isEnabled = !isPending && widget.isEnabled;
    final palette = ThemeHelper.getPaletteColors(context);
    final textColor = getTextColor(
      context,
      color: widget.textStyle?.color ?? widget.textColor ?? palette.whiteColor,
      emphasis: widget.emphasis,
      isEnabled: isEnabled,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: widget.expand ? double.infinity : null,
          child: FastRaisedButton2(
            disabledColor:
                isPending ? Colors.transparent : widget.disabledColor,
            textColor: isPending ? Colors.transparent : textColor,
            trottleTimeDuration: widget.trottleTimeDuration,
            shouldTrottleTime: widget.shouldTrottleTime,
            highlightColor: widget.highlightColor,
            semanticLabel: widget.semanticLabel,
            textAlignment: widget.textAlignment,
            focusColor: widget.focusColor,
            hoverColor: widget.hoverColor,
            labelText: widget.labelText,
            emphasis: widget.emphasis,
            flexible: widget.flexible,
            tooltip: widget.tooltip,
            padding: widget.padding,
            isEnabled: isEnabled,
            color: widget.color,
            onTap: widget.onTap,
            size: widget.size,
          ),
        ),
        if (isPending)
          Positioned.fill(
            child: FastThreeBounceIndicator(color: textColor),
          ),
      ],
    );
  }
}
