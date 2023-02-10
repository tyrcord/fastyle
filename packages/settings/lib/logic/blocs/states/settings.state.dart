import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:flutter/material.dart';

final String _defaultTheme = kFastSettingsThemeMap[ThemeMode.system]!;

/// The [FastSettingsBlocState] class is the state of the [FastSettingsBloc].
/// It contains the current settings of the application.
class FastSettingsBlocState extends BlocState {
  /// The current language code of the application.
  /// Format: ios3166
  /// For example: en, fr, de, ...
  final String? languageCode;

  /// The current country code of the application.
  /// Format: ios3166
  /// For example: US, FR, DE, ...
  final String? countryCode;

  /// The current theme of the application.
  final String? theme;

  /// The current theme mode of the application.
  /// It is computed from the current theme.
  ThemeMode get themeMode {
    return kFastSettingThemeModeMap[theme ?? _defaultTheme]!;
  }

  const FastSettingsBlocState({
    super.isInitializing,
    super.isInitialized,
    this.languageCode,
    this.countryCode,
    this.theme,
  });

  @override
  FastSettingsBlocState copyWith({
    bool? isInitializing,
    String? languageCode,
    String? countryCode,
    bool? isInitialized,
    String? theme,
  }) =>
      FastSettingsBlocState(
        isInitializing: isInitializing ?? this.isInitializing,
        isInitialized: isInitialized ?? this.isInitialized,
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode ?? this.countryCode,
        theme: theme ?? this.theme,
      );

  @override
  FastSettingsBlocState clone() {
    return FastSettingsBlocState(
      isInitializing: isInitializing,
      isInitialized: isInitialized,
      languageCode: languageCode,
      countryCode: countryCode,
      theme: theme,
    );
  }

  @override
  FastSettingsBlocState merge(covariant FastSettingsBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      languageCode: model.languageCode,
      countryCode: model.countryCode,
      theme: model.theme,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        languageCode,
        countryCode,
        theme,
      ];
}
