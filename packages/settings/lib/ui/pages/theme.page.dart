import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:flutter/material.dart';

/// The [FastThemeSettingPage] class is a [FastSettingPageLayout] that
/// displays the current theme of the application.
/// It allows the user to change the theme of the application.
/// The theme can be changed to light, dark or system.
class FastThemeSettingPage extends FastSettingPageLayout {
  /// The [FastListItemDescriptor] that will be used to build the list items.
  final FastListItemDescriptor? listItemDescriptor;

  /// The path of the light icon.
  final String lightIconPath;

  /// The path of the dark icon.
  final String darkIconPath;

  /// The package of the light and dark icons.
  final String assetPackage;

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
    this.listItemDescriptor,
  });

  /// TODO: localize
  @override
  Widget buildSettingsContent(BuildContext context) {
    final items = buildThemeItems();

    return Column(
      children: [
        FastListHeader(
          categoryText: 'Appearance',
          // categoryText: LocaleKeys.settings_themes_words_appearance.tr(),
        ),
        FastSettingsThemeBuilder(
          builder: (BuildContext context, FastSettingsBlocState state) {
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
  /// TODO: localize
  List<FastItem<ThemeMode>> buildThemeItems() {
    return [
      buildThemeItem('System Default', ThemeMode.system),
      buildThemeItem('Light', ThemeMode.light),
      buildThemeItem('Dark', ThemeMode.dark),
    ];
  }

  /// Builds a [FastItem] that will be used to build a list item.
  /// TODO: localize
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
    final settingsBloc = BlocProvider.of<FastSettingsBloc>(context);
    final theme = themeMode.name;

    settingsBloc.addEvent(FastSettingsBlocEvent.themeChanged(theme));
  }
}
