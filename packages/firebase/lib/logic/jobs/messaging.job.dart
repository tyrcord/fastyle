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
import 'package:tlogger/logger.dart';

/// A job that initializes the Firebase Messaging service.
class FastFirebaseMessagingJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastFirebaseMessagingJob';
  static final _manager = TLoggerManager();
  static FirebaseMessaging messagingService = FirebaseMessaging.instance;
  static FastFirebaseMessagingJob? _singleton;
  static FirebaseInAppMessaging inAppMessagingService =
      FirebaseInAppMessaging.instance;

  factory FastFirebaseMessagingJob() {
    return (_singleton ??= const FastFirebaseMessagingJob._());
  }

  const FastFirebaseMessagingJob._() : super(debugLabel: _debugLabel);

  /// Initializes the Firebase Messaging service.
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final permission = await _getNotificationStatus();
    _logger.info('Message notification permission', permission);

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
      _logger.error('Failed to initialize: $blocState');
      throw blocState;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugLog('Message received: ${message.data}', debugLabel: debugLabel);
      // TODO: handle message
    });

    _logger.debug('Initialized');
  }

  Future<FastAppPermission> _getNotificationStatus() async {
    final settings = await messagingService.getNotificationSettings();
    final status = settings.authorizationStatus;

    if (status == AuthorizationStatus.authorized) {
      return FastAppPermission.granted;
    } else if (status == AuthorizationStatus.denied) {
      if (isAndroid) {
        final appInfoBloc = FastAppInfoBloc.instance;
        final isFirstLaunch = appInfoBloc.currentState.isFirstLaunch;

        if (isFirstLaunch) {
          return FastAppPermission.unknown;
        }
      }

      return FastAppPermission.denied;
    }

    return FastAppPermission.unknown;
  }
}
