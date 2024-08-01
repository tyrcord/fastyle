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
        FastPendingButtonMixin,
        WidgetsBindingObserver {
  BoxConstraints? _parentContraints;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(FastPendingOutlinedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.labelText != oldWidget.labelText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => updateConstraints());
    }
  }

  @override
  void didChangeMetrics() {
    // Update constraints when the application's dimensions change
    WidgetsBinding.instance.addPostFrameCallback((_) => updateConstraints());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Check if constraints have changed
      if (_parentContraints != constraints) {
        _parentContraints = constraints;
        // Schedule a post-frame callback to update constraints
        WidgetsBinding.instance
            .addPostFrameCallback((_) => updateConstraints());
      }

      return FastOutlinedButton(
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
        size: widget.size,
        key: buttonKey,
        child: widget.isPending ? buildPendingIndicator(context) : null,
      );
    });
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
