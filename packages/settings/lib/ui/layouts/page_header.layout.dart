import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

/// A layout that displays a description text and an optional icon.
/// It is used to display a header in a [FastSettingPage].
class FastSettingPageHeaderLayout extends StatelessWidget {
  /// The description text to display below the icon.
  final String? descriptionText;

  /// The height of the icon.
  final double iconHeight;

  /// The icon to display.
  final Widget? icon;

  const FastSettingPageHeaderLayout({
    super.key,
    required this.descriptionText,
    this.iconHeight = kFastSettingIconHeight,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double height = iconHeight;

    if (icon != null) {
      height += 32;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...(icon != null ? [icon!, kFastSizedBox32] : []),
          if (descriptionText != null)
            FastSecondaryBody(
              textAlign: TextAlign.center,
              text: descriptionText!,
            ),
        ],
      ),
    );
  }
}
