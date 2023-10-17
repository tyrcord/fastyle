// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:matex_data/matex_data.dart';

// Project imports:
import 'package:fastyle_forms/fastyle_forms.dart';

class FastMatexSelectCountryField extends StatefulWidget {
  /// A callback function that takes a [MatexCountryMetadata] object and
  /// returns a string description for the item.
  final String Function(MatexCountryMetadata)? itemDescriptionBuilder;

  /// A callback function that will be called when the selection changes.
  final Function(FastItem<MatexCountryMetadata>?)? onSelectionChanged;

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
  final Widget Function(MatexCountryMetadata)? flagIconBuilder;

  /// Specifies whether the selection can be cleared.
  final bool? canClearSelection;

  const FastMatexSelectCountryField({
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
  State<FastMatexSelectCountryField> createState() =>
      _FastMatexSelectCountryFieldState();
}

class _FastMatexSelectCountryFieldState
    extends State<FastMatexSelectCountryField> {
  late MatexCountryBloc _countryBloc;

  @override
  void initState() {
    super.initState();

    _countryBloc = MatexCountryBloc();
    _loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return FastMatexCountryBuilder(
      bloc: _countryBloc,
      builder: (context, countryBlocState) {
        return FastSelectCountryField(
          onSelectionChanged: widget.onSelectionChanged,
          searchTitleText: widget.searchTitleText,
          captionText: widget.captionText,
          labelText: widget.labelText,
          isEnabled: widget.isEnabled,
          itemDescriptionBuilder: widget.itemDescriptionBuilder,
          countries: countryBlocState.countries,
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

  void _loadCountries() {
    if (!_countryBloc.currentState.isInitialized) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        _countryBloc.addEvent(MatexCountryBlocEvent.init());
      });
    }
  }
}
