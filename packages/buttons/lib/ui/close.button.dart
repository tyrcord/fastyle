// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//TODO: @need-review: code from fastyle_dart

class FastCloseButton extends FastButton {
  final Alignment iconAlignment;
  final Color? iconColor;
  final double iconSize;
  final String? tooltip;
  final Widget? icon;

  const FastCloseButton({
    super.trottleTimeDuration,
    super.shouldTrottleTime,
    super.highlightColor,
    super.disabledColor,
    super.isEnabled,
    super.textColor,
    super.emphasis,
    super.padding,
    super.onTap,
    super.key,
    this.iconAlignment = Alignment.center,
    this.iconSize = kFastIconSizeSmall,
    this.iconColor,
    this.tooltip,
    this.icon,
  });

  @override
  FastCloseButtonState createState() => FastCloseButtonState();
}

class FastCloseButtonState extends State<FastCloseButton>
    with FastThrottleButtonMixin {
  @override
  void dispose() {
    super.dispose();
    unsubscribeToTrottlerEventsIfNeeded();
    trottler.close();
  }

  @override
  Widget build(BuildContext context) {
    return FastIconButton(
      trottleTimeDuration: widget.trottleTimeDuration,
      shouldTrottleTime: widget.shouldTrottleTime,
      highlightColor: widget.highlightColor,
      iconAlignment: widget.iconAlignment,
      disabledColor: widget.disabledColor,
      textColor: widget.textColor,
      iconColor: widget.iconColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      iconSize: widget.iconSize,
      icon: buildIcon(context),
      padding: widget.padding,
      tooltip: widget.tooltip,
      onTap: widget.onTap,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (widget.icon != null) {
      return widget.icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightXmark);
    }

    return const FaIcon(FontAwesomeIcons.xmark);
  }
}
