// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:matex_data/matex_data.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// A widget that displays a select country field for the user's primary
/// country.
class FastAppSettingsUserCountrySelectField extends StatelessWidget {
  /// A callback that is called when the user selects a new country.
  final void Function(String?)? onCountryChanged;

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

  final bool canClearSelection;

  const FastAppSettingsUserCountrySelectField({
    super.key,
    this.onCountryChanged,
    this.descriptor,
    this.searchPlaceholderText,
    this.placeholderText,
    this.searchTitleText,
    this.labelText,
    this.canClearSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    return FastAppSettingsUserCountryBuilder(
      builder: (_, state) {
        return FastMatexSelectCountryField(
          placeholderText: descriptor?.placeholderText ?? placeholderText,
          itemDescriptionBuilder: descriptor?.itemDescriptionBuilder,
          searchPlaceholderText: _getSearchPlaceholderText(),
          searchTitleText: _getSearchTitleText(),
          selection: state.countryCode,
          labelText: _getLabelText(),
          canClearSelection: canClearSelection,
          onSelectionChanged: (FastItem<MatexCountryMetadata>? item) {
            if (item != null &&
                item.value != null &&
                item.value!.code != state.countryCode) {
              onCountryChanged?.call(item.value!.code);
            } else {
              onCountryChanged?.call(null);
            }
          },
        );
      },
    );
  }

  String _getLabelText() {
    return (descriptor?.labelText ??
            labelText ??
            CoreLocaleKeys.core_label_country)
        .tr();
  }

  String _getSearchTitleText() {
    return (descriptor?.searchTitleText ??
            searchTitleText ??
            CoreLocaleKeys.core_select_country)
        .tr();
  }

  String? _getSearchPlaceholderText() {
    return descriptor?.searchPlaceholderText ?? searchPlaceholderText;
  }
}
