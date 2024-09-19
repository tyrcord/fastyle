// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastPendingOutlinedButton extends FastOutlinedButton {
  final bool isPending;
  final bool expand;

  const FastPendingOutlinedButton({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    this.expand = false,
    super.upperCase = false,
    super.isEnabled = true,
    this.isPending = false,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    super.textAlignment,
    super.borderWidth,
    super.constraints,
    super.borderColor,
    super.textColor,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.textStyle,
    super.labelText,
    super.flexible,
    super.padding,
    super.tooltip,
    super.onTap,
    super.size,
  });

  @override
  FastPendingOutlineButtonState createState() =>
      FastPendingOutlineButtonState();
}

class FastPendingOutlineButtonState extends State<FastPendingOutlinedButton>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastPendingOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    final isPending = widget.isPending;
    final isEnabled = !isPending && widget.isEnabled;
    final textColor = getTextColor(
      context,
      color: widget.textStyle?.color ?? widget.textColor,
      emphasis: widget.emphasis,
      isEnabled: isEnabled,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: widget.expand ? double.infinity : null,
          child: FastOutlinedButton(
            disabledColor:
                isPending ? Colors.transparent : widget.disabledColor,
            textColor: isPending ? Colors.transparent : textColor,
            trottleTimeDuration: widget.trottleTimeDuration,
            borderColor: widget.borderColor ?? textColor,
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
