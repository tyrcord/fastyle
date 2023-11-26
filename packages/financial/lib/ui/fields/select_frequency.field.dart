// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_financial/fastyle_financial.dart';

/// Represents a widget for selecting financial frequencies.
class FastFinancialFrequencySelectField extends StatelessWidget {
  final ValueChanged<FastItem<FastFinancialFrequency>> onSelectionChanged;
  final FastFinancialFrequency initialSelection;
  final String? searchTitleText;
  final String? labelText;
  final bool isEnabled;
  final List<FastFinancialFrequency>? allowedFrequencies;

  const FastFinancialFrequencySelectField({
    super.key,
    this.initialSelection = FastFinancialFrequency.annually,
    required this.onSelectionChanged,
    this.isEnabled = true,
    this.searchTitleText,
    this.labelText,
    this.allowedFrequencies,
  });

  @override
  Widget build(BuildContext context) {
    return FastSelectField<FastFinancialFrequency>(
      selection: _createSelectedItem(initialSelection),
      onSelectionChanged: _handleSelectionChange,
      searchTitleText: _getSearchTitleText(),
      items: _getFrequencyItems(),
      labelText: _getLabelText(),
      canClearSelection: false,
      isReadOnly: !isEnabled,
      useFuzzySearch: true,
      sortItems: false,
    );
  }

  String _getSearchTitleText() {
    return searchTitleText ?? CoreLocaleKeys.core_select_frequency.tr();
  }

  String _getLabelText() {
    return labelText ?? CoreLocaleKeys.core_label_frequency.tr();
  }

  /// Handles the selection change of frequency.
  void _handleSelectionChange(FastItem<FastFinancialFrequency>? item) {
    if (item != null) {
      onSelectionChanged(item);
    }
  }

  /// Creates a list of selectable financial frequency items.
  List<FastItem<FastFinancialFrequency>> _getFrequencyItems() {
    final frequencies = allowedFrequencies ?? FastFinancialFrequency.values;

    return frequencies.map((frequency) {
      return FastItem(
        labelText: getLocaleKeyForFinancialFrequency(frequency).tr(),
        value: frequency,
      );
    }).toList();
  }

  /// Creates a selected item based on the given frequency.
  FastItem<FastFinancialFrequency>? _createSelectedItem(
    FastFinancialFrequency frequency,
  ) {
    return FastItem(
      labelText: getLocaleKeyForFinancialFrequency(frequency).tr(),
      value: frequency,
    );
  }
}
