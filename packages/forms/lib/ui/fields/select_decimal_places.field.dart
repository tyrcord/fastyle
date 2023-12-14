// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_number/number.dart';

class FastSelectDecimalPlacesField extends StatelessWidget {
  static const defaultDecimales = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final ValueChanged<FastItem<int>?> onSelectionChanged;
  final int? selection;
  final bool isEnabled;
  final String? labelText;
  final String? titleText;
  final List<int> decimales;
  final bool showHelperBoundaries;

  const FastSelectDecimalPlacesField({
    super.key,
    required this.onSelectionChanged,
    this.labelText,
    this.titleText,
    this.selection,
    bool? isEnabled = true,
    List<int>? decimales = defaultDecimales,
    this.showHelperBoundaries = true,
  })  : isEnabled = isEnabled ?? true,
        decimales = decimales ?? defaultDecimales;

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

    return FastSelectField<int>(
      selection: _findSelection(items, selection),
      showHelperBoundaries: showHelperBoundaries,
      onSelectionChanged: onSelectionChanged,
      searchTitleText: titleText,
      canClearSelection: false,
      labelText: labelText,
      isEnabled: isEnabled,
      sortItems: false,
      items: items,
    );
  }

  List<FastItem<int>> _buildItems() {
    return decimales.map((int place) {
      return FastItem(
        labelText: toOrdinal(place, gender: 'female'),
        value: place,
      );
    }).toList();
  }

  FastItem<int>? _findSelection(List<FastItem<int>> items, int? place) {
    if (place != null) {
      return items.firstWhereOrNull((item) => item.value == place);
    }

    return null;
  }
}
