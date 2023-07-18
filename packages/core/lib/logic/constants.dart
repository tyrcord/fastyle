// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

const kFastAppInfo = FastAppInfoDocument(
  facebookUrl: 'https://www.facebook.com/tyrcord',
  promoUrl: 'https://tyrcord.com/apps',
  homepageUrl: 'https://tyrcord.com',
  supportEmail: 'contact@tyrcord.com',
  bugReportEmail: 'dev@tyrcord.com',
  appAuthor: 'Tyrcord, Inc',
  appVersion: '0.0.1',
  appName: 'FastApp',
  databaseVersion: 0,
);

const kFastSettingThemeModeMap = {
  'system': ThemeMode.system,
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
};

const kFastSettingsThemeMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

/// Default store key names.
const kFastAppSettingStoreName = 'fastAppSettings';
const kFastAppInfoStoreName = 'fastAppInfo';
const kFastAppFeaturesStoreName = 'fastAppFeatures';
const kFastAppDictStoreName = 'fastAppDict';

// Default App setting values.
final kFastSettingsDefaultTheme = kFastSettingsThemeMap[ThemeMode.system]!;
const kFastAppSettingsPrimaryCurrencyCode = 'usd';
const kFastSettingsDefaultLanguageCode = 'en';
const kFastAppSettingsSaveEntry = true;

/// Default app constant values.

/// The default locale for the Fast App Settings.
const kFastAppSettingsDefaultLocale = Locale(kFastSettingsDefaultLanguageCode);

/// The list of supported locales for the Fast App Settings.
const kFastAppSettingsSupportedLocales = [kFastAppSettingsDefaultLocale];

/// The minimum number of app launches before reminding the user for a review.
const kFastAppSettingsRemindForReviewMinLaunches = 10;

/// The minimum number of app launches before asking the user for a review.
const kFastAppSettingsAskForReviewMinLaunches = 10;

/// The minimum number of days before reminding the user for a review.
const kFastAppSettingsRemindForReviewMinDays = 7;

/// The timeout duration for asynchronous operations in Fast App.
const kFastAsyncTimeout = Duration(seconds: 15);

/// The minimum number of days before asking the user for a review.
const kFastAppSettingsAskForReviewMinDays = 7;

/// Indicates whether Fast App has a disclaimer.
const kFastAppSettingsHasDisclaimer = false;

/// The list of default routes for Fast App.
const kFastDefaultRoutes = <GoRoute>[];

/// The path to the localization files for Fast App.
const kFastLocalizationPath = 'i18n/';

/// The duration to delay before showing the loader in Fast App.
const kFastDelayBeforeShowingLoader = Duration(seconds: 1);
