// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fastyle_onboarding/pages/pages.dart';

class FastOnboardingNotifications extends StatelessWidget {
  static FirebaseMessaging messagingService = FirebaseMessaging.instance;

  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The title text to display.
  final String? titleText;

  /// A list of widgets to display below the primary and secondary texts.
  final List<Widget>? children;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The callback to call when the action is tapped.
  final VoidCallback? onActionTap;

  /// The text to display as an action.
  final String? actionText;

  const FastOnboardingNotifications({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.onActionTap,
    this.actionText,
    this.titleText,
    this.controller,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return FastAppNotificationPermissionBuilder(
      builder: (context, state) {
        late Widget content;

        if (state.notificationPermission == FastAppPermission.granted) {
          content = FastOnboardingGrantedNotificationsContent(
            handsetIconSize: handsetIconSize,
            tabletIconSize: tabletIconSize,
            children: children,
          );
        } else if (state.notificationPermission == FastAppPermission.denied) {
          content = FastOnboardingDeniedNotificationsContent(
            handsetIconSize: handsetIconSize,
            tabletIconSize: tabletIconSize,
            children: children,
          );
        } else {
          content = FastOnboardingRequestNotificationsContent(
            handsetIconSize: handsetIconSize,
            tabletIconSize: tabletIconSize,
            onActionTap: onActionTap,
            controller: controller,
            actionText: actionText,
            children: children,
          );
        }

        return FastOnboardingPage(
          titleText: _getTitleText(),
          children: [content],
        );
      },
    );
  }

  String _getTitleText() {
    return titleText ??
        OnboardingLocaleKeys.onboarding_notifications_title.tr();
  }
}
