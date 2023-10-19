// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_number/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_forms/fastyle_forms.dart';

/// A widget that allows the user to switch between an amount field and a
/// percent field.
class FastAmountSwitchField extends StatelessWidget {
  /// A callback that is called when the user changes the field type.
  final Function(FastAmountSwitchFieldType) onFieldTypeChanged;

  /// A callback that is called when the user changes the percent value.
  final Function(String) onPercentValueChanged;

  /// A callback that is called when the user changes the amount value.
  final Function(String) onAmountValueChanged;

  /// The current field type.
  final FastAmountSwitchFieldType fieldType;

  /// The label text for the amount field.
  final String? amountLabelText;

  /// The label text for the percent field.
  final String? percentLabelText;

  /// The current percent value.
  final String percentValue;

  /// The current amount value.
  final String amountValue;

  /// Whether the field is enabled or not.
  final bool isEnabled;

  /// The caption text for the percent field.
  final String? percentCaptionText;

  /// The caption text for the amount field.
  final String? amountCaptionText;

  /// The default field type.
  static const kDefaultFieldType = FastAmountSwitchFieldType.amount;

  /// The default caption text for the percent field.
  static const kDefaultPercentCaptionText = '%';

  /// The default caption text for the amount field.
  static const kDefaultAmountCaptionText = '\$';

  /// The default placeholder text for the percent field.
  static const kDefaultPercentPlaceholderText = '0';

  /// The default placeholder text for the amount field.
  static const kDefaultAmountPlaceholderText = '0';

  /// The placeholder text for the percent field.
  final String percentPlaceholderText;

  /// The placeholder text for the amount field.
  final String amountPlaceholderText;

  final String? amountMenuText;

  final String? percentMenuText;

  const FastAmountSwitchField({
    super.key,
    required this.onAmountValueChanged,
    required this.onPercentValueChanged,
    required this.onFieldTypeChanged,
    this.percentCaptionText,
    this.amountCaptionText,
    FastAmountSwitchFieldType? fieldType,
    String? percentPlaceholderText,
    String? amountPlaceholderText,
    this.percentLabelText,
    this.amountLabelText,
    this.amountMenuText,
    this.percentMenuText,
    String? percentValue,
    String? amountValue,
    bool? isEnabled,
  })  : fieldType = fieldType ?? kDefaultFieldType,
        percentValue = percentValue ?? '',
        amountValue = amountValue ?? '',
        isEnabled = isEnabled ?? true,
        percentPlaceholderText =
            percentPlaceholderText ?? kDefaultPercentPlaceholderText,
        amountPlaceholderText =
            amountPlaceholderText ?? kDefaultAmountPlaceholderText;

  @override
  Widget build(BuildContext context) {
    if (fieldType == FastAmountSwitchFieldType.percent) {
      return FastNumberField(
        captionText: percentCaptionText ?? kDefaultPercentCaptionText,
        suffixIcon: _buildSwitchFieldMenuButton(),
        placeholderText: percentPlaceholderText,
        onValueChanged: onPercentValueChanged,
        labelText: _getPercentLabel(),
        valueText: percentValue,
        isEnabled: isEnabled,
      );
    } else {
      return FastNumberField(
        captionText: amountCaptionText ?? kDefaultAmountCaptionText,
        suffixIcon: _buildSwitchFieldMenuButton(),
        placeholderText: amountPlaceholderText,
        onValueChanged: onAmountValueChanged,
        labelText: _getAmountLabel(),
        valueText: amountValue,
        isEnabled: isEnabled,
      );
    }
  }

  /// Builds the switch field menu button.
  Widget _buildSwitchFieldMenuButton() {
    return FastSwitchFieldMenuButton(
      onOptionChanged: _onInputTypeOptionChanged,
      options: [
        PopupMenuItem(
          value: FastAmountSwitchFieldType.amount,
          child: FastSecondaryBody(text: _getAmountMenuLabel()),
        ),
        PopupMenuItem(
          value: FastAmountSwitchFieldType.percent,
          child: FastSecondaryBody(text: _getPercentMenuLabel()),
        ),
      ],
    );
  }

  /// Called when the user changes the field type.
  void _onInputTypeOptionChanged(FastAmountSwitchFieldType option) {
    if (option != fieldType) {
      onFieldTypeChanged(option);
    }
  }

  String _getPercentLabel() {
    return percentLabelText ?? NumberLocaleKeys.number_label_percentage.tr();
  }

  String _getAmountLabel() {
    return amountLabelText ?? NumberLocaleKeys.number_label_amount.tr();
  }

  String _getAmountMenuLabel() {
    return amountMenuText ?? NumberLocaleKeys.number_label_amount.tr();
  }

  String _getPercentMenuLabel() {
    return percentMenuText ?? NumberLocaleKeys.number_label_percentage.tr();
  }
}
