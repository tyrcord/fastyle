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
  /// The default field type.
  static const kDefaultFieldType = FastAmountSwitchFieldType.amount;

  /// The default caption text for the percent field.
  static const kDefaultPercentCaptionText = '%';

  /// The default caption text for the amount field.
  static const kDefaultAmountCaptionText = '\$';

  static const kDefaultPlaceholderText = '0';

  static const kDefaultMenuOptions = [
    FastAmountSwitchMenuOption.amount,
    FastAmountSwitchMenuOption.percent,
  ];

  /// A callback that is called when the user changes the field type.
  final Function(FastAmountSwitchFieldType) onFieldTypeChanged;

  /// A callback that is called when the user changes the percent value.
  final Function(String)? onPercentValueChanged;

  /// A callback that is called when the user changes the amount value.
  final Function(String)? onAmountValueChanged;

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

  /// The placeholder text for the percent field.
  final String percentPlaceholderText;

  /// The placeholder text for the amount field.
  final String amountPlaceholderText;

  final String? amountMenuText;

  final String? percentMenuText;

  final List<FastAmountSwitchMenuOption> availableMenuOptions;

  const FastAmountSwitchField({
    super.key,
    required this.onFieldTypeChanged,
    // Value callbacks
    this.onAmountValueChanged,
    this.onPercentValueChanged,
    // Caption texts
    this.percentCaptionText,
    this.amountCaptionText,
    // Label texts
    this.percentLabelText,
    this.amountLabelText,
    // Menu texts
    this.amountMenuText,
    this.percentMenuText,
    // Placeholder texts
    String? percentPlaceholderText,
    String? amountPlaceholderText,
    // Values
    String? percentValue,
    String? amountValue,
    // Field type and menu options
    FastAmountSwitchFieldType? fieldType,
    List<FastAmountSwitchMenuOption>? availableMenuOptions =
        kDefaultMenuOptions,
    bool? isEnabled,
  })  : availableMenuOptions = availableMenuOptions ?? kDefaultMenuOptions,
        fieldType = fieldType ?? kDefaultFieldType,
        percentValue = percentValue ?? '',
        amountValue = amountValue ?? '',
        isEnabled = isEnabled ?? true,
        percentPlaceholderText =
            percentPlaceholderText ?? kDefaultPlaceholderText,
        amountPlaceholderText =
            amountPlaceholderText ?? kDefaultPlaceholderText;

  @override
  Widget build(BuildContext context) {
    switch (fieldType) {
      case FastAmountSwitchFieldType.percent:
        return buildPercentField();
      default:
        return buildAmountField();
    }
  }

  @protected
  Widget buildPercentField() {
    return FastNumberField(
      captionText: percentCaptionText ?? kDefaultPercentCaptionText,
      suffixIcon: buildSwitchFieldMenuButton(),
      placeholderText: percentPlaceholderText,
      onValueChanged: onPercentValueChanged,
      labelText: _getPercentLabel(),
      valueText: percentValue,
      isEnabled: isEnabled,
    );
  }

  @protected
  Widget buildAmountField() {
    return FastNumberField(
      captionText: amountCaptionText ?? kDefaultAmountCaptionText,
      suffixIcon: buildSwitchFieldMenuButton(),
      placeholderText: amountPlaceholderText,
      onValueChanged: onAmountValueChanged,
      labelText: _getAmountLabel(),
      valueText: amountValue,
      isEnabled: isEnabled,
    );
  }

  @protected
  Widget buildSwitchFieldMenuButton() {
    return FastSwitchFieldMenuButton(
      onOptionChanged: onInputTypeOptionChanged,
      options: buildSwitchFieldMenuOptions(),
    );
  }

  @protected
  List<PopupMenuItem<FastAmountSwitchFieldType>> buildSwitchFieldMenuOptions() {
    final options = <PopupMenuItem<FastAmountSwitchFieldType>>[];

    if (availableMenuOptions.contains(FastAmountSwitchMenuOption.amount)) {
      options.add(PopupMenuItem(
        value: FastAmountSwitchFieldType.amount,
        child: FastSecondaryBody(text: _getAmountMenuLabel()),
      ));
    }

    if (availableMenuOptions.contains(FastAmountSwitchMenuOption.percent)) {
      options.add(PopupMenuItem(
        value: FastAmountSwitchFieldType.percent,
        child: FastSecondaryBody(text: _getPercentMenuLabel()),
      ));
    }

    return options;
  }

  /// Called when the user changes the field type.
  @protected
  void onInputTypeOptionChanged(FastAmountSwitchFieldType option) {
    if (option != fieldType) onFieldTypeChanged(option);
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
