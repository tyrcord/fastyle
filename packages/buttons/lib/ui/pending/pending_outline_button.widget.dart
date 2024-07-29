// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastPendingOutlineButton extends FastButton {
  final bool isPending;
  final Color? borderColor;

  const FastPendingOutlineButton({
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
    this.borderColor,
    this.isPending = false,
  });

  @override
  FastPendingOutlineButtonState createState() =>
      FastPendingOutlineButtonState();
}

class FastPendingOutlineButtonState extends State<FastPendingOutlineButton>
    with FastThrottleButtonMixin, FastButtonSyleMixin {
  BoxConstraints? _constraints;

  @override
  void didUpdateWidget(FastPendingOutlineButton oldWidget) {
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
    return FastOutlineButton(
      padding: widget.isPending ? EdgeInsets.zero : widget.padding,
      isEnabled: !widget.isPending && widget.isEnabled,
      trottleTimeDuration: widget.trottleTimeDuration,
      shouldTrottleTime: widget.shouldTrottleTime,
      text: !widget.isPending ? widget.text : null,
      highlightColor: widget.highlightColor,
      borderColor: widget.borderColor,
      textColor: widget.textColor,
      emphasis: widget.emphasis,
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
    return widget.textColor ??
        (widget.emphasis == FastButtonEmphasis.high
            ? ThemeHelper.colors.getPrimaryColor(context)
            : ThemeHelper.texts.getButtonTextStyle(context).color);
  }

  double _getButtonWidth(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      return renderBox.size.width;
    }

    return 0.0;
  }
}
