import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';

const kFastSettingsDefaultCountryCode = 'US';
const kFastSettingsDefaultLanguageCode = 'en';

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
  final String countryCode;

  /// The current theme of the application.
  final String? theme;

  /// The current locale code of the application.
  /// Format: languageCode_countryCode
  /// For example: en_US, fr_FR, de_DE, ...
  String get localeCode => '${languageCode}_$countryCode';

  /// The current theme mode of the application.
  /// It is computed from the current theme.
  ThemeMode get themeMode {
    return kFastSettingThemeModeMap[theme ?? kFastSettingsDefaultTheme]!;
  }

  /// Constructs a [FastAppSettingsBlocState] with the provided parameters.
  FastAppSettingsBlocState({
    super.isInitializing,
    super.isInitialized,
    this.theme,
    String? languageCode,
    String? countryCode,
  })  : languageCode = languageCode ?? kFastSettingsDefaultLanguageCode,
        countryCode = countryCode ?? kFastSettingsDefaultCountryCode;

  /// Creates a new [FastAppSettingsBlocState] instance with updated properties.
  ///
  /// If a parameter is not provided, the corresponding property of the current
  /// instance is used instead.
  @override
  FastAppSettingsBlocState copyWith({
    bool? isInitializing,
    String? languageCode,
    String? countryCode,
    bool? isInitialized,
    String? theme,
  }) =>
      FastAppSettingsBlocState(
        isInitializing: isInitializing ?? this.isInitializing,
        isInitialized: isInitialized ?? this.isInitialized,
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode ?? this.countryCode,
        theme: theme ?? this.theme,
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
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      languageCode: model.languageCode,
      countryCode: model.countryCode,
      theme: model.theme,
    );
  }

  /// Returns a list of properties used to determine equality between instances.
  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        languageCode,
        countryCode,
        theme,
      ];
}
