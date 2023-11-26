// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_finance_instrument/lingua_finance_instrument.dart';
import 'package:matex_financial/financial.dart';

// Project imports:
import 'package:fastyle_forms/fastyle_forms.dart';

class FastMatexSelectCurrencyField extends StatefulWidget {
  /// A callback function that takes a [MatexInstrumentMetadata] object and
  /// returns a string description for the item.
  final String Function(MatexInstrumentMetadata)? itemDescriptionBuilder;

  /// A callback function that will be called when the selection changes.
  /// It takes a [FastItem<String>] object representing the selected item.
  final Function(FastItem<MatexInstrumentMetadata>?)? onSelectionChanged;

  /// The width of the flag icon displayed in each item.
  final double? flagIconWidth;

  /// The title text displayed in the search field.
  final String? searchTitleText;

  /// The optional text displayed below the selection.
  final String? captionText;

  /// The initial selected item value.
  final String? selection;

  /// The label text displayed above the selection.
  final String? labelText;

  /// Specifies whether the field is enabled or disabled.
  final bool? isEnabled;

  /// The placeholder text displayed in the search field.
  final String? searchPlaceholderText;

  /// The placeholder text displayed in the selection field.
  final String? placeholderText;

  /// A callback function that builds the flag icon for each item.
  final Widget Function(String)? flagIconBuilder;

  /// Specifies whether the selection can be cleared.
  final bool? canClearSelection;

  const FastMatexSelectCurrencyField({
    super.key,
    this.onSelectionChanged,
    this.itemDescriptionBuilder,
    this.placeholderText,
    this.flagIconBuilder,
    this.captionText,
    this.selection,
    this.searchPlaceholderText,
    this.searchTitleText,
    this.isEnabled,
    this.flagIconWidth,
    this.labelText,
    this.canClearSelection,
  });

  @override
  State<FastMatexSelectCurrencyField> createState() =>
      _FastMatexSelectCurrencyFieldState();
}

class _FastMatexSelectCurrencyFieldState
    extends State<FastMatexSelectCurrencyField> {
  late MatexCurrencyBloc _currencyBloc;

  @override
  void initState() {
    super.initState();

    _currencyBloc = MatexCurrencyBloc();
    _loadFinancialInstruments();
  }

  @override
  Widget build(BuildContext context) {
    return FastMatexCurrencyBuilder(
      bloc: _currencyBloc,
      builder: (context, instrumentBlocState) {
        return FastSelectCurrencyField(
          onSelectionChanged: widget.onSelectionChanged,
          searchTitleText: widget.searchTitleText,
          captionText: widget.captionText,
          labelText: widget.labelText,
          isEnabled: widget.isEnabled,
          itemDescriptionBuilder:
              widget.itemDescriptionBuilder ?? itemDescriptionBuilder,
          currencies: instrumentBlocState.currencies,
          flagIconBuilder: widget.flagIconBuilder,
          flagIconWidth: widget.flagIconWidth,
          placeholderText: widget.placeholderText,
          searchPlaceholderText: widget.searchPlaceholderText,
          canClearSelection: widget.canClearSelection,
          selection: widget.selection,
        );
      },
    );
  }

  void _loadFinancialInstruments() {
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _currencyBloc.addEvent(const MatexCurrencyBlocEvent.init());
    });
  }

  String itemDescriptionBuilder(dynamic metadata) {
    if (metadata is MatexInstrumentMetadata && metadata.name != null) {
      final key = metadata.name!.key;

      return buildLocaleCurrencyKey(key).tr();
    }

    return '';
  }
}
