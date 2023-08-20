// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// A page that displays user settings.
class FastAppSettingsPage extends FastSettingPageLayout {
  /// The descriptor for FastSettings.
  final FastSettingsDescriptor descriptor;

  final List<Widget>? defaultValuesChildren;

  final VoidCallback? onResetSettings;

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
    FastSettingsDescriptor? descriptor,
  }) : descriptor = descriptor ?? const FastSettingsDescriptor();

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
          buildResetSettings(context),
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
      if (_canShowField(categoryDescriptor, FastAppSettingsFields.saveEntry))
        FastAppSettingsToggleSaveEntryField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastAppSettingsFields.saveEntry,
          ),
          onSaveEntryChanged: (bool saveEntry) {
            _dispatchEvent(
              context,
              FastAppSettingsBlocEvent.saveEntryChanged(saveEntry),
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
      FastListHeader(categoryText: categoryDescriptor.titleText.tr()),
      if (_canShowField(
        categoryDescriptor,
        FastAppSettingsFields.primaryCurrency,
      ))
        FastAppSettingsPrimaryCurrencyField(
          descriptor: _getFieldDescriptor(
            categoryDescriptor,
            FastAppSettingsFields.primaryCurrency,
          ),
          onCurrencyChanged: (String currencyCode) {
            _dispatchEvent(
              context,
              FastAppSettingsBlocEvent.primaryCurrencyCodeChanged(
                currencyCode,
              ),
            );
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
      text: SettingsLocaleKeys.settings_label_reset_settings.tr(),
      textColor: blueColor,
      upperCase: false,
      onTap: () async {
        showAnimatedFastAlertDialog(
          messageText: CoreLocaleKeys.core_question_are_you_sure.tr(),
          titleText: CoreLocaleKeys.core_label_confirmation.tr(),
          context: context,
          showCancel: true,
          onValid: () async {
            _dispatchEvent(
              context,
              FastAppSettingsBlocEvent.primaryCurrencyCodeChanged(
                kFastAppSettingsPrimaryCurrencyCode,
              ),
            );

            _dispatchEvent(
              context,
              FastAppSettingsBlocEvent.saveEntryChanged(
                kFastAppSettingsSaveEntry,
              ),
            );

            onResetSettings?.call();

            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// Dispatches the given [event] to the [FastAppSettingsBloc].
  void _dispatchEvent(BuildContext context, FastAppSettingsBlocEvent event) {
    final bloc = BlocProvider.of<FastAppSettingsBloc>(context);

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
