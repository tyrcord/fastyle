// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:matex_financial/financial.dart';

/// Represents a widget for selecting financial frequencies.
class MatexFinancialFrequencySelectField extends StatelessWidget {
  final ValueChanged<FastItem<MatexFinancialFrequency>> onSelectionChanged;
  final MatexFinancialFrequency initialSelection;
  final String? searchTitleText;
  final String? labelText;
  final bool isEnabled;
  final List<MatexFinancialFrequency>? allowedFrequencies;

  const MatexFinancialFrequencySelectField({
    super.key,
    this.initialSelection = MatexFinancialFrequency.annually,
    required this.onSelectionChanged,
    this.isEnabled = true,
    this.searchTitleText,
    this.labelText,
    this.allowedFrequencies,
  });

  @override
  Widget build(BuildContext context) {
    return FastSelectField<MatexFinancialFrequency>(
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
  void _handleSelectionChange(FastItem<MatexFinancialFrequency>? item) {
    if (item != null) {
      onSelectionChanged(item);
    }
  }

  /// Creates a list of selectable financial frequency items.
  List<FastItem<MatexFinancialFrequency>> _getFrequencyItems() {
    final frequencies = allowedFrequencies ?? MatexFinancialFrequency.values;

    return frequencies.map((frequency) {
      return FastItem(
        labelText: getLocaleKeyForFinancialFrequency(frequency).tr(),
        value: frequency,
      );
    }).toList();
  }

  /// Creates a selected item based on the given frequency.
  FastItem<MatexFinancialFrequency>? _createSelectedItem(
    MatexFinancialFrequency frequency,
  ) {
    return FastItem(
      labelText: getLocaleKeyForFinancialFrequency(frequency).tr(),
      value: frequency,
    );
  }
}
