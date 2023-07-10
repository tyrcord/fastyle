import 'package:flutter/material.dart';

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

final kFastSettingsDefaultTheme = kFastSettingsThemeMap[ThemeMode.system]!;

/// Default store key names.
const kFastAppSettingStoreName = 'fastAppSettings';
const kFastAppInfoStoreName = 'fastAppInfo';
const kFastAppFeaturesStoreName = 'fastAppFeatures';

// Default App setting values.
const kFastSettingsDefaultLanguageCode = 'en';
const kFastAppSettingsDefaultLocale = Locale(kFastSettingsDefaultLanguageCode);
const kFastAppSettingsSupportedLocales = [kFastAppSettingsDefaultLocale];
const kFastAppSettingsPrimaryCurrencyCode = 'usd';
const kFastAppSettingsSaveEntry = true;

const kFastAppSettingsRemindForReviewMinLaunches = 10;
const kFastAppSettingsAskForReviewMinLaunches = 10;
const kFastAppSettingsRemindForReviewMinDays = 7;
const kFastAppSettingsAskForReviewMinDays = 7;
const kFastAppSettingsHasDisclaimer = false;
const kFastAppSettingsAppLaunchCounter = false;
