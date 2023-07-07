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
const kFastSettingStoreName = 'fastAppSettings';

// Default App setting values.
const kFastSettingsDefaultLanguageCode = 'en';
const kFastAppSettingsDefaultLocale = Locale(kFastSettingsDefaultLanguageCode);
const kFastAppSettingsSupportedLocales = [kFastAppSettingsDefaultLocale];
const kFastAppSettingsPrimaryCurrencyCode = 'usd';
const kFastAppSettingsSaveEntry = true;
