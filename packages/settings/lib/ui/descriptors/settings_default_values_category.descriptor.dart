// Package imports:
import 'package:fastyle_forms/fastyle_forms.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// The default values for the user settings fields.
const kDefaultFastAppSettingsDefaultValuesFields = {
  FastAppSettingsFields.primaryCurrency: FastFormFieldDescriptor(
    labelText: 'Select primary currency',
    searchTitleText: 'Primary currency',
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
          titleText: titleText ?? 'DEFAULT VALUES',
          show: show ?? true,
        );
}
