import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:matex_dart/matex_dart.dart';
import 'package:t_helpers/helpers.dart';

/// A Flutter widget for displaying a selectable list of currencies.
class FastSelectCurrencyField extends StatelessWidget {
  /// A callback function that takes a [MatexInstrumentMetadata] object and
  /// returns a string label for the item.
  final String Function(MatexInstrumentMetadata)? itemLabelBuilder;

  /// A callback function that will be called when the selection changes.
  /// It takes a [FastItem<String>] object representing the selected item.
  final Function(FastItem<String>?)? onSelectionChanged;

  /// A list of [MatexInstrumentMetadata] objects representing the financial
  /// instruments.
  final List<MatexInstrumentMetadata> currencies;

  /// The width of the flag icon displayed in each item.
  final double flagIconWidth;

  /// The title text displayed in the search field.
  final String searchTitleText;

  /// The optional text displayed below the selection.
  final String? captionText;

  /// The initial selected item value.
  final String? selection;

  /// The label text displayed above the selection.
  final String labelText;

  /// Specifies whether the field is enabled or disabled.
  final bool isEnabled;

  /// The placeholder text displayed in the search field.
  final String searchPlaceholderText;

  /// The placeholder text displayed in the selection field.
  final String? placeholderText;

  /// A callback function that builds the flag icon for each item.
  final Widget Function(MatexInstrumentMetadata)? flagIconBuilder;

  /// Creates a [FastSelectCurrencyField].
  const FastSelectCurrencyField({
    super.key,
    this.onSelectionChanged,
    this.itemLabelBuilder,
    this.placeholderText,
    this.flagIconBuilder,
    this.captionText,
    this.selection,
    List<MatexInstrumentMetadata>? currencies,
    String? searchPlaceholderText,
    String? searchTitleText,
    bool? isEnabled = true,
    double? flagIconWidth,
    String? labelText,
  })  : searchTitleText = searchTitleText ?? 'Search a Financial Instrument',
        labelText = labelText ?? 'Financial Instrument',
        searchPlaceholderText =
            searchPlaceholderText ?? kFastSearchPlaceholderText,
        flagIconWidth = flagIconWidth ?? 40.0,
        currencies = currencies ?? const [],
        isEnabled = isEnabled ?? true;

  @override
  Widget build(BuildContext context) {
    final options = _buildSelectOptions();

    return FastSelectField<String>(
      onSelectionChanged: (selection) => onSelectionChanged?.call(selection),
      searchPlaceholderText: searchPlaceholderText,
      selection: _findSelection(options),
      searchTitleText: searchTitleText,
      placeholderText: placeholderText,
      captionText: captionText,
      isReadOnly: !isEnabled,
      labelText: labelText,
      useFuzzySearch: true,
      items: options,
    );
  }

  /// Finds the selected item in the list of options.
  ///
  /// Returns the selected [FastItem<String>] object if found, or `null` if not
  /// found.
  FastItem<String>? _findSelection(List<FastItem<String>> options) {
    return options.firstWhereOrNull((item) => item.value == selection);
  }

  /// Builds the list of selectable options based on the provided [currencies].
  ///
  /// Returns a list of [FastItem<String>] objects representing the options.
  List<FastItem<String>> _buildSelectOptions() {
    return currencies
        .where((MatexInstrumentMetadata instrument) => instrument.code != null)
        .map(_buildItem)
        .toList();
  }

  /// Builds a single option item based on the provided [instrument].
  ///
  /// Returns a [FastItem<String>] object representing the option item.
  FastItem<String> _buildItem(MatexInstrumentMetadata instrument) {
    final iconKey = toCamelCase(instrument.icon);
    final hasIcon = kFastImageFlagMap.containsKey(iconKey);
    final code = instrument.code!;
    var description = code;
    Widget? flagIcon;

    if (flagIconBuilder != null) {
      flagIcon = flagIconBuilder!(instrument);
    } else {
      flagIcon = FastImageAsset(
        path: hasIcon ? kFastImageFlagMap[iconKey]! : kFastEmptyString,
        width: flagIconWidth,
      );
    }

    if (itemLabelBuilder != null) {
      description = itemLabelBuilder!(instrument);
    }

    return FastItem(
      descriptor: FastListItemDescriptor(leading: flagIcon),
      descriptionText: description,
      value: instrument.code,
      labelText: code,
    );
  }
}
