// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      : super(debugLabel: 'fast_firebase_messaging_job');

  /// Initializes the Firebase Messaging service.
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Message data: ${message.data}');
    });
  }
}
