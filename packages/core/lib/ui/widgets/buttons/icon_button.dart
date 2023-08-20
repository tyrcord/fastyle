// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastIconButton extends FastButton {
  final Alignment iconAlignment;
  final Color? iconColor;
  final double iconSize;
  final String? tooltip;
  final Widget icon;

  const FastIconButton({
    required super.onTap,
    required this.icon,
    super.trottleTimeDuration,
    super.shouldTrottleTime,
    super.highlightColor,
    super.isEnabled,
    super.disabledColor,
    super.textColor,
    super.emphasis,
    super.padding,
    super.key,
    this.iconAlignment = Alignment.center,
    this.iconSize = kFastIconSizeSmall,
    this.iconColor,
    this.tooltip,
  });

  @override
  FastIconButtonState createState() => FastIconButtonState();
}

class FastIconButtonState extends State<FastIconButton>
    with FastThrottleButtonMixin {
  @override
  void dispose() {
    unsubscribeToTrottlerEventsIfNeeded();
    trottler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final color = widget.iconColor ??
        (widget.emphasis == FastButtonEmphasis.high
            ? ThemeHelper.colors.getPrimaryColor(context)
            : ThemeHelper.texts.getButtonTextStyle(context).color!);

    return Theme(
      // FIXME: Temporary workaround, will probably need to make out own.
      data: themeData.copyWith(useMaterial3: false),
      child: IconButton(
        icon: Align(alignment: widget.iconAlignment, child: widget.icon),
        disabledColor: widget.disabledColor ?? color.withAlpha(kDisabledAlpha),
        padding: widget.padding ?? kFastEdgeInsets8,
        highlightColor: widget.highlightColor,
        onPressed: throttleOnTapIfNeeded(),
        splashRadius: kFastSplashRadius,
        iconSize: widget.iconSize,
        tooltip: widget.tooltip,
        color: color,
      ),
    );
  }
}
