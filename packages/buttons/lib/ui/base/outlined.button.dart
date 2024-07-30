// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';


class FastOutlinedButton extends FastButton2 {
  /// The text to display on the button.
  final String? labelText;

  /// The style of the text.
  final TextStyle? textStyle;

  /// The alignment of the text within the button.
  final Alignment? textAlignment;

  /// Whether to display the label in uppercase.
  final bool upperCase;

  /// The width of the outline border.
  final double borderWidth;

  final Color? color;

  final Widget? child;

  const FastOutlinedButton({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    this.upperCase = false,
    super.isEnabled = true,
    this.borderWidth = 1.0,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    this.textAlignment,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.flexible,
    this.textStyle,
    this.labelText,
    super.padding,
    super.tooltip,
    super.onTap,
    this.color,
    this.child,
    super.size,
  });

  @override
  State<FastOutlinedButton> createState() => _FastOutlinedButtonState();
}

class _FastOutlinedButtonState extends State<FastOutlinedButton>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    final borderColor = getBorderColor(
      context,
      disabledColor: widget.disabledColor,
      isEnabled: widget.isEnabled,
      textStyle: widget.textStyle,
      borderColor: widget.color,
      emphasis: widget.emphasis,
    );

    BoxDecoration? decoration;

    if (borderColor != null) {
      decoration = BoxDecoration(
        border: Border.all(width: widget.borderWidth, color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );
    }

    return buildButton(
      context,
      widget.child != null
          ? widget.child!
          : buildLabelText(
              context,
              color: borderColor,
              disabledColor: widget.disabledColor,
              textStyle: widget.textStyle,
              upperCase: widget.upperCase,
              isEnabled: widget.isEnabled,
              labelText: widget.labelText,
              emphasis: widget.emphasis,
              size: widget.size,
            ),
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12.0),
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      constraints: widget.constraints,
      alignment: widget.textAlignment,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      flexible: widget.flexible,
      tooltip: widget.tooltip,
      decoration: decoration,
      onTap: onTapCallback,
      color: borderColor,
      size: widget.size,
    );
  }
}
