// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

/// A job that initializes the Firebase Messaging service.
class FastFirebaseMessagingJob extends FastJob {
  static FirebaseMessaging messagingService = FirebaseMessaging.instance;
  static FastFirebaseMessagingJob? _singleton;
  static FirebaseInAppMessaging inAppMessagingService =
      FirebaseInAppMessaging.instance;

  factory FastFirebaseMessagingJob() {
    _singleton ??= const FastFirebaseMessagingJob._();

    return _singleton!;
  }

  const FastFirebaseMessagingJob._()
      : super(debugLabel: 'FastFirebaseMessagingJob');

  /// Initializes the Firebase Messaging service.
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugLog('Message data: ${message.data}', debugLabel: debugLabel);
    });

    final permission = await _getNotificationStatus();
    debugLog('Notification permission: $permission', debugLabel: debugLabel);

    final bloc = FastAppPermissionsBloc.instance;
    final event = FastAppPermissionsBlocEvent.updateNotificationPermission(
      permission,
    );

    bloc.addEvent(event);

    final blocState = await RaceStream([
      bloc.onData.where((state) => state.notificationPermission == permission),
      bloc.onError,
    ]).first;

    if (blocState is! FastAppPermissionsBlocState) {
      throw blocState;
    }
  }

  Future<FastAppPermission> _getNotificationStatus() async {
    final settings = await messagingService.getNotificationSettings();
    final status = settings.authorizationStatus;

    if (status == AuthorizationStatus.authorized) {
      return FastAppPermission.granted;
    } else if (status == AuthorizationStatus.denied) {
      return FastAppPermission.denied;
    }

    return FastAppPermission.unknown;
  }
}
