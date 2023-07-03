import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_forms/fastyle_forms.dart';

/// A toggle list item that allows the user to enable or disable auto-saving of
/// form entries.
class FastUserSettingsToggleSaveEntryField extends StatelessWidget {
  /// A callback that is called when the user toggles the auto-save setting.
  final void Function(bool)? onSaveEntryChanged;

  /// The descriptor for the form field.
  final FastFormFieldDescriptor? descriptor;

  /// The text to display as the label for the toggle list item.
  final String labelText;

  const FastUserSettingsToggleSaveEntryField({
    super.key,
    this.onSaveEntryChanged,
    this.descriptor,
    String? labelText,
  }) : labelText = labelText ?? 'Auto-save';

  @override
  Widget build(BuildContext context) {
    return FastUserSettingsSaveEntryBuilder(
      builder: (BuildContext context, FastUserSettingsBlocState state) {
        return FastToggleListItem(
          labelText: descriptor?.labelText ?? labelText,
          isEnabled: state.isInitialized,
          isChecked: state.saveEntry,
          onValueChanged: (bool saveEntry) {
            onSaveEntryChanged?.call(saveEntry);
          },
        );
      },
    );
  }
}
