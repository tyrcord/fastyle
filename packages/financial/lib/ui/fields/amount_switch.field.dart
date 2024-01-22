// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_finance_forex/generated/locale_keys.g.dart';
import 'package:lingua_number/generated/locale_keys.g.dart';
import 'package:matex_financial/financial.dart';

// Project imports:
import 'package:fastyle_financial/fastyle_financial.dart';

/// A widget that allows the user to switch between an amount field and a
/// percent field.
class FastFiancialAmountSwitchField extends StatelessWidget {
  /// The default field type.
  static const kDefaultFieldType = FastFinancialAmountSwitchFieldType.amount;

  /// The default caption text for the percent field.
  static const kDefaultPercentCaptionText = '%';

  /// The default caption text for the amount field.
  static const kDefaultAmountCaptionText = '\$';

  static const kDefaultPlaceholderText = '0';

  static const kDefaultMenuOptions = [
    FastFinancialAmountSwitchMenuOption.amount,
    FastFinancialAmountSwitchMenuOption.percent,
  ];

  /// A callback that is called when the user changes the field type.
  final Function(FastFinancialAmountSwitchFieldType) onFieldTypeChanged;

  /// A callback that is called when the user changes the percent value.
  final Function(String)? onPercentValueChanged;

  /// A callback that is called when the user changes the amount value.
  final Function(String)? onAmountValueChanged;

  final Function(String)? onPipValueChanged;

  final Function(String)? onPriceValueChanged;

  /// The current field type.
  final FastFinancialAmountSwitchFieldType fieldType;

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

  final List<FastFinancialAmountSwitchMenuOption> availableMenuOptions;

  final String? pipValue;

  final String? priceValue;

  final String? pipLabelText;

  final String? priceLabelText;

  final String? pipCaptionText;

  final String? priceCaptionText;

  final String? pipPlaceholderText;

  final String? pricePlaceholderText;

  final String? pipMenuText;

  final String? priceMenuText;

  final bool transformInvalidNumber;

  const FastFiancialAmountSwitchField({
    super.key,
    required this.onFieldTypeChanged,
    // Value callbacks
    this.onAmountValueChanged,
    this.onPercentValueChanged,
    this.onPipValueChanged,
    this.onPriceValueChanged,
    // Caption texts
    this.percentCaptionText,
    this.amountCaptionText,
    this.pipCaptionText,
    this.priceCaptionText,
    // Label texts
    this.percentLabelText,
    this.amountLabelText,
    this.pipLabelText,
    this.priceLabelText,
    // Menu texts
    this.amountMenuText,
    this.percentMenuText,
    this.pipMenuText,
    this.priceMenuText,
    FastFinancialAmountSwitchFieldType? fieldType,
    List<FastFinancialAmountSwitchMenuOption>? availableMenuOptions =
        kDefaultMenuOptions,
    String? percentPlaceholderText,
    String? amountPlaceholderText,
    String? pipPlaceholderText,
    String? pricePlaceholderText,
    String? percentValue,
    String? amountValue,
    String? pipValue,
    String? priceValue,
    bool? isEnabled,
    bool? transformInvalidNumber = true,
  })  : availableMenuOptions = availableMenuOptions ?? kDefaultMenuOptions,
        fieldType = fieldType ?? kDefaultFieldType,
        percentValue = percentValue ?? '',
        amountValue = amountValue ?? '',
        pipValue = pipValue ?? '',
        priceValue = priceValue ?? '',
        isEnabled = isEnabled ?? true,
        percentPlaceholderText =
            percentPlaceholderText ?? kDefaultPlaceholderText,
        pricePlaceholderText = pricePlaceholderText ?? kDefaultPlaceholderText,
        pipPlaceholderText = pipPlaceholderText ?? kDefaultPlaceholderText,
        amountPlaceholderText =
            amountPlaceholderText ?? kDefaultPlaceholderText,
        transformInvalidNumber = transformInvalidNumber ?? true;

  @override
  Widget build(BuildContext context) {
    switch (fieldType) {
      case FastFinancialAmountSwitchFieldType.percent:
        return buildPercentField();
      case FastFinancialAmountSwitchFieldType.pip:
        return buildPipField();
      case FastFinancialAmountSwitchFieldType.price:
        return buildPriceField();
      default:
        return buildAmountField();
    }
  }

  @protected
  Widget buildPipField() {
    return FastNumberField(
      transformInvalidNumber: transformInvalidNumber,
      suffixIcon: buildSwitchFieldMenuButton(),
      captionText: pipCaptionText ?? 'Pips',
      placeholderText: pipPlaceholderText,
      onValueChanged: onPipValueChanged,
      labelText: _getPipLabelText(),
      valueText: pipValue,
      isEnabled: isEnabled,
    );
  }

  Widget buildPriceField() {
    return FastNumberField(
      captionText: priceCaptionText ?? kDefaultAmountCaptionText,
      transformInvalidNumber: transformInvalidNumber,
      suffixIcon: buildSwitchFieldMenuButton(),
      placeholderText: pricePlaceholderText,
      onValueChanged: onPriceValueChanged,
      labelText: _getPriceLabelText(),
      valueText: priceValue,
      isEnabled: isEnabled,
    );
  }

  @protected
  Widget buildPercentField() {
    return FastNumberField(
      captionText: percentCaptionText ?? kDefaultPercentCaptionText,
      transformInvalidNumber: transformInvalidNumber,
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
      transformInvalidNumber: transformInvalidNumber,
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
  List<PopupMenuItem<FastFinancialAmountSwitchFieldType>>
      buildSwitchFieldMenuOptions() {
    final options = <PopupMenuItem<FastFinancialAmountSwitchFieldType>>[];

    // Dynamically add menu items based on available options
    if (availableMenuOptions
        .contains(FastFinancialAmountSwitchMenuOption.amount)) {
      options.add(PopupMenuItem(
        value: FastFinancialAmountSwitchFieldType.amount,
        child: FastSecondaryBody(text: _getAmountMenuLabel()),
      ));
    }

    if (availableMenuOptions
        .contains(FastFinancialAmountSwitchMenuOption.percent)) {
      options.add(PopupMenuItem(
        value: FastFinancialAmountSwitchFieldType.percent,
        child: FastSecondaryBody(text: _getPercentMenuLabel()),
      ));
    }

    if (availableMenuOptions
        .contains(FastFinancialAmountSwitchMenuOption.pip)) {
      options.add(PopupMenuItem(
        value: FastFinancialAmountSwitchFieldType.pip,
        child: FastSecondaryBody(text: _getPipMenuLabel()),
      ));
    }

    if (availableMenuOptions
        .contains(FastFinancialAmountSwitchMenuOption.price)) {
      options.add(PopupMenuItem(
        value: FastFinancialAmountSwitchFieldType.price,
        child: FastSecondaryBody(text: _getPriceMenuLabel()),
      ));
    }

    return options;
  }

  /// Called when the user changes the field type.
  @protected
  void onInputTypeOptionChanged(FastFinancialAmountSwitchFieldType option) {
    if (option != fieldType) onFieldTypeChanged(option);
  }

  String _getPercentLabel() {
    return percentLabelText ?? NumberLocaleKeys.number_label_percentage.tr();
  }

  String _getAmountLabel() {
    return amountLabelText ?? NumberLocaleKeys.number_label_amount.tr();
  }

  String _getPipLabelText() {
    return pipLabelText ?? FinanceForexLocaleKeys.forex_label_pips_number.tr();
  }

  String _getPriceLabelText() {
    return priceLabelText ?? FinanceLocaleKeys.finance_label_price_text.tr();
  }

  String _getPercentMenuLabel() => percentMenuText ?? _getPercentLabel();

  String _getAmountMenuLabel() => amountMenuText ?? _getAmountLabel();

  String _getPipMenuLabel() => pipMenuText ?? _getPipLabelText();

  String _getPriceMenuLabel() => priceMenuText ?? _getPriceLabelText();
}
