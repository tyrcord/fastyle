import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastToolBarButton extends StatelessWidget with FastButtonMixin2 {
  /// Whether the button is enabled.
  final bool isEnabled;

  /// The duration for throttling button taps.
  final Duration trottleTimeDuration;

  /// Whether to throttle button taps.
  final bool shouldTrottleTime;

  /// The color when the button is highlighted.
  final Color? highlightColor;

  /// The color when the button is disabled.
  final Color? disabledColor;

  /// The color when the button is focused.
  final Color? focusColor;

  /// The color when the button is hovered.
  final Color? hoverColor;

  /// The constraints for the button.
  final BoxConstraints? constraints;

  /// The callback when the button is tapped.
  final VoidCallback? onTap;

  /// The emphasis of the button.
  final FastButtonEmphasis emphasis;

  /// The padding of the button.
  final EdgeInsetsGeometry? padding;

  /// The tooltip message.
  final String? tooltip;

  /// The semantic label of the button.
  final String? semanticLabel;

  /// The debug label of the button to identify it in debug mode.
  final String? debugLabel;

  /// The icon alignment.
  final Alignment? iconAlignment;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// Custom icon for the button (optional).
  final Widget icon;

  /// The label text.
  final String? labelText;

  /// Whether to display the label in uppercase.
  final bool upperCase;

  /// Whether the button is flexible.
  final bool flexible;

  /// The size of the button.
  final FastButtonSize? size;

  /// The style of the text.
  final TextStyle? textStyle;

  const FastToolBarButton({
    super.key,
    required this.icon,
    this.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.shouldTrottleTime = false,
    this.upperCase = false,
    this.isEnabled = true,
    this.flexible = false,
    this.highlightColor,
    this.semanticLabel,
    this.disabledColor,
    this.iconAlignment,
    this.constraints,
    this.debugLabel,
    this.focusColor,
    this.hoverColor,
    this.textStyle,
    this.labelText,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.tooltip,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (context, mediaType) {
        final showLabel = mediaType.index >= FastMediaType.tablet.index;

        Widget button = FastIconButton2(
          trottleTimeDuration: trottleTimeDuration,
          shouldTrottleTime: shouldTrottleTime,
          highlightColor: Colors.transparent,
          padding: showLabel ? null : padding,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: showLabel ? null : onTap,
          iconAlignment: iconAlignment,
          disabledColor: disabledColor,
          iconColor: iconColor,
          isEnabled: isEnabled,
          emphasis: emphasis,
          flexible: flexible,
          iconSize: iconSize,
          size: size,
          icon: icon,
        );

        if (showLabel && labelText != null) {
          button = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              button,
              buildLabelText(
                context,
                disabledColor: disabledColor,
                textStyle: textStyle,
                upperCase: upperCase,
                isEnabled: isEnabled,
                labelText: labelText,
                emphasis: emphasis,
                color: iconColor,
                size: size,
                icon: icon,
              ),
              kFastHorizontalSizedBox12,
            ],
          );

          if (padding != null) {
            button = Padding(
              padding: padding!,
              child: button,
            );
          }
        }

        if (tooltip != null) {
          button = FastTooltip(
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
            highlightColor: getHighlightColor(
              context,
              highlightColor: highlightColor,
              color: iconColor,
              emphasis: emphasis,
              icon: icon,
            ),
            hoverColor: getHoverColor(
              context,
              hoverColor: hoverColor,
              color: iconColor,
              emphasis: emphasis,
              icon: icon,
            ),
            focusColor: focusColor,
            isEnabled: isEnabled,
            onTap: onTap,
            child: button,
          ),
        );
      },
    );
  }

  // Widget buildLabelText(BuildContext context) {
  //   return FastButtonLabel(
  //     text: labelText ?? CoreLocaleKeys.core_label_button.tr(),
  //     fontWeight: textStyle?.fontWeight,
  //     upperCase: upperCase,
  //     textColor: getColor(
  //       context,
  //       color: textStyle?.color ?? iconColor,
  //       disabledColor: disabledColor,
  //       isEnabled: isEnabled,
  //       emphasis: emphasis,
  //       icon: icon,
  //     ),
  //     fontSize: getFontSize(
  //       context,
  //       textStyle: textStyle,
  //       size: size,
  //     ),
  //   );
  // }
}
