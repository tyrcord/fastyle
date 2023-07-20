import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class FastPendingRaisedButton extends FastButton {
  final bool isPending;

  const FastPendingRaisedButton({
    super.key,
    required super.onTap,
    super.textColor,
    super.padding,
    super.text,
    super.trottleTimeDuration = kFastTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    super.isEnabled = true,
    super.highlightColor,
    this.isPending = false,
  });

  @override
  FastPendingRaisedButtonState createState() => FastPendingRaisedButtonState();
}

class FastPendingRaisedButtonState extends State<FastPendingRaisedButton>
    with FastThrottleButtonMixin, FastButtonSyleMixin {
  BoxConstraints? _constraints;

  @override
  didUpdateWidget(FastPendingRaisedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPending != oldWidget.isPending) {
      if (widget.isPending) {
        final width = _getButtonWidth(context);
        _constraints = BoxConstraints(maxWidth: width, minWidth: width);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastRaisedButton(
      padding: widget.isPending ? EdgeInsets.zero : widget.padding,
      isEnabled: !widget.isPending && widget.isEnabled,
      trottleTimeDuration: widget.trottleTimeDuration,
      shouldTrottleTime: widget.shouldTrottleTime,
      text: !widget.isPending ? widget.text : null,
      highlightColor: widget.highlightColor,
      textColor: widget.textColor,
      onTap: widget.onTap,
      child: widget.isPending ? _buildPendingIndicator(context) : null,
    );
  }

  Widget _buildPendingIndicator(BuildContext context) {
    return Container(
      constraints: _constraints,
      child: FastThreeBounceIndicator(color: _getTextColor(context)),
    );
  }

  Color? _getTextColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return widget.textColor ?? palette.whiteColor;
  }

  double _getButtonWidth(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      return renderBox.size.width;
    }

    return 0.0;
  }
}
