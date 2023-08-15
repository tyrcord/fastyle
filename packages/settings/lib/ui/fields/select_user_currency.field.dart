// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:matex_financial/financial.dart';
import 'package:matex_dart/matex_dart.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// A widget that displays a select currency field for the user's primary
/// currency.
class FastAppSettingsPrimaryCurrencyField extends StatelessWidget {
  /// A callback that is called when the user selects a new currency.
  final void Function(String)? onCurrencyChanged;

  /// The descriptor for the field.
  final FastFormFieldDescriptor? descriptor;

  /// The text to display in the search field.
  final String? searchTitleText;

  /// The text to display in the label.
  final String? labelText;

  /// The text to display as a placeholder in the search field.
  final String? searchPlaceholderText;

  /// The text to display as a placeholder in the selection field.
  final String? placeholderText;

  const FastAppSettingsPrimaryCurrencyField({
    super.key,
    this.onCurrencyChanged,
    this.descriptor,
    this.searchPlaceholderText,
    this.placeholderText,
    this.searchTitleText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return FastAppSettingsPrimaryCurrencyBuilder(
      builder: (_, state) {
        return MatexSelectCurrencyField(
          searchTitleText:
              (descriptor?.searchTitleText ?? _getSearchTitleText()).tr(),
          labelText: (descriptor?.labelText ?? _getLabelText()).tr(),
          selection: state.primaryCurrencyCode,
          itemDescriptionBuilder: descriptor?.itemDescriptionBuilder,
          canClearSelection: false,
          onSelectionChanged: (FastItem<MatexInstrumentMetadata>? item) {
            if (item != null &&
                item.value != null &&
                item.value!.code != null &&
                item.value!.code != state.primaryCurrencyCode) {
              onCurrencyChanged?.call(item.value!.code!);
            }
          },
          searchPlaceholderText:
              descriptor?.searchPlaceholderText ?? searchPlaceholderText,
          placeholderText: descriptor?.placeholderText ?? placeholderText,
        );
      },
    );
  }

  String _getLabelText() {
    return searchTitleText ?? FinanceLocaleKeys.finance_label_primary_currency;
  }

  String _getSearchTitleText() {
    return searchTitleText ?? FinanceLocaleKeys.finance_select_primary_currency;
  }
}
