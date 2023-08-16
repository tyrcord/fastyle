// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

typedef ThemeModeFormatter = String Function(ThemeMode mode);

/// The [FastSettingsThemePage] class is a [FastSettingPageLayout] that
/// displays the current theme of the application.
/// It allows the user to change the theme of the application.
/// The theme can be changed to light, dark or system.
class FastSettingsThemePage extends FastSettingPageLayout {
  /// The [FastListItemDescriptor] that will be used to build the list items.
  final FastListItemDescriptor? listItemDescriptor;

  /// The [ThemeModeFormatter] that will be used to format the theme mode.
  ///
  /// E.g.: (mode) => mode.toString().capitalize()
  ///
  final ThemeModeFormatter? themeModeFormatter;

  /// The path of the light icon.
  final String lightIconPath;

  /// The path of the dark icon.
  final String darkIconPath;

  /// The text that will be displayed above the list items.
  final String? subtitleText;

  const FastSettingsThemePage({
    super.key,
    super.contentPadding,
    super.iconHeight,
    super.headerIcon,
    super.actions,
    this.lightIconPath = FastImageMobile.light,
    this.darkIconPath = FastImageMobile.dark,
    this.themeModeFormatter,
    this.listItemDescriptor,
    String? headerDescriptionText,
    String? titleText,
    String? subtitleText,
  })  : subtitleText =
            subtitleText ?? SettingsLocaleKeys.settings_label_appearance,
        super(
          headerDescriptionText: headerDescriptionText ??
              SettingsLocaleKeys.settings_note_appearance,
          titleText: titleText ?? SettingsLocaleKeys.settings_label_appearance,
        );

  @override
  Widget buildSettingsContent(BuildContext context) {
    final items = buildThemeItems(context);

    return Column(
      children: [
        if (subtitleText != null)
          FastListHeader(categoryText: subtitleText!.tr()),
        FastAppSettingsThemeBuilder(
          builder: (BuildContext context, FastAppSettingsBlocState state) {
            return FastSelectableListView<FastItem<ThemeMode>>(
              isViewScrollable: false,
              sortItems: false,
              items: items,
              selection: _findSelection(state.themeMode, items),
              onSelectionChanged: (FastItem<ThemeMode> item) {
                handleThemeSelectionChanged(context, item.value!);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildIcon(context, ThemeMode.light),
        buildIcon(context, ThemeMode.dark),
      ],
    );
  }

  /// Builds the icon that will be used to change the theme of the application.
  /// The icon will be either the light or dark icon depending on the
  /// [themeMode] parameter.
  Widget buildIcon(BuildContext context, ThemeMode themeMode) {
    final icon = themeMode == ThemeMode.light ? lightIconPath : darkIconPath;

    return GestureDetector(
      onTap: () => handleThemeSelectionChanged(context, themeMode),
      child: FastShadowLayout(
        child: FastImageAsset(
          height: iconHeight,
          path: icon,
        ),
      ),
    );
  }

  /// Builds the list of [FastItem] that will be used to build the list items.
  /// The list items are used to change the theme of the application.
  List<FastItem<ThemeMode>> buildThemeItems(BuildContext context) {
    final formatThemeMode = themeModeFormatter ?? _formatThemeMode;
    final systemLabel = formatThemeMode(ThemeMode.system);
    final lightLabel = formatThemeMode(ThemeMode.light);
    final darkLabel = formatThemeMode(ThemeMode.dark);

    return [
      buildThemeItem(
        systemLabel,
        ThemeMode.system,
        buildLeadingIcon(_getSystemIcon(context)),
      ),
      buildThemeItem(
        lightLabel,
        ThemeMode.light,
        buildLeadingIcon(_getLightIcon(context)),
      ),
      buildThemeItem(
        darkLabel,
        ThemeMode.dark,
        buildLeadingIcon(_getDarkIcon(context)),
      ),
    ];
  }

  /// Builds a [FastItem] that will be used to build a list item.
  FastItem<ThemeMode> buildThemeItem(
    String name,
    ThemeMode themeMode,
    Widget icon,
  ) {
    final descriptor = listItemDescriptor ?? const FastListItemDescriptor();

    return FastItem(
      descriptor: descriptor.copyWith(leading: icon),
      value: themeMode,
      labelText: name,
    );
  }

  /// Finds the [FastItem] that matches the [themeMode] parameter.
  FastItem<ThemeMode>? _findSelection(
    ThemeMode themeMode,
    List<FastItem<ThemeMode>> items,
  ) {
    return items.firstWhereOrNull(
      (FastItem<ThemeMode> item) => themeMode == item.value,
    );
  }

  /// Called when the user changes the theme of the application.
  /// The [themeMode] parameter is the new theme of the application.
  void handleThemeSelectionChanged(BuildContext context, ThemeMode themeMode) {
    final settingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    final theme = themeMode.name;

    settingsBloc.addEvent(FastAppSettingsBlocEvent.themeChanged(theme));
  }

  String _formatThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return SettingsLocaleKeys.settings_label_system.tr();
      case ThemeMode.light:
        return SettingsLocaleKeys.settings_label_light.tr();
      case ThemeMode.dark:
        return SettingsLocaleKeys.settings_label_dark.tr();
    }
  }

  Widget buildLeadingIcon(IconData icon) {
    return Icon(icon, size: kFastIconSizeSmall);
  }

  IconData _getDarkIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return FastFontAwesomeIcons.lightMoon;
    }

    return FontAwesomeIcons.moon;
  }

  IconData _getLightIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return FastFontAwesomeIcons.lightSunBright;
    }

    return FontAwesomeIcons.sun;
  }

  IconData _getSystemIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return FastFontAwesomeIcons.lightGear;
    }

    return FontAwesomeIcons.gear;
  }
}
