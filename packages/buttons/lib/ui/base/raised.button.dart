// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastRaisedButton2 extends FastButton2 {
  /// The text to display on the button.
  final String? labelText;

  /// The style of the text.
  final TextStyle? textStyle;

  /// The alignment of the text within the button.
  final Alignment? textAlignment;

  /// Whether to display the label in uppercase.
  final bool upperCase;

  final Color? color;

  final Widget? child;

  const FastRaisedButton2({
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
  State<FastRaisedButton2> createState() => _FastRaisedButtonState2();
}

class _FastRaisedButtonState2 extends State<FastRaisedButton2>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastRaisedButton2> {
  bool isHovering = false;

  void _handleHover(bool isHovering) {
    setState(() => this.isHovering = isHovering);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = getColor(
      context,
      color: widget.color ?? ThemeHelper.colors.getPrimaryColor(context),
      disabledColor: widget.disabledColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
    );

    BoxDecoration? decoration;

    if (backgroundColor != null) {
      decoration = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [getShadow(context, backgroundColor)],
        color: backgroundColor,
      );
    }

    final interactionsColor = ThemeHelper.colors.getColorWithBestConstrast(
      backgroundColor: backgroundColor,
      darkColor: ThemeHelper.getPaletteColors(context).gray.ultraDark,
      lightColor: ThemeHelper.getPaletteColors(context).whiteColor,
      context: context,
    );

    return buildButton(
      context,
      widget.child != null
          ? widget.child!
          : buildLabelText(
              context,
              color: ThemeHelper.getPaletteColors(context).whiteColor,
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
      color: interactionsColor,
      tooltip: widget.tooltip,
      decoration: decoration,
      onHover: _handleHover,
      onTap: onTapCallback,
      size: widget.size,
    );
  }

  BoxShadow getShadow(BuildContext context, Color backgroundColor) {
    if (isHovering) {
      return BoxShadow(
        color: backgroundColor.withAlpha(128),
        offset: const Offset(0, 0),
        spreadRadius: 1,
        blurRadius: 6,
      );
    }

    return BoxShadow(
      color: ThemeHelper.colors.getShadowColor(context),
      offset: const Offset(0, 0),
      spreadRadius: 1,
      blurRadius: 3,
    );
  }
}
