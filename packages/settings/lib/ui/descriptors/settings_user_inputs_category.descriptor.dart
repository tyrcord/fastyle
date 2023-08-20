// Package imports:
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// The default fields for the `FastAppSettingsInputsCategoryDescriptor` class.
const kDefaultFastAppSettingsInputsFields = {
  FastAppSettingsFields.saveEntry: FastFormFieldDescriptor(
    labelText: CoreLocaleKeys.core_label_auto_save,
  ),
};

/// A class that represents a category of settings related to user inputs.
class FastAppSettingsInputsCategoryDescriptor
    extends FastSettingsCategoryDescriptor {
  /// Creates a new instance of the `FastAppSettingsInputsCategoryDescriptor`
  /// class.
  ///
  /// [fields] is an optional map of field descriptors for the category.
  /// [titleText] is an optional string that represents the title of
  /// the category.
  /// [show] is an optional boolean that indicates whether the category should
  /// be shown.
  const FastAppSettingsInputsCategoryDescriptor({
    Map<String, FastFormFieldDescriptor>? fields,
    String? titleText,
    bool? show,
  }) : super(
          fields: fields ?? kDefaultFastAppSettingsInputsFields,
          titleText: titleText ?? SettingsLocaleKeys.settings_label_user_inputs,
          show: show ?? true,
        );
}
