// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_countries/countries.dart';
import 'package:t_helpers/helpers.dart';
import 'package:matex_data/matex_data.dart';
import 'package:easy_localization/easy_localization.dart';

/// A Flutter widget for displaying a selectable list of countries.
class FastSelectCountryField extends StatelessWidget {
  /// A callback function that takes a [MatexCountryMetadata] object and
  /// returns a string description for the item.
  final String Function(MatexCountryMetadata)? itemDescriptionBuilder;

  final String Function(MatexCountryMetadata)? itemLabelBuilder;

  /// A callback function that will be called when the selection changes.
  /// It takes a [FastItem<String>] object representing the selected item.
  final Function(FastItem<MatexCountryMetadata>?)? onSelectionChanged;

  /// A list of [MatexCountryMetadata] objects representing the countries.
  final List<MatexCountryMetadata> countries;

  /// The width of the flag icon displayed in each item.
  final double flagIconWidth;

  /// The title text displayed in the search field.
  final String? searchTitleText;

  /// The optional text displayed below the selection.
  final String? captionText;

  /// The initial selected item value.
  final String? selection;

  /// The label text displayed above the selection.
  final String? labelText;

  /// Specifies whether the field is enabled or disabled.
  final bool isEnabled;

  /// The placeholder text displayed in the search field.
  final String? searchPlaceholderText;

  /// The placeholder text displayed in the selection field.
  final String? placeholderText;

  /// A callback function that builds the flag icon for each item.
  final Widget Function(MatexCountryMetadata)? flagIconBuilder;

  /// Specifies whether the selection can be cleared.
  final bool canClearSelection;

  /// Creates a [FastSelectCountryField].
  const FastSelectCountryField({
    super.key,
    this.onSelectionChanged,
    this.itemDescriptionBuilder,
    this.itemLabelBuilder,
    this.placeholderText,
    this.flagIconBuilder,
    this.captionText,
    this.selection,
    List<MatexCountryMetadata>? countries,
    this.searchPlaceholderText,
    this.searchTitleText,
    bool? isEnabled = true,
    double? flagIconWidth,
    this.labelText,
    bool? canClearSelection,
  })  : canClearSelection = canClearSelection ?? true,
        flagIconWidth = flagIconWidth ?? 40.0,
        countries = countries ?? const [],
        isEnabled = isEnabled ?? true;

  @override
  Widget build(BuildContext context) {
    final options = _buildSelectOptions();
    final selectedOption = _findSelection(options);

    return FastSelectField<MatexCountryMetadata>(
      onSelectionChanged: (selection) => onSelectionChanged?.call(selection),
      labelText: labelText ?? CoreLocaleKeys.core_label_country.tr(),
      searchPlaceholderText: searchPlaceholderText,
      canClearSelection: canClearSelection,
      placeholderText: placeholderText,
      searchTitleText:
          searchTitleText ?? CoreLocaleKeys.core_select_country.tr(),
      selection: selectedOption,
      captionText: captionText,
      isReadOnly: !isEnabled,
      useFuzzySearch: true,
      items: options,
      leading: selectedOption != null
          ? _buildFlagIcon(selectedOption.value!, hasShadow: false)
          : null,
    );
  }

  FastItem<MatexCountryMetadata>? _findSelection(
    List<FastItem<MatexCountryMetadata>> options,
  ) {
    if (selection == null) {
      return null;
    }

    final country = selection!.toLowerCase();

    if (country.length < 4) {
      // Search by country code
      return options.where((element) => element.value != null).firstWhereOrNull(
          (item) => item.value!.code.toLowerCase() == country);
    }

    // Search by country id
    return options
        .where((element) => element.value != null)
        .firstWhereOrNull((item) => item.value!.id.toLowerCase() == country);
  }

  List<FastItem<MatexCountryMetadata>> _buildSelectOptions() {
    return countries.map(_buildItem).toList();
  }

  FastItem<MatexCountryMetadata> _buildItem(
    MatexCountryMetadata country,
  ) {
    final flagIcon = _buildFlagIcon(country);
    String? description;
    late String id;

    if (itemLabelBuilder != null) {
      id = itemLabelBuilder!(country);
    } else {
      id = _itemLabelBuilder(country);
    }

    if (itemDescriptionBuilder != null) {
      description = itemDescriptionBuilder!(country);
    }

    return FastItem(
      descriptor: FastListItemDescriptor(leading: flagIcon),
      descriptionText: description,
      value: country,
      labelText: id,
    );
  }

  String _itemLabelBuilder(MatexCountryMetadata metadata) {
    return buildLocaleCountryKey(metadata.id).tr();
  }

  Widget? _buildFlagIcon(
    MatexCountryMetadata country, {
    bool hasShadow = true,
  }) {
    final iconKey = toCamelCase(country.id);
    final hasIcon = kFastImageFlagMap.containsKey(iconKey);
    Widget? flagIcon;

    if (flagIconBuilder != null) {
      flagIcon = flagIconBuilder!(country);
    } else {
      flagIcon = FastImageAsset(
        path: hasIcon ? kFastImageFlagMap[iconKey]! : kFastEmptyString,
        width: flagIconWidth,
      );
    }

    if (hasShadow) {
      return FastShadowLayout(child: flagIcon);
    }

    return flagIcon;
  }
}
