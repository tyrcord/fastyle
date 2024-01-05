// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:matex_financial/financial.dart';

class FastFinancialSelectAmounTypeField extends StatefulWidget {
  final ValueChanged<FastItem<FastFinancialAmountSwitchFieldType>?>
      onSelectionChanged;
  final List<FastFinancialAmountSwitchFieldType>? allowedTypes;

  final FastFinancialAmountSwitchFieldType? selection;
  final bool canClearSelection;
  final bool isEnabled;
  final String? labelText;
  final String? searchTitleText;

  const FastFinancialSelectAmounTypeField({
    super.key,
    required this.onSelectionChanged,
    this.canClearSelection = false,
    this.isEnabled = true,
    this.selection,
    this.labelText,
    this.allowedTypes,
    this.searchTitleText,
  });

  @override
  FastFinancialSelectAmounTypeFieldState createState() =>
      FastFinancialSelectAmounTypeFieldState();
}

class FastFinancialSelectAmounTypeFieldState
    extends State<FastFinancialSelectAmounTypeField> {
  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

    return FastSelectField<FastFinancialAmountSwitchFieldType>(
      labelText:
          widget.labelText ?? FinanceLocaleKeys.finance_label_amount_type.tr(),
      selection: _findSelection(items, widget.selection),
      onSelectionChanged: widget.onSelectionChanged,
      canClearSelection: widget.canClearSelection,
      searchTitleText: widget.searchTitleText,
      isReadOnly: !widget.isEnabled,
      sortItems: false,
      items: items,
    );
  }

  List<FastItem<FastFinancialAmountSwitchFieldType>> _buildItems() {
    return FastFinancialAmountSwitchFieldType.values
        .where((method) =>
            widget.allowedTypes == null ||
            widget.allowedTypes!.contains(method))
        .map((method) {
      return FastItem<FastFinancialAmountSwitchFieldType>(
        labelText: method.localizedName,
        value: method,
      );
    }).toList();
  }

  FastItem<FastFinancialAmountSwitchFieldType>? _findSelection(
    List<FastItem<FastFinancialAmountSwitchFieldType>> items,
    FastFinancialAmountSwitchFieldType? type,
  ) {
    if (type != null) {
      return items.firstWhereOrNull((item) => item.value == type);
    }

    return null;
  }
}
