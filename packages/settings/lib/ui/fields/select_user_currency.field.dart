import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:matex_financial/financial.dart';
import 'package:fastyle_forms/fastyle_forms.dart';

/// A widget that displays a select currency field for the user's primary
/// currency.
class FastUserSettingsPrimaryCurrencyField extends StatelessWidget {
  /// A callback that is called when the user selects a new currency.
  final void Function(String)? onCurrencyChanged;

  /// The descriptor for the field.
  final FastFormFieldDescriptor? descriptor;

  /// The text to display in the search field.
  final String? searchTitleText;

  /// The text to display in the label.
  final String? labelText;

  /// The padding to apply to the widget.
  final EdgeInsetsGeometry padding;

  /// The text to display as a placeholder in the search field.
  final String? searchPlaceholderText;

  /// The text to display as a placeholder in the selection field.
  final String? placeholderText;

  const FastUserSettingsPrimaryCurrencyField({
    super.key,
    this.onCurrencyChanged,
    this.descriptor,
    this.padding = kFastHorizontalEdgeInsets16,
    this.searchPlaceholderText,
    this.placeholderText,
    String? searchTitleText,
    String? labelText,
  })  : searchTitleText = searchTitleText ?? 'Primary currency',
        labelText = labelText ?? 'Select a currency';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FastUserSettingsPrimaryCurrencyBuilder(builder: (_, state) {
        return MatexSelectCurrencyField(
          searchTitleText: descriptor?.searchTitleText ?? searchTitleText,
          labelText: descriptor?.labelText ?? labelText,
          selection: state.primaryCurrencyCode,
          canClearSelection: false,
          onSelectionChanged: (FastItem<String>? item) {
            if (item != null &&
                item.value != null &&
                item.value != state.primaryCurrencyCode) {
              onCurrencyChanged?.call(item.value!);
            }
          },
          searchPlaceholderText:
              descriptor?.searchPlaceholderText ?? searchPlaceholderText,
          placeholderText: descriptor?.placeholderText ?? placeholderText,
        );
      }),
    );
  }
}
