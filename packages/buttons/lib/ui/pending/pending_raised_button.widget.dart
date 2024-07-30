// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastPendingRaisedButton extends FastRaisedButton2 {
  final bool isPending;

  const FastPendingRaisedButton({
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
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.textStyle,
    super.labelText,
    super.flexible,
    super.padding,
    super.tooltip,
    super.onTap,
    super.color,
  });

  @override
  FastPendingRaisedButtonState createState() => FastPendingRaisedButtonState();
}

class FastPendingRaisedButtonState extends State<FastPendingRaisedButton>
    with
        FastThrottleButtonMixin2<FastPendingRaisedButton>,
        FastPendingButtonMixin {
  @override
  void didUpdateWidget(FastPendingRaisedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.labelText != oldWidget.labelText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => updateConstraints());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastRaisedButton2(
      padding: widget.isPending ? EdgeInsets.zero : widget.padding,
      labelText: !widget.isPending ? widget.labelText : null,
      isEnabled: !widget.isPending && widget.isEnabled,
      trottleTimeDuration: widget.trottleTimeDuration,
      shouldTrottleTime: widget.shouldTrottleTime,
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      textAlignment: widget.textAlignment,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      emphasis: widget.emphasis,
      flexible: widget.flexible,
      tooltip: widget.tooltip,
      color: widget.color,
      onTap: widget.onTap,
      key: buttonKey,
      child: widget.isPending ? buildPendingIndicator(context) : null,
    );
  }

  @override
  Color? getIndicatorColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return widget.color ?? palette.whiteColor;
  }
}
