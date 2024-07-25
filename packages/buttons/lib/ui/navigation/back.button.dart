// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class FastBackButton extends FastButton {
  final Alignment iconAlignment;
  final Color? iconColor;
  final double iconSize;
  final String? tooltip;
  final Widget? icon;

  const FastBackButton({
    super.trottleTimeDuration,
    super.shouldTrottleTime,
    super.highlightColor,
    super.disabledColor,
    super.textColor,
    super.isEnabled,
    super.emphasis,
    super.padding,
    super.onTap,
    super.key,
    this.iconAlignment = Alignment.center,
    this.iconSize = kFastIconSizeLarge,
    this.iconColor,
    this.tooltip,
    this.icon,
  });

  @override
  FastBackButtonState createState() => FastBackButtonState();
}

class FastBackButtonState extends State<FastBackButton> {
  void handleTap(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
    } else if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastIconButton(
      trottleTimeDuration: widget.trottleTimeDuration,
      shouldTrottleTime: widget.shouldTrottleTime,
      highlightColor: widget.highlightColor,
      iconAlignment: widget.iconAlignment,
      disabledColor: widget.disabledColor,
      onTap: () => handleTap(context),
      textColor: widget.textColor,
      iconColor: widget.iconColor,
      isEnabled: widget.isEnabled,
      emphasis: widget.emphasis,
      iconSize: widget.iconSize,
      icon: buildIcon(context),
      padding: widget.padding,
      tooltip: widget.tooltip,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (widget.icon != null) return widget.icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightChevronLeft);
    }

    return const FaIcon(FontAwesomeIcons.chevronLeft);
  }
}
