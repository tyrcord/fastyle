// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:rate_my_app/rate_my_app.dart';

// Project imports:
import 'package:fastyle_core/logic/logic.dart';

/// A service class for handling app rating functionality.
class FusexAppRatingService {
  static FusexAppRatingService? _singleton;
  late RateMyApp _rateMyApp;

  /// Creates a singleton instance of [FusexAppRatingService].
  factory FusexAppRatingService(FastAppInfoDocument appInfo) {
    _singleton ??= FusexAppRatingService._(appInfo);

    return _singleton!;
  }

  /// Private constructor for [FusexAppRatingService].
  FusexAppRatingService._(FastAppInfoDocument appInfo) {
    _rateMyApp = RateMyApp(
      googlePlayIdentifier: appInfo.googlePlayIdentifier,
      remindLaunches: appInfo.remindForReviewMinLaunches,
      preferencesPrefix: '${appInfo.appIdentifier}_',
      appStoreIdentifier: appInfo.appStoreIdentifier,
      minLaunches: appInfo.askForReviewMinLaunches,
      remindDays: appInfo.remindForReviewMinDays,
      minDays: appInfo.askForReviewMinDays,
    );
  }

  /// Displays the app rating dialog.
  Future<void> showAppRatingDialog(
    BuildContext context, {
    String? titleText,
    String? messageText,
    String? validText,
  }) async {
    await _rateMyApp.init();

    // ignore: use_build_context_synchronously
    return _rateMyApp.showStarRateDialog(
      context,
      title: titleText ?? 'Do you like this app?',
      message: messageText ?? 'Please leave a rating!',
      ignoreNativeDialog: Platform.isAndroid,
      actionsBuilder: (context, stars) {
        return buildRatingDialogActions(context, validText: validText);
      },
      onDismissed: () {
        _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
      },
    );
  }

  List<Widget> buildRatingDialogActions(
    BuildContext context, {
    String? validText,
  }) {
    return [
      FastTextButton(
        text: validText ?? 'OK',
        onTap: () async {
          await _rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
          // ignore: use_build_context_synchronously
          Navigator.pop<RateMyAppDialogButton>(
            context,
            RateMyAppDialogButton.rate,
          );
        },
      ),
    ];
  }

  /// Checks if app review is needed and displays the app rating dialog if so.
  Future<void> askForAppReviewIfNeeded(BuildContext context) async {
    await _rateMyApp.init();

    if (_rateMyApp.shouldOpenDialog) {
      // ignore: use_build_context_synchronously
      return showAppRatingDialog(context);
    }
  }
}
