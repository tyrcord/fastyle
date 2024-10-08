// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:lingua_languages/languages.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

typedef LanguageFormatter = String Function(String languageCode);

/// The [FastSettingsLanguagePage] class is a [FastSettingPageLayout] that
/// displays the current language of the application.
/// It allows the user to change the language of the application.
class FastSettingsLanguagePage extends FastSettingPageLayout {
  /// The [FastListItemDescriptor] that will be used to build the list items.
  final FastListItemDescriptor? listItemDescriptor;

  /// The [LanguageFormatter] that will be used to format the language code.
  ///
  /// E.g.: (code) => code.toUpperCase()
  ///
  final LanguageFormatter? languageFormatter;

  /// The text that will be displayed above the list items.
  final String? subtitleText;

  const FastSettingsLanguagePage({
    super.key,
    super.contentPadding = EdgeInsets.zero,
    super.iconHeight,
    super.headerIcon,
    super.actions,
    this.languageFormatter,
    this.listItemDescriptor,
    String? headerDescriptionText,
    String? titleText,
    String? subtitleText,
  })  : subtitleText =
            subtitleText ?? SettingsLocaleKeys.settings_label_languages,
        super(
          headerDescriptionText: headerDescriptionText ??
              SettingsLocaleKeys.settings_select_language,
          titleText: titleText ?? SettingsLocaleKeys.settings_label_language,
        );

  @override
  Widget buildSettingsContent(BuildContext context) {
    final spacing = ThemeHelper.spacing.getSpacing(context);

    return Column(
      children: [
        if (subtitleText != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: FastListHeader(categoryText: subtitleText!.tr()),
          ),
        FastAppSettingsLanguagesBuilder(
          builder: (context, appInfoBlocState) {
            final items = buildLanguageItems(appInfoBlocState.supportedLocales);

            return FastAppSettingsLanguageBuilder(
              builder: (BuildContext context, FastAppSettingsBlocState state) {
                return FastSelectableListView<FastItem<String>>(
                  isViewScrollable: false,
                  sortItems: false,
                  items: items,
                  selection: _findSelection(state.languageCode, items),
                  onSelectionChanged: (FastItem<String> item) {
                    handleLanguageSelectionChanged(context, item.value!);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Builds the header icons that will be used to change the theme of the
  /// application.
  @override
  Widget buildSettingsHeaderIcon(BuildContext context) {
    return Center(child: buildIcon());
  }

  Widget buildIcon() {
    return FastImageAsset(
      path: FastImageLocalization.languages,
      height: iconHeight,
    );
  }

  List<FastItem<String>> buildLanguageItems(Iterable<Locale> locales) {
    return locales.map((Locale locale) {
      late final String languageName;

      if (languageFormatter != null) {
        languageName = languageFormatter!(locale.languageCode);
      } else {
        languageName = languageCodeToName(locale.languageCode);
      }

      return buildLanguageItem(languageName, locale.languageCode);
    }).toList();
  }

  /// Builds a [FastItem] that will be used to build a list item.
  FastItem<String> buildLanguageItem(String name, String languageCode) {
    Widget? flagIcon;

    if (kFastSettingsLanguageIcons.containsKey(languageCode)) {
      flagIcon = FastShadowLayout(
        child: FastImageAsset(
          path: kFastSettingsLanguageIcons[languageCode]!,
          width: 36,
        ),
      );
    }

    var descriptor = FastListItemDescriptor(leading: flagIcon);

    if (listItemDescriptor != null) {
      descriptor = descriptor.merge(listItemDescriptor!);
    }

    return FastItem(
      descriptor: descriptor,
      value: languageCode,
      labelText: name,
    );
  }

  /// Finds the [FastItem] that matches the [languageCode] parameter.
  FastItem<String>? _findSelection(
    String languageCode,
    List<FastItem<String>> items,
  ) {
    return items.firstWhereOrNull(
      (FastItem<String> item) => languageCode == item.value,
    );
  }

  /// Called when the user changes the language of the application.
  /// The [languageCode] parameter is the new language of the application.
  Future<void> handleLanguageSelectionChanged(
    BuildContext context,
    String languageCode,
  ) async {
    final settingsBloc = FastAppSettingsBloc.instance;

    settingsBloc.addEvent(
      FastAppSettingsBlocEvent.languageCodeChanged(languageCode),
    );

    await settingsBloc.onData
        .where((state) => state.languageCode == languageCode)
        .first;

    await context.setLocale(settingsBloc.currentState.languageLocale);
  }
}
