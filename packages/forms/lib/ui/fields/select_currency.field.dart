// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:matex_dart/matex_dart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_finance_instrument/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// A Flutter widget for displaying a selectable list of currencies.
class FastSelectCurrencyField extends StatelessWidget {
  /// A callback function that takes a [MatexInstrumentMetadata] object and
  /// returns a string description for the item.
  final String Function(MatexInstrumentMetadata)? itemDescriptionBuilder;

  final String Function(MatexInstrumentMetadata)? itemLabelBuilder;

  /// A callback function that will be called when the selection changes.
  /// It takes a [FastItem<String>] object representing the selected item.
  final Function(FastItem<MatexInstrumentMetadata>?)? onSelectionChanged;

  /// A list of [MatexInstrumentMetadata] objects representing the financial
  /// instruments.
  final List<MatexInstrumentMetadata> currencies;

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
  final Widget Function(MatexInstrumentMetadata)? flagIconBuilder;

  /// Specifies whether the selection can be cleared.
  final bool canClearSelection;

  /// Creates a [FastSelectCurrencyField].
  const FastSelectCurrencyField({
    super.key,
    this.onSelectionChanged,
    this.itemDescriptionBuilder,
    this.itemLabelBuilder,
    this.placeholderText,
    this.flagIconBuilder,
    this.captionText,
    this.selection,
    List<MatexInstrumentMetadata>? currencies,
    this.searchPlaceholderText,
    this.searchTitleText,
    bool? isEnabled = true,
    double? flagIconWidth,
    this.labelText,
    bool? canClearSelection,
  })  : canClearSelection = canClearSelection ?? true,
        flagIconWidth = flagIconWidth ?? 40.0,
        currencies = currencies ?? const [],
        isEnabled = isEnabled ?? true;

  @override
  Widget build(BuildContext context) {
    final options = _buildSelectOptions();
    final selectedOption = _findSelection(options);

    return FastSelectField<MatexInstrumentMetadata>(
      onSelectionChanged: (selection) => onSelectionChanged?.call(selection),
      searchPlaceholderText: searchPlaceholderText,
      canClearSelection: canClearSelection,
      placeholderText: placeholderText,
      searchTitleText: searchTitleText ??
          FinanceInstrumentLocaleKeys.instrument_message_search_instrument.tr(),
      selection: selectedOption,
      captionText: captionText,
      isReadOnly: !isEnabled,
      labelText: labelText ??
          FinanceLocaleKeys.finance_label_financial_instrument.tr(),
      useFuzzySearch: true,
      items: options,
      leading: selectedOption != null
          ? _buildFlagIcon(selectedOption.value!, hasShadow: false)
          : null,
    );
  }

  FastItem<MatexInstrumentMetadata>? _findSelection(
    List<FastItem<MatexInstrumentMetadata>> options,
  ) {
    if (selection == null) {
      return null;
    }

    final currency = selection!.toLowerCase();

    return options.where((element) {
      return element.value != null && element.value!.code != null;
    }).firstWhereOrNull((item) => item.value!.code!.toLowerCase() == currency);
  }

  List<FastItem<MatexInstrumentMetadata>> _buildSelectOptions() {
    return currencies
        .where((MatexInstrumentMetadata instrument) => instrument.code != null)
        .map(_buildItem)
        .toList();
  }

  FastItem<MatexInstrumentMetadata> _buildItem(
    MatexInstrumentMetadata instrument,
  ) {
    final flagIcon = _buildFlagIcon(instrument);
    String code = instrument.code!;
    var description = code;

    if (itemLabelBuilder != null) {
      code = itemLabelBuilder!(instrument);
    }

    if (itemDescriptionBuilder != null) {
      description = itemDescriptionBuilder!(instrument);
    }

    return FastItem(
      descriptor: FastListItemDescriptor(leading: flagIcon),
      descriptionText: description,
      value: instrument,
      labelText: code,
    );
  }

  Widget? _buildFlagIcon(
    MatexInstrumentMetadata instrument, {
    bool hasShadow = true,
  }) {
    final iconKey = toCamelCase(instrument.icon);
    final hasIcon = kFastImageFlagMap.containsKey(iconKey);
    Widget? flagIcon;

    if (flagIconBuilder != null) {
      flagIcon = flagIconBuilder!(instrument);
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
