import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';

/// A page that displays user settings.
class FastUserSettingsPage extends FastSettingPageLayout {
  /// The descriptor for FastSettings.
  final FastSettingsDescriptor descriptor;

  const FastUserSettingsPage({
    super.key,
    super.headerDescriptionText,
    super.contentPadding,
    super.iconHeight,
    super.headerIcon,
    super.titleText,
    super.actions,
    FastSettingsDescriptor? descriptor,
  }) : descriptor = descriptor ?? const FastSettingsDescriptor();

  @override
  Widget buildSettingsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_canShowCategory(FastUserSettingsCategories.inputs))
          ...buildUserInputsCategory(
            _getCategoryDescriptor(FastUserSettingsCategories.inputs)!,
            context,
          ),
        if (_canShowCategory(FastUserSettingsCategories.defaultValues)) ...[
          kFastVerticalSizedBox16,
          ...buildUserDefaultValuesCategory(
            _getCategoryDescriptor(FastUserSettingsCategories.defaultValues)!,
            context,
          ),
        ]
      ],
    );
  }

  /// Builds the user input settings category.
  List<Widget> buildUserInputsCategory(
    FastSettingsCategoryDescriptor categoryDescriptor,
    BuildContext context,
  ) {
    return [
      FastListHeader(categoryText: categoryDescriptor.titleText),
      if (_canShowField(categoryDescriptor, FastUserSettingsFields.saveEntry))
        FastUserSettingsToggleSaveEntryField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastUserSettingsFields.saveEntry,
          ),
          onSaveEntryChanged: (bool saveEntry) {
            _dispatchEvent(
              context,
              FastUserSettingsBlocEvent.saveEntryChanged(saveEntry),
            );
          },
        ),
    ];
  }

  /// Builds the default value settings category.
  List<Widget> buildUserDefaultValuesCategory(
    FastSettingsCategoryDescriptor categoryDescriptor,
    BuildContext context,
  ) {
    return [
      FastListHeader(categoryText: categoryDescriptor.titleText),
      if (_canShowField(
          categoryDescriptor, FastUserSettingsFields.primaryCurrency))
        FastUserSettingsPrimaryCurrencyField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastUserSettingsFields.primaryCurrency,
          ),
          onCurrencyChanged: (String currencyCode) {
            _dispatchEvent(
              context,
              FastUserSettingsBlocEvent.primaryCurrencyCodeChanged(
                currencyCode,
              ),
            );
          },
        ),
    ];
  }

  @override
  Widget buildSettingsHeaderIcon(BuildContext context) {
    return const FastSettingPageHeaderRoundedDuotoneIconLayout(
      icon: FaIcon(FontAwesomeIcons.solidUser),
    );
  }

  /// Dispatches the given [event] to the [FastUserSettingsBloc].
  void _dispatchEvent(BuildContext context, FastUserSettingsBlocEvent event) {
    final bloc = BlocProvider.of<FastUserSettingsBloc>(context);

    bloc.addEvent(event);
  }

  bool _canShowCategory(String name) {
    final category = _getCategoryDescriptor(name);

    if (category != null) {
      return category.show;
    }

    return false;
  }

  bool _canShowField(
    FastSettingsCategoryDescriptor categoryDescriptor,
    String name,
  ) {
    final field = _getFieldDescriptor(categoryDescriptor, name);

    if (field != null) {
      return field.show;
    }

    return false;
  }

  FastSettingsCategoryDescriptor? _getCategoryDescriptor(String name) {
    return descriptor.categories[name];
  }

  FastFormFieldDescriptor? _getFieldDescriptor(
    FastSettingsCategoryDescriptor categoryDescriptor,
    String name,
  ) {
    return categoryDescriptor.fields[name];
  }
}
