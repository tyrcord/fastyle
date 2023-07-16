import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_languages/languages.dart';
import 'package:lingua_finance_instrument/lingua_finance_instrument.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:matex_dart/matex_dart.dart';

final kAppRoutes = [
  GoRoute(
    path: 'all',
    builder: (context, state) => const FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastBody(
        text: 'TODO',
      ),
    ),
  ),
  GoRoute(
    path: 'languages',
    builder: (context, state) => FastSettingsLanguagePage(
      subtitleText: SettingsLocaleKeys.settings_label_languages.tr(),
      titleText: SettingsLocaleKeys.settings_label_languages.tr(),
      headerDescriptionText: SettingsLocaleKeys.settings_select_language.tr(),
      languageFormatter: languageCodeToName,
    ),
  ),
  GoRoute(
    path: 'appearance',
    builder: (context, state) => FastThemeSettingPage(
      titleText: SettingsLocaleKeys.settings_label_appearance.tr(),
      subtitleText: SettingsLocaleKeys.settings_label_appearance.tr(),
      headerDescriptionText: SettingsLocaleKeys.settings_note_appearance.tr(),
      themeModeFormatter: (mode) {
        switch (mode) {
          case ThemeMode.system:
            return SettingsLocaleKeys.settings_label_system.tr();
          case ThemeMode.light:
            return SettingsLocaleKeys.settings_label_light.tr();
          case ThemeMode.dark:
            return SettingsLocaleKeys.settings_label_dark.tr();
        }
      },
    ),
  ),
  GoRoute(
      path: 'user-settings',
      builder: (context, state) {
        return FastAppSettingsPage(
          titleText: SettingsLocaleKeys.settings_label_user_settings.tr(),
          headerDescriptionText: SettingsLocaleKeys.settings_note_settings.tr(),
          descriptor: FastSettingsDescriptor(
            categories: {
              FastAppSettingsCategories.inputs:
                  FastAppSettingsInputsCategoryDescriptor(
                titleText: SettingsLocaleKeys.settings_label_user_inputs.tr(),
                fields: {
                  FastAppSettingsFields.saveEntry: FastFormFieldDescriptor(
                    labelText: CoreLocaleKeys.core_label_auto_save.tr(),
                  ),
                },
              ),
              FastAppSettingsCategories.defaultValues:
                  FastAppSettingsDefaultValuesCategoryDescriptor(
                titleText: SettingsLocaleKeys.settings_label_default.tr(),
                fields: {
                  FastAppSettingsFields.primaryCurrency:
                      FastFormFieldDescriptor(
                    labelText:
                        FinanceLocaleKeys.finance_select_primary_currency.tr(),
                    searchTitleText:
                        FinanceLocaleKeys.finance_label_primary_currency.tr(),
                    searchPlaceholderText:
                        CoreLocaleKeys.core_message_search.tr(),
                    itemDescriptionBuilder: (dynamic metadata) {
                      if (metadata is MatexInstrumentMetadata &&
                          metadata.name != null) {
                        final key = metadata.name!.key;

                        return buildLocaleCurrencyKey(key).tr();
                      }

                      return '';
                    },
                  ),
                },
              ),
            },
          ),
        );
      }),
];
