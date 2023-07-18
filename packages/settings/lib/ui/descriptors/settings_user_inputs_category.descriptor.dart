// Package imports:
import 'package:fastyle_forms/fastyle_forms.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// The default fields for the `FastAppSettingsInputsCategoryDescriptor` class.
const kDefaultFastAppSettingsInputsFields = {
  FastAppSettingsFields.saveEntry: FastFormFieldDescriptor(
    labelText: 'Auto-save',
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
          titleText: titleText ?? 'USER INPUTS',
          show: show ?? true,
        );
}
