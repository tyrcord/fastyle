import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastToolBarButton extends StatelessWidget {
  final Duration trottleTimeDuration;
  final FastButtonEmphasis emphasis;
  final EdgeInsetsGeometry? padding;
  final Color? disabledIconColor;
  final Color? disabledTextColor;
  final Alignment iconAlignment;
  final bool shouldTrottleTime;
  final String? semanticLabel;
  final Color? highlightColor;
  final Color? focusColor;
  final Color? hoverColor;
  final VoidCallback? onTap;
  final String? labelText;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final String? tooltip;
  final bool isEnabled;
  final bool upperCase;
  final Widget icon;

  const FastToolBarButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.iconAlignment = Alignment.center,
    this.iconSize = kFastIconSizeSmall,
    this.shouldTrottleTime = false,
    this.upperCase = false,
    this.isEnabled = true,
    this.disabledIconColor,
    this.disabledTextColor,
    this.highlightColor,
    this.semanticLabel,
    this.focusColor,
    this.hoverColor,
    this.labelText,
    this.iconColor,
    this.textColor,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (context, mediaType) {
        final showLabel = mediaType.index >= FastMediaType.tablet.index;

        Widget button = FastIconButton(
          disabledColor: _getDisabledIconColor(context),
          trottleTimeDuration: trottleTimeDuration,
          shouldTrottleTime: shouldTrottleTime,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          iconColor: _getIconColor(context),
          iconAlignment: iconAlignment,
          isEnabled: isEnabled,
          emphasis: emphasis,
          iconSize: iconSize,
          padding: padding,
          onTap: onTap,
          icon: icon,
        );

        if (showLabel && labelText != null) {
          button = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              button,
              _buildLabel(context),
              kFastHorizontalSizedBox12,
            ],
          );
        }

        if (tooltip != null) {
          button = FastTooltip(
            preferBelow: true,
            message: tooltip!,
            child: button,
          );
        }

        return Semantics(
          label: semanticLabel,
          enabled: isEnabled,
          button: true,
          onTap: onTap,
          child: FastInkWell(
            highlightColor: highlightColor,
            hoverColor: hoverColor,
            focusColor: focusColor,
            onTap: onTap,
            child: button,
          ),
        );
      },
    );
  }

  Widget _buildLabel(BuildContext context) {
    final color =
        isEnabled ? _getTextColor(context) : _getDisabledTextColor(context);

    return FastSecondaryBody(
      upperCase: upperCase,
      text: labelText!,
      textColor: color,
    );
  }

  Color? _getDisabledIconColor(BuildContext context) {
    return disabledIconColor ??
        _getIconColor(context)?.withAlpha(kDisabledAlpha);
  }

  Color? _getDisabledTextColor(BuildContext context) {
    return disabledTextColor ??
        _getTextColor(context)?.withAlpha(kDisabledAlpha);
  }

  Color? _getTextColor(BuildContext context) {
    return textColor ??
        ThemeHelper.texts.getSecondaryBodyTextStyle(context).color;
  }

  Color? _getIconColor(BuildContext context) {
    return iconColor ??
        ThemeHelper.texts.getSecondaryBodyTextStyle(context).color;
  }
}
