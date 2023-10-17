// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_layouts/fastyle_layouts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

class FastOnboardingRequestNotificationsContent extends StatelessWidget {
  static FirebaseMessaging messagingService = FirebaseMessaging.instance;

  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  final List<Widget>? children;

  final String? introText;

  final String? descriptionText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  final String? actionText;

  /// The callback to call when the action is tapped.
  final VoidCallback? onActionTap;
  final String? notesText;

  const FastOnboardingRequestNotificationsContent({
    super.key,
    this.handsetIconSize,
    this.tabletIconSize,
    this.descriptionText,
    this.introText,
    this.controller,
    this.children,
    this.palette,
    this.onActionTap,
    this.actionText,
    this.icon,
    this.notesText,
  });

  Future<void> handleAction() async {
    controller?.pause();
    final notificationSettings = await messagingService.requestPermission(
      announcement: false,
      criticalAlert: false,
      provisional: false,
      carPlay: false,
      alert: true,
      badge: true,
      sound: true,
    );

    final status = notificationSettings.authorizationStatus;
    final permission = getNotificationPermission(status);
    final event = FastAppPermissionsBlocEvent.updateNotificationPermission(
      permission,
    );

    FastAppPermissionsBloc.instance.addEvent(event);

    onActionTap?.call();

    WidgetsBinding.instance.scheduleFrameCallback((_) => controller?.resume());
  }

  @override
  Widget build(BuildContext context) {
    return FastOnboardingContentLayout(
      handsetIconSize: handsetIconSize,
      tabletIconSize: tabletIconSize,
      descriptionText: _getDescriptionText(),
      introText: _getIntroText(),
      palette: _getPalette(context),
      actionText: _getActionText(),
      notesText: _getNotesText(),
      onActionTap: handleAction,
      icon: buildIcon(context),
      children: children,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightBells);
    }

    return const FaIcon(FontAwesomeIcons.bell);
  }

  String _getActionText() {
    return actionText ??
        OnboardingLocaleKeys.onboarding_notifications_action.tr();
  }

  String _getIntroText() {
    return introText ??
        OnboardingLocaleKeys.onboarding_notifications_intro.tr();
  }

  String _getDescriptionText() {
    return descriptionText ??
        OnboardingLocaleKeys.onboarding_notifications_description.tr();
  }

  String _getNotesText() {
    return notesText ??
        OnboardingLocaleKeys.onboarding_notifications_notes.tr();
  }

  FastPaletteScheme _getPalette(BuildContext context) {
    if (palette == null) {
      return ThemeHelper.getPaletteColors(context).pink;
    }

    return palette!;
  }

  FastAppPermission getNotificationPermission(AuthorizationStatus status) {
    if (status == AuthorizationStatus.authorized) {
      return FastAppPermission.granted;
    } else if (status == AuthorizationStatus.denied) {
      return FastAppPermission.denied;
    }

    return FastAppPermission.unknown;
  }
}
