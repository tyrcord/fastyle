// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

typedef ThemeModeFormatter = String Function(ThemeMode mode);

/// The [FastThemeSettingPage] class is a [FastSettingPageLayout] that
/// displays the current theme of the application.
/// It allows the user to change the theme of the application.
/// The theme can be changed to light, dark or system.
class FastThemeSettingPage extends FastSettingPageLayout {
  /// The [FastListItemDescriptor] that will be used to build the list items.
  final FastListItemDescriptor? listItemDescriptor;

  /// The [ThemeModeFormatter] that will be used to format the theme mode.
  ///
  /// E.g.: (mode) => mode.toString().capitalize()
  ///
  /// If the [themeModeFormatter] parameter is not null, the [systemText],
  /// [lightText] and [darkText] parameters will be ignored.
  ///
  /// If the [themeModeFormatter] parameter is null, the [systemText],
  /// [lightText] and [darkText] parameters will be used to build the list
  /// items.
  final ThemeModeFormatter? themeModeFormatter;

  /// The path of the light icon.
  final String lightIconPath;

  /// The path of the dark icon.
  final String darkIconPath;

  /// The package of the light and dark icons.
  final String assetPackage;

  /// The text that will be displayed above the list items.
  final String? subtitleText;

  /// The text that will be displayed for the system theme.
  final String systemText;

  /// The text that will be displayed for the light theme.
  final String lightText;

  /// The text that will be displayed for the dark theme.
  final String darkText;

  const FastThemeSettingPage({
    super.key,
    super.headerDescriptionText,
    super.contentPadding,
    super.iconHeight,
    super.headerIcon,
    super.titleText,
    super.actions,
    this.assetPackage = kFastImagesPackageName,
    this.lightIconPath = FastImageMobile.light,
    this.darkIconPath = FastImageMobile.dark,
    this.themeModeFormatter,
    this.listItemDescriptor,
    this.subtitleText,
    String? systemText,
    String? lightText,
    String? darkText,
  })  : systemText = systemText ?? kFastSettingsSystemThemeText,
        lightText = lightText ?? kFastSettingsLightThemeText,
        darkText = darkText ?? kFastSettingsDarkThemeText;

  @override
  Widget buildSettingsContent(BuildContext context) {
    final items = buildThemeItems();

    return Column(
      children: [
        if (subtitleText != null) FastListHeader(categoryText: subtitleText!),
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
      child: Image.asset(
        icon,
        package: assetPackage,
        height: iconHeight,
      ),
    );
  }

  /// Builds the list of [FastItem] that will be used to build the list items.
  /// The list items are used to change the theme of the application.
  ///
  /// If the [themeModeFormatter] parameter is not null, the [systemText],
  /// [lightText] and [darkText] parameters will be ignored.
  ///
  /// If the [themeModeFormatter] parameter is null, the [systemText],
  /// [lightText] and [darkText] parameters will be used to build the list
  /// items.
  List<FastItem<ThemeMode>> buildThemeItems() {
    late final String systemLabel;
    late final String lightLabel;
    late final String darkLabel;

    if (themeModeFormatter != null) {
      systemLabel = themeModeFormatter!(ThemeMode.system);
      lightLabel = themeModeFormatter!(ThemeMode.light);
      darkLabel = themeModeFormatter!(ThemeMode.dark);
    } else {
      systemLabel = systemText;
      lightLabel = lightText;
      darkLabel = darkText;
    }

    return [
      buildThemeItem(systemLabel, ThemeMode.system),
      buildThemeItem(lightLabel, ThemeMode.light),
      buildThemeItem(darkLabel, ThemeMode.dark),
    ];
  }

  /// Builds a [FastItem] that will be used to build a list item.
  FastItem<ThemeMode> buildThemeItem(String name, ThemeMode themeMode) {
    return FastItem(
      descriptor: listItemDescriptor,
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
}
