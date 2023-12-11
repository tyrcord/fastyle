// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:matex_financial/financial.dart';
import 'package:tbloc/tbloc.dart';

class FastFinancialSelectLeverageField extends StatefulWidget {
  final ValueChanged<FastItem<double>?> onSelectionChanged;
  final List<double>? leverages;
  final bool canClearSelection;
  final double? selection;
  final bool isEnabled;

  const FastFinancialSelectLeverageField({
    super.key,
    required this.onSelectionChanged,
    this.canClearSelection = true,
    this.isEnabled = true,
    this.leverages,
    this.selection,
  });

  @override
  FastFinancialSelectLeverageFieldState createState() =>
      FastFinancialSelectLeverageFieldState();
}

class FastFinancialSelectLeverageFieldState
    extends State<FastFinancialSelectLeverageField> {
  List<double> get leverages => widget.leverages ?? kMatexLeverages;
  List<FastItem<double>> _items = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: FastAppSettingsBloc.instance,
      buildWhen: (previous, current) {
        return previous.languageCode != current.languageCode;
      },
      builder: (context, state) {
        _items = _buildItems(state.languageCode);

        return FastSelectField<double>(
          searchTitleText: FinanceLocaleKeys.finance_select_leverage.tr(),
          labelText: FinanceLocaleKeys.finance_label_leverage.tr(),
          selection: _findLeverageSelection(widget.selection),
          onSelectionChanged: widget.onSelectionChanged,
          canClearSelection: widget.canClearSelection,
          isReadOnly: !widget.isEnabled,
          sortItems: false,
          items: _items,
        );
      },
    );
  }

  FastItem<double>? _findLeverageSelection(double? leverage) {
    if (leverage != null) {
      return _items.firstWhereOrNull((item) => item.value == leverage);
    }

    return null;
  }

  List<FastItem<double>> _buildItems(String languageCode) {
    return leverages.map((leverage) {
      return FastItem(
        labelText: formatLeverage(leverage, locale: languageCode),
        value: leverage,
      );
    }).toList();
  }
}
