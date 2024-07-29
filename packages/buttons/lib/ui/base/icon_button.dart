// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastIconButton2 extends FastButton2 {
  /// The icon alignment.
  final Alignment? iconAlignment;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// Custom icon for the button (optional).
  final Widget icon;

  const FastIconButton2({
    super.key,
    required this.icon,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    super.isEnabled = true,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    this.iconAlignment,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    this.iconColor,
    this.iconSize,
    super.padding,
    super.tooltip,
    super.onTap,
  });

  @override
  State<FastIconButton2> createState() => _FastIconButton2State();
}

class _FastIconButton2State extends State<FastIconButton2>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastIconButton2> {
  @override
  Widget build(BuildContext context) {
    Widget button = FastInkWell(
      highlightColor: getHighlightColor(
        context,
        highlightColor: widget.highlightColor,
        color: widget.iconColor,
        emphasis: widget.emphasis,
        icon: widget.icon,
      ),
      focusColor: widget.focusColor,
      hoverColor: getHoverColor(
        context,
        hoverColor: widget.hoverColor,
        color: widget.iconColor,
        emphasis: widget.emphasis,
        icon: widget.icon,
      ),
      isEnabled: widget.isEnabled,
      onTap: onTapCallback,
      child: Container(
        constraints: widget.constraints ?? kFastIconButtonConstraints,
        alignment: widget.iconAlignment ?? Alignment.center,
        padding: widget.padding,
        child: buildIcon(context),
      ),
    );

    // Wrap with Semantics
    button = Semantics(
      label: widget.semanticLabel,
      enabled: widget.isEnabled,
      button: true,
      child: button,
    );

    // Wrap with Tooltip if a tooltip is provided
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  Widget buildIcon(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: getColor(
          context,
          disabledColor: widget.disabledColor,
          color: widget.iconColor,
          isEnabled: widget.isEnabled,
          emphasis: widget.emphasis,
          icon: widget.icon,
        ),
        size: getIconSize(
          context,
          iconSize: widget.iconSize,
          icon: widget.icon,
        ),
      ),
      child: widget.icon,
    );
  }

  IconData? getIconData(BuildContext context, Widget icon) {
    if (icon is FaIcon) return icon.icon;
    if (icon is Icon) return icon.icon;

    return null;
  }
}
