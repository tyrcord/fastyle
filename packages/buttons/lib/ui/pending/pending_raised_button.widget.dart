// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastPendingRaisedButton extends FastButton {
  final bool isPending;

  const FastPendingRaisedButton({
    super.key,
    required super.onTap,
    super.textColor,
    super.padding,
    super.text,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
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
  void didUpdateWidget(FastPendingRaisedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPending != oldWidget.isPending && widget.isPending) {
      _updateConstraints(context);
    }
  }

  void _updateConstraints(BuildContext context) {
    setState(() {
      final width = _getButtonWidth(context);
      _constraints = BoxConstraints(maxWidth: width, minWidth: width);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FastRaisedButton(
      padding: widget.isPending ? EdgeInsets.zero : widget.padding,
      isEnabled: !widget.isPending && widget.isEnabled,
      trottleTimeDuration: widget.trottleTimeDuration,
      text: !widget.isPending ? widget.text : null,
      shouldTrottleTime: widget.shouldTrottleTime,
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

    return renderBox?.size.width ?? 0.0;
  }
}
