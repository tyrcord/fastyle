// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:rate_my_app/rate_my_app.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A service class for handling app rating functionality.
class FastAppRatingService {
  /// The singleton instance of [FastAppRatingService].
  static late FastAppRatingService instance;

  late RateMyApp _rateMyApp;

  static bool _hasBeenInitialized = false;

  /// Creates a singleton instance of [FastAppRatingService].
  factory FastAppRatingService(FastAppInfoDocument appInfo) {
    if (!_hasBeenInitialized) {
      instance = FastAppRatingService._(appInfo);
      _hasBeenInitialized = true;
    }

    return instance;
  }

  /// Private constructor for [FastAppRatingService].
  FastAppRatingService._(FastAppInfoDocument appInfo) {
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
      title: titleText ??
          SettingsLocaleKeys.settings_question_do_you_like_our_app.tr(),
      message: messageText ??
          SettingsLocaleKeys.settings_question_do_you_enjoy_our_app.tr(),
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
        text: validText ?? CoreLocaleKeys.core_label_ok.tr(),
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
    if (await shouldAskForAppReview()) {
      // ignore: use_build_context_synchronously
      return showAppRatingDialog(context);
    }
  }

  /// Checks if app review is needed.
  Future<bool> shouldAskForAppReview() async {
    await _rateMyApp.init();

    return _rateMyApp.shouldOpenDialog;
  }
}
