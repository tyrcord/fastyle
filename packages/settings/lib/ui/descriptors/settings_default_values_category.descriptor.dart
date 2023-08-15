// Package imports:
import 'package:fastyle_forms/fastyle_forms.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

/// The default values for the user settings fields.
const kDefaultFastAppSettingsDefaultValuesFields = {
  FastAppSettingsFields.primaryCurrency: FastFormFieldDescriptor(
    searchTitleText: FinanceLocaleKeys.finance_label_primary_currency,
    labelText: FinanceLocaleKeys.finance_select_primary_currency,
  ),
};

/// The descriptor for the user settings default values category.
class FastAppSettingsDefaultValuesCategoryDescriptor
    extends FastSettingsCategoryDescriptor {
  /// Creates a new instance of the
  /// [FastAppSettingsDefaultValuesCategoryDescriptor].
  ///
  /// [fields] is an optional map of field descriptors for the category.
  /// [titleText] is an optional string that represents the title of
  /// the category.
  /// [show] is an optional boolean that indicates whether the category should
  /// be shown.
  const FastAppSettingsDefaultValuesCategoryDescriptor({
    Map<String, FastFormFieldDescriptor>? fields,
    String? titleText,
    bool? show,
  }) : super(
          fields: fields ?? kDefaultFastAppSettingsDefaultValuesFields,
          titleText: titleText ?? SettingsLocaleKeys.settings_label_default,
          show: show ?? true,
        );
}
