// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_finance_instrument/lingua_finance_instrument.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
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
    builder: (context, state) => const FastSettingsLanguagePage(),
  ),
  GoRoute(
    path: 'appearance',
    builder: (context, state) => const FastSettingsThemePage(),
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
                FastAppSettingsFields.primaryCurrency: FastFormFieldDescriptor(
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
    },
  ),
  GoRoute(
    path: 'disclaimer',
    builder: (context, state) => const FastSettingsDisclaimerPage(),
  ),
  GoRoute(
    path: 'tos',
    builder: (context, state) => const FastSettingsTermsOfServicePage(),
  ),
  GoRoute(
    path: 'privacy-policy',
    builder: (context, state) => const FastSettingsPrivacyPolicyPage(),
  ),
];
