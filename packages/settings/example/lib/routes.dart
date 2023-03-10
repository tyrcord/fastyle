import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final kAppRoutes = [
  GoRoute(
    path: 'all',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: const FastBody(
        text: 'TODO',
      ),
    ),
  ),
  GoRoute(
    path: 'languages',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: const FastBody(
        text: 'TODO',
      ),
    ),
  ),
  GoRoute(
    path: 'appearance',
    builder: (context, state) => FastThemeSettingPage(
      subtitleText: SettingsLocaleKeys.settings_labels_appearance.tr(),
      themeModeFormatter: (mode) {
        switch (mode) {
          case ThemeMode.system:
            return SettingsLocaleKeys.settings_labels_system.tr();
          case ThemeMode.light:
            return SettingsLocaleKeys.settings_labels_light.tr();
          case ThemeMode.dark:
            return SettingsLocaleKeys.settings_labels_dark.tr();
        }
      },
    ),
  ),
];
