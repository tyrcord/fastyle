// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// A page that displays user settings.
class FastAppSettingsPage extends FastSettingPageLayout {
  /// The descriptor for FastSettings.
  final FastSettingsDescriptor descriptor;

  final List<Widget>? defaultValuesChildren;

  final VoidCallback? onResetSettings;

  /// A callback that is called when the user selects a new country.
  final void Function(String?)? onCountryChanged;

  /// A callback that is called when the user toggles the auto-save setting.
  final void Function(bool)? onSaveEntryChanged;

  /// A callback that is called when the user selects a new currency.
  final void Function(String)? onCurrencyChanged;

  const FastAppSettingsPage({
    super.key,
    super.headerDescriptionText,
    super.contentPadding,
    super.iconHeight,
    super.headerIcon,
    super.titleText,
    super.actions,
    this.defaultValuesChildren,
    this.onResetSettings,
    this.onCountryChanged,
    this.onSaveEntryChanged,
    this.onCurrencyChanged,
    FastSettingsDescriptor? descriptor,
  }) : descriptor = descriptor ?? const FastSettingsDescriptor();

  bool get canShowSaveUserEntry {
    final descriptor = _getCategoryDescriptor(FastAppSettingsCategories.inputs);

    if (descriptor != null) {
      return _canShowField(descriptor, FastAppSettingsFields.saveEntry);
    }

    return false;
  }

  bool get canShowPrimaryCurrency {
    final descriptor = _getCategoryDescriptor(
      FastAppSettingsCategories.defaultValues,
    );

    if (descriptor != null) {
      return _canShowField(descriptor, FastAppSettingsFields.primaryCurrency);
    }

    return false;
  }

  bool get canShowUserCountry {
    final descriptor = _getCategoryDescriptor(
      FastAppSettingsCategories.defaultValues,
    );

    if (descriptor != null) {
      return _canShowField(descriptor, FastAppSettingsFields.userCountry);
    }

    return false;
  }

  @override
  Widget buildSettingsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_canShowCategory(FastAppSettingsCategories.inputs))
          ...buildUserInputsCategory(
            _getCategoryDescriptor(FastAppSettingsCategories.inputs)!,
            context,
          ),
        if (_canShowCategory(FastAppSettingsCategories.defaultValues)) ...[
          kFastVerticalSizedBox16,
          ...buildUserDefaultValuesCategory(
            _getCategoryDescriptor(FastAppSettingsCategories.defaultValues)!,
            context,
          ),
          ...?defaultValuesChildren,
          ThemeHelper.spacing.getHorizontalSpacing(context),
          Align(
            // NOTE: wrapping the button with an Align widget
            // in order to avoid it to be stretched
            alignment: Alignment.center,
            child: buildResetSettings(context),
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
      FastListHeader(categoryText: categoryDescriptor.titleText.tr()),
      if (canShowSaveUserEntry)
        FastAppSettingsToggleSaveEntryField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastAppSettingsFields.saveEntry,
          ),
          onSaveEntryChanged: (bool saveEntry) {
            _dispatchEvent(
              FastAppSettingsBlocEvent.saveEntryChanged(saveEntry),
            );

            onSaveEntryChanged?.call(saveEntry);
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
      FastListHeader(categoryText: categoryDescriptor.titleText.tr()),
      if (canShowPrimaryCurrency)
        FastAppSettingsPrimaryCurrencyField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastAppSettingsFields.primaryCurrency,
          ),
          onCurrencyChanged: (String code) {
            _dispatchEvent(
              FastAppSettingsBlocEvent.primaryCurrencyCodeChanged(code),
            );

            onCurrencyChanged?.call(code);
          },
        ),
      if (canShowUserCountry)
        FastAppSettingsUserCountrySelectField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastAppSettingsFields.userCountry,
          ),
          onCountryChanged: (String? code) {
            _dispatchEvent(
              FastAppSettingsBlocEvent.countryCodeChanged(code),
            );

            onCountryChanged?.call(code);
          },
        ),
    ];
  }

  @override
  Widget buildSettingsHeaderIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FastPageHeaderRoundedDuotoneIconLayout(
        icon: FaIcon(FastFontAwesomeIcons.lightUserGear),
      );
    }

    return const FastPageHeaderRoundedDuotoneIconLayout(
      icon: FaIcon(FontAwesomeIcons.solidUser),
    );
  }

  Widget buildResetSettings(BuildContext context) {
    final blueColor = ThemeHelper.getPaletteColors(context).blue.mid;

    return FastTextButton(
      text: SettingsLocaleKeys.settings_label_restore_settings.tr(),
      textColor: blueColor,
      upperCase: false,
      onTap: () async {
        showAnimatedFastAlertDialog(
          messageText: CoreLocaleKeys.core_question_are_you_sure.tr(),
          titleText: CoreLocaleKeys.core_label_confirmation.tr(),
          context: context,
          showCancel: true,
          onValid: () async {
            if (canShowPrimaryCurrency) {
              _dispatchEvent(
                FastAppSettingsBlocEvent.primaryCurrencyCodeChanged(
                  kFastAppSettingsPrimaryCurrencyCode,
                ),
              );
            }

            if (canShowSaveUserEntry) {
              _dispatchEvent(
                FastAppSettingsBlocEvent.saveEntryChanged(
                  kFastAppSettingsSaveEntry,
                ),
              );
            }

            if (canShowUserCountry) {
              _dispatchEvent(FastAppSettingsBlocEvent.countryCodeChanged(null));
            }

            onResetSettings?.call();

            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// Dispatches the given [event] to the [FastAppSettingsBloc].
  void _dispatchEvent(FastAppSettingsBlocEvent event) {
    final bloc = FastAppSettingsBloc.instance;

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
