// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

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

  /// The color of the outline border.
  final Color? borderColor;

  const FastOutlinedButton({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    this.upperCase = false,
    super.isEnabled = true,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    this.textAlignment,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    this.textStyle,
    this.labelText,
    super.padding,
    super.tooltip,
    super.onTap,
    this.borderWidth = 1.0,
    this.borderColor,
  });

  @override
  State<FastOutlinedButton> createState() => _FastOutlinedButtonState();
}

class _FastOutlinedButtonState extends State<FastOutlinedButton>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    final borderColor = getBorderColor(context);

    BoxDecoration? decoration;

    if (borderColor != null) {
      decoration = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: borderColor,
          width: widget.borderWidth,
        ),
      );
    }

    return buildButton(
      context,
      buildText(context),
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12.0),
      constraints: widget.constraints ?? kFastButtonConstraints,
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      alignment: widget.textAlignment,
      color: widget.textStyle?.color,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      tooltip: widget.tooltip,
      decoration: decoration,
      onTap: onTapCallback,
    );
  }

  Widget buildText(BuildContext context) {
    return FastButtonLabel(
      text: widget.labelText ?? CoreLocaleKeys.core_label_button.tr(),
      fontWeight: widget.textStyle?.fontWeight,
      fontSize: widget.textStyle?.fontSize,
      upperCase: widget.upperCase,
      textColor: getColor(
        context,
        disabledColor: widget.disabledColor,
        color: widget.textStyle?.color,
        isEnabled: widget.isEnabled,
        emphasis: widget.emphasis,
      ),
    );
  }

  Color? getBorderColor(BuildContext context) {
    return widget.borderColor ??
        getColor(
          context,
          disabledColor: widget.disabledColor,
          color: widget.textStyle?.color,
          isEnabled: widget.isEnabled,
          emphasis: widget.emphasis,
        );
  }
}
