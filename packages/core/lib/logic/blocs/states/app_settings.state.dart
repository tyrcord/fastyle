// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppSettingsBlocState] class is the state of the
/// [FastAppSettingsBloc].
///
/// It contains the current settings of the application.
class FastAppSettingsBlocState extends BlocState {
  /// The current language code of the application.
  /// Format: ios3166
  /// For example: en, fr, de, ...
  final String languageCode;

  /// The current country code of the application.
  /// Format: ios3166
  /// For example: US, FR, DE, ...
  final String? countryCode;

  /// The current theme of the application.
  final String? theme;

  /// The primary currency code.
  final String primaryCurrencyCode;

  /// The secondary currency code.
  final String? secondaryCurrencyCode;

  /// Indicates whether the user's entry should be saved or not.
  final bool saveEntry;

  /// Whether the application should always use the 24-hour format.
  final bool use24HourFormat;

  /// The current locale of the application.
  Locale get languageLocale {
    if (languageCode.isEmpty) {
      return const Locale(kFastSettingsDefaultLanguageCode);
    }

    return Locale(languageCode);
  }

  /// The current locale code of the application.
  /// Format: languageCode_countryCode
  /// For example: en_US, fr_FR, de_DE, ...
  String get localeCode {
    final appInfo = FastAppInfoBloc.instance.currentState;

    final localeCode = toIos3166Code(
      languageCode,
      countryCode: countryCode ?? appInfo.deviceCountryCode,
    );

    return localeCode ?? kFastSettingsDefaultLanguageCode;
  }

  /// The current theme mode of the application.
  /// It is computed from the current theme.
  ThemeMode get themeMode {
    return kFastSettingThemeModeMap[theme ?? kFastSettingsDefaultTheme]!;
  }

  /// Constructs a [FastAppSettingsBlocState] with the provided parameters.
  FastAppSettingsBlocState({
    super.isInitializing,
    super.isInitialized,
    this.secondaryCurrencyCode,
    this.countryCode,
    this.theme,
    bool? use24HourFormat,
    String? primaryCurrencyCode,
    String? languageCode,
    bool? saveEntry,
  })  : primaryCurrencyCode =
            primaryCurrencyCode ?? kFastAppSettingsPrimaryCurrencyCode,
        saveEntry = saveEntry ?? kFastAppSettingsSaveEntry,
        languageCode = languageCode ?? kFastSettingsDefaultLanguageCode,
        use24HourFormat = use24HourFormat ?? false;

  /// Creates a new [FastAppSettingsBlocState] instance with updated properties.
  ///
  /// If a parameter is not provided, the corresponding property of the current
  /// instance is used instead.
  @override
  FastAppSettingsBlocState copyWith({
    bool? use24HourFormat,
    bool? isInitializing,
    String? languageCode,
    ValueGetter<String?>? countryCode,
    bool? isInitialized,
    String? theme,
    String? primaryCurrencyCode,
    String? secondaryCurrencyCode,
    bool? saveEntry,
  }) =>
      FastAppSettingsBlocState(
        isInitializing: isInitializing ?? this.isInitializing,
        isInitialized: isInitialized ?? this.isInitialized,
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode != null ? countryCode() : this.countryCode,
        theme: theme ?? this.theme,
        use24HourFormat: use24HourFormat ?? this.use24HourFormat,
        primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
        secondaryCurrencyCode:
            secondaryCurrencyCode ?? this.secondaryCurrencyCode,
        saveEntry: saveEntry ?? this.saveEntry,
      );

  /// Creates a new [FastAppSettingsBlocState] instance with the same property
  /// values as the current instance.
  @override
  FastAppSettingsBlocState clone() => copyWith();

  /// Merges the properties of the provided [model] into a new
  /// [FastAppSettingsBlocState] instance.
  @override
  FastAppSettingsBlocState merge(covariant FastAppSettingsBlocState model) {
    return copyWith(
      use24HourFormat: model.use24HourFormat,
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      languageCode: model.languageCode,
      countryCode: () => model.countryCode,
      theme: model.theme,
      primaryCurrencyCode: model.primaryCurrencyCode,
      secondaryCurrencyCode: model.secondaryCurrencyCode,
      saveEntry: model.saveEntry,
    );
  }

  /// Returns a list of properties used to determine equality between instances.
  @override
  List<Object?> get props => [
        use24HourFormat,
        isInitializing,
        isInitialized,
        languageCode,
        countryCode,
        theme,
        primaryCurrencyCode,
        secondaryCurrencyCode,
        saveEntry,
      ];
}
