// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastIconButton2 extends FastButton2 {
  final BoxConstraints? constraints;
  final Alignment? iconAlignment;
  final Color? iconColor;
  final double? iconSize;
  final Widget icon;

  const FastIconButton2({
    super.key,
    required this.icon,
    super.trottleTimeDuration = kFastTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = false,
    super.isEnabled = true,
    super.highlightColor,
    super.disabledColor,
    this.iconAlignment,
    this.constraints,
    super.focusColor,
    super.hoverColor,
    this.iconColor,
    this.iconSize,
    super.padding,
    super.onTap,
  });

  @override
  State<FastIconButton2> createState() => _FastIconButton2State();
}

class _FastIconButton2State extends State<FastIconButton2>
    with FastButtonMixin2, FastThrottleButtonMixin2<FastIconButton2> {
  @override
  Widget build(BuildContext context) {
    return FastInkWell(
      highlightColor: widget.highlightColor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      onTap: onTapCallback,
      child: Container(
        constraints: widget.constraints ?? kDefaultIconButtonConstraints,
        alignment: widget.iconAlignment ?? Alignment.center,
        padding: widget.padding,
        child: buildIcon(context),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (widget.icon is FaIcon || widget.icon is Icon) {
      return Icon(
        getIconData(context, widget.icon),
        color: getIconColor(context),
        size: getIconSize(context),
      );
    }

    return widget.icon;
  }

  IconData? getIconData(BuildContext context, Widget icon) {
    if (icon is FaIcon) return icon.icon;
    if (icon is Icon) return icon.icon;

    return null;
  }

  double getIconSize(BuildContext context) {
    if (widget.iconSize != null) return widget.iconSize!;

    if ((widget.icon is FaIcon) && (widget.icon as FaIcon).size != null) {
      return (widget.icon as FaIcon).size!;
    }

    if ((widget.icon is Icon) && (widget.icon as Icon).size != null) {
      return (widget.icon as Icon).size!;
    }

    return kFastIconSizeSmall;
  }

  Color? getIconColor(BuildContext context) {
    if (!widget.isEnabled) return getDisabledColor(context);
    if (widget.iconColor != null) return widget.iconColor;

    if ((widget.icon is FaIcon) && (widget.icon as FaIcon).color != null) {
      return (widget.icon as FaIcon).color!;
    }

    if ((widget.icon is Icon) && (widget.icon as Icon).color != null) {
      return (widget.icon as Icon).color!;
    }

    return getEmphasisedColor(context);
  }

  Color? getDisabledColor(BuildContext context) {
    if (widget.disabledColor != null) return widget.disabledColor!;

    if (widget.iconColor != null) {
      return widget.iconColor!.withAlpha(kDisabledAlpha);
    }

    if ((widget.icon is FaIcon) && (widget.icon as FaIcon).color != null) {
      return (widget.icon as FaIcon).color!.withAlpha(kDisabledAlpha);
    }

    if ((widget.icon is Icon) && (widget.icon as Icon).color != null) {
      return (widget.icon as Icon).color!.withAlpha(kDisabledAlpha);
    }

    return getEmphasisedColor(context)?.withAlpha(kDisabledAlpha);
  }
}
