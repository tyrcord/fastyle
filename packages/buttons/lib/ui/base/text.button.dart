// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

class FastTextButton2 extends FastButton2 {
  /// The text to display on the button.
  final String? labelText;

  /// The style of the text.
  final TextStyle? textStyle;

  /// The alignment of the text within the button.
  final Alignment? textAlignment;

  /// Whether to display the label in uppercase.
  final bool upperCase;

  const FastTextButton2({
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
  });

  @override
  State<FastTextButton2> createState() => _FastTextButton2State();
}

class _FastTextButton2State extends State<FastTextButton2>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastTextButton2> {
  @override
  Widget build(BuildContext context) {
    Widget button = FastInkWell(
      highlightColor: getHighlightColor(
        context,
        highlightColor: widget.highlightColor,
        color: widget.textStyle?.color,
        emphasis: widget.emphasis,
      ),
      focusColor: widget.focusColor,
      hoverColor: getHoverColor(
        context,
        hoverColor: widget.hoverColor,
        color: widget.textStyle?.color,
        emphasis: widget.emphasis,
      ),
      isEnabled: widget.isEnabled,
      onTap: onTapCallback,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12.0),
        constraints: widget.constraints ?? kFastButtonConstraints,
        alignment: widget.textAlignment ?? Alignment.center,
        child: buildText(context),
      ),
    );

    // Wrap with Semantics
    button = Semantics(
      label: widget.semanticLabel,
      enabled: widget.isEnabled,
      button: true,
      child: button,
    );

    // Wrap with Tooltip if a tooltip is provided
    if (widget.tooltip != null) {
      button = FastTooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
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
}
