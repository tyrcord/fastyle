import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:fastyle_settings/fastyle_settings.dart';

/// The default fields for the `FastUserSettingsInputsCategoryDescriptor` class.
const kDefaultFastUserSettingsInputsFields = {
  FastUserSettingsFields.saveEntry: FastFormFieldDescriptor(
    labelText: 'Auto-save',
  ),
};

/// A class that represents a category of settings related to user inputs.
class FastUserSettingsInputsCategoryDescriptor
    extends FastSettingsCategoryDescriptor {
  /// Creates a new instance of the `FastUserSettingsInputsCategoryDescriptor`
  /// class.
  ///
  /// [fields] is an optional map of field descriptors for the category.
  /// [titleText] is an optional string that represents the title of
  /// the category.
  /// [show] is an optional boolean that indicates whether the category should
  /// be shown.
  const FastUserSettingsInputsCategoryDescriptor({
    Map<String, FastFormFieldDescriptor>? fields,
    String? titleText,
    bool? show,
  }) : super(
          fields: fields ?? kDefaultFastUserSettingsInputsFields,
          titleText: titleText ?? 'USER INPUTS',
          show: show ?? true,
        );
}
