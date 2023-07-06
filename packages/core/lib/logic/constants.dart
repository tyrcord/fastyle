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
const kFastSettingStoreName = 'appSettings';
const kFastUserSettingStoreName = 'userSettings';

// Default User setting values.
const kFastUserSettingSaveEntry = true;
const kFastUserSettingPrimaryCurrencyCode = 'usd';
