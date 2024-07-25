import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastToolBarButton extends StatelessWidget {
  final Duration trottleTimeDuration;
  final FastButtonEmphasis emphasis;
  final EdgeInsetsGeometry? padding;
  final Alignment iconAlignment;
  final bool shouldTrottleTime;
  final Color? highlightColor;
  final Color? disabledColor;
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
    this.highlightColor,
    this.disabledColor,
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

        final button = FastIconButton(
          trottleTimeDuration: trottleTimeDuration,
          shouldTrottleTime: shouldTrottleTime,
          iconColor: _getIconColor(context),
          highlightColor: highlightColor,
          iconAlignment: iconAlignment,
          disabledColor: disabledColor,
          textColor: textColor,
          isEnabled: isEnabled,
          emphasis: emphasis,
          iconSize: iconSize,
          padding: padding,
          tooltip: tooltip,
          onTap: onTap,
          icon: icon,
        );

        if (showLabel && labelText != null) {
          return GestureDetector(
            onTap: isEnabled ? onTap : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                button,
                FastSecondaryBody(text: labelText!, upperCase: upperCase),
                kFastHorizontalSizedBox12,
              ],
            ),
          );
        }

        return button;
      },
    );
  }

  Color? _getIconColor(BuildContext context) {
    return iconColor ??
        ThemeHelper.texts.getSecondaryBodyTextStyle(context).color;
  }
}
