// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastTextButton2 extends FastButton2 {
  /// The text to display on the button.
  final String? labelText;

  /// The style of the text.
  final TextStyle? textStyle;

  /// The alignment of the text within the button.
  final Alignment? textAlignment;

  /// Whether to display the label in uppercase.
  final bool upperCase;

  /// The child contained.
  final Widget? child;

  /// The background color of the button.
  final Color? backgroundColor;

  const FastTextButton2({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    this.upperCase = false,
    super.isEnabled = true,
    this.backgroundColor,
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
    super.size,
    this.child,
  });

  @override
  State<FastTextButton2> createState() => _FastTextButton2State();
}

class _FastTextButton2State extends State<FastTextButton2>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastTextButton2> {
  @override
  Widget build(BuildContext context) {
    BoxDecoration? decoration;

    if (widget.backgroundColor != null) {
      decoration = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: widget.backgroundColor,
      );
    }

    return buildButton(
      context,
      widget.child != null
          ? widget.child!
          : buildLabelText(
              context,
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
      color: widget.textStyle?.color,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      flexible: widget.flexible,
      tooltip: widget.tooltip,
      decoration: decoration,
      onTap: onTapCallback,
      icon: widget.child,
      size: widget.size,
    );
  }
}
