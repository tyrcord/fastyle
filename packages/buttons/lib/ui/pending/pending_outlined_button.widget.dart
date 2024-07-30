// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastPendingOutlinedButton extends FastOutlinedButton {
  final bool isPending;

  const FastPendingOutlinedButton({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    super.upperCase = false,
    super.isEnabled = true,
    this.isPending = false,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    super.textAlignment,
    super.borderWidth,
    super.constraints,
    super.color,
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
    with
        FastButtonMixin2,
        FastThrottleButtonMixin2<FastPendingOutlinedButton>,
        FastPendingButtonMixin {
  @override
  void didUpdateWidget(FastPendingOutlinedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.labelText != oldWidget.labelText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => updateConstraints());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastOutlinedButton(
      padding: widget.isPending ? EdgeInsets.zero : widget.padding,
      labelText: !widget.isPending ? widget.labelText : null,
      isEnabled: !widget.isPending && widget.isEnabled,
      trottleTimeDuration: widget.trottleTimeDuration,
      shouldTrottleTime: widget.shouldTrottleTime,
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      textAlignment: widget.textAlignment,
      color: widget.color,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      emphasis: widget.emphasis,
      flexible: widget.flexible,
      tooltip: widget.tooltip,
      onTap: widget.onTap,
      size: widget.size,
      key: buttonKey,
      child: widget.isPending ? buildPendingIndicator(context) : null,
    );
  }

  @override
  Color? getIndicatorColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return getBorderColor(
          context,
          isEnabled: !widget.isPending && widget.isEnabled,
          disabledColor: widget.disabledColor,
          borderColor: widget.color,
          textStyle: widget.textStyle,
          emphasis: widget.emphasis,
        ) ??
        palette.whiteColor;
  }
}
