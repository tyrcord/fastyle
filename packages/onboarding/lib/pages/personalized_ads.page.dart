import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_onboarding/fastyle_onboarding.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

/// A page that displays a layout with an icon, a primary text, a secondary text
/// and a list of children widgets.
class FastOnboardingPersonalizedAds extends StatelessWidget {
  /// The title text to display.
  final String? titleText;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  /// A list of widgets to display below the primary and secondary texts.
  final List<Widget>? children;

  /// The text to display below the icon.
  final String? primaryText;

  /// The text to display below the primary text.
  final String? secondaryText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The callback to call when the action is tapped.
  final VoidCallback? onActionTap;

  /// The text to display as an action.
  final String? actionText;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  const FastOnboardingPersonalizedAds({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.secondaryText,
    this.primaryText,
    this.onActionTap,
    this.actionText,
    this.titleText,
    this.children,
    this.palette,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastOnboardingPage(
      titleText: titleText ?? 'Personalized Ads',
      children: [
        FastOnboardingContentLayout(
          icon: icon ?? const FaIcon(FontAwesomeIcons.bullhorn),
          actionText: actionText ?? 'Turn On Personalized Ads',
          primaryText: primaryText ??
              'By allowing us to personalize your ads, you\'ll receive a more personalized experience with advertisements that are tailored to your interests.',
          secondaryText: secondaryText ??
              'Your privacy is important to us and we promise to only use your information to enhance your experience and show you ads that matter to you.',
          handsetIconSize: handsetIconSize,
          tabletIconSize: tabletIconSize,
          onActionTap: () async {
            await AppTrackingTransparency.requestTrackingAuthorization();
          },
          palette: palette,
          children: children,
        ),
      ],
    );
  }
}
