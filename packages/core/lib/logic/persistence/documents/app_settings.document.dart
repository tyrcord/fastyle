// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The app settings document.
class FastAppSettingsDocument extends TDocument {
  /// The language code of the application.
  /// Format: iso3166
  /// For example: en, fr, de, ...
  final String? languageCode;

  /// The country code of the application.
  /// Format: iso3166
  /// For example: US, FR, DE, ...
  final String? countryCode;

  /// The theme of the application.
  final String? theme;

  /// The user's preferred currency.
  final String primaryCurrencyCode;

  /// The user's secondary currency.
  final String? secondaryCurrencyCode;

  /// Whether to save user entries.
  final bool saveEntry;

  /// Whether to always use 24 hour format.
  final bool use24HourFormat;

  /// Creates an instance of [FastAppSettingsDocument].
  const FastAppSettingsDocument({
    this.languageCode,
    this.countryCode,
    this.theme,
    this.secondaryCurrencyCode,
    bool? use24HourFormat = kFastAppSettingsuse24HourFormat,
    String? primaryCurrencyCode,
    bool? saveEntry,
  })  : primaryCurrencyCode =
            primaryCurrencyCode ?? kFastAppSettingsPrimaryCurrencyCode,
        saveEntry = saveEntry ?? kFastAppSettingsSaveEntry,
        use24HourFormat = use24HourFormat ?? kFastAppSettingsuse24HourFormat;

  /// Creates an instance of [FastAppSettingsDocument] from a JSON map.
  factory FastAppSettingsDocument.fromJson(Map<String, dynamic> json) {
    return FastAppSettingsDocument(
      languageCode: json[FastAppSettings.languageCode] as String?,
      countryCode: json[FastAppSettings.countryCode] as String?,
      theme: json[FastAppSettings.theme] as String?,
      primaryCurrencyCode:
          json[FastAppSettings.primaryCurrencyCode] as String? ??
              kFastAppSettingsPrimaryCurrencyCode,
      secondaryCurrencyCode:
          json[FastAppSettings.secondaryCurrencyCode] as String?,
      saveEntry:
          json[FastAppSettings.saveEntry] as bool? ?? kFastAppSettingsSaveEntry,
      use24HourFormat: json[FastAppSettings.use24HourFormat] as bool? ??
          kFastAppSettingsuse24HourFormat,
    );
  }

  @override

  /// Converts the [FastAppSettingsDocument] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        FastAppSettings.use24HourFormat: use24HourFormat,
        FastAppSettings.secondaryCurrencyCode: secondaryCurrencyCode,
        FastAppSettings.primaryCurrencyCode: primaryCurrencyCode,
        FastAppSettings.languageCode: languageCode,
        FastAppSettings.countryCode: countryCode,
        FastAppSettings.saveEntry: saveEntry,
        FastAppSettings.theme: theme,
        ...super.toJson(),
      };

  @override

  /// Creates a new [FastAppSettingsDocument] object with updated property
  /// values.
  ///
  /// If any of the optional properties ([languageCode], [countryCode], [theme],
  /// [secondaryCurrencyCode]) are not provided, the current values are
  /// retained.
  FastAppSettingsDocument copyWith({
    String? languageCode,
    ValueGetter<String?>? countryCode,
    String? theme,
    String? primaryCurrencyCode,
    String? secondaryCurrencyCode,
    bool? saveEntry,
    bool? use24HourFormat,
  }) =>
      FastAppSettingsDocument(
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode != null ? countryCode() : this.countryCode,
        theme: theme ?? this.theme,
        primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
        secondaryCurrencyCode:
            secondaryCurrencyCode ?? this.secondaryCurrencyCode,
        saveEntry: saveEntry ?? this.saveEntry,
        use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      );

  @override

  /// Merges another [FastAppSettingsDocument] object into the current instance.
  ///
  /// Creates a new instance with properties taken from the [model] object,
  /// except for the ones that are `null`.
  FastAppSettingsDocument merge(covariant FastAppSettingsDocument model) {
    return copyWith(
      primaryCurrencyCode: model.primaryCurrencyCode,
      secondaryCurrencyCode: model.secondaryCurrencyCode,
      use24HourFormat: model.use24HourFormat,
      countryCode: () => model.countryCode,
      languageCode: model.languageCode,
      saveEntry: model.saveEntry,
      theme: model.theme,
    );
  }

  @override

  /// Creates a new instance of [FastAppSettingsDocument] with the same
  /// property values.
  FastAppSettingsDocument clone() => copyWith();

  @override

  /// Overrides the `props` getter from the `TDocument` class.
  ///
  /// Returns a list of the object's properties for comparison.
  List<Object?> get props => [
        secondaryCurrencyCode,
        use24HourFormat,
        primaryCurrencyCode,
        languageCode,
        countryCode,
        saveEntry,
        theme,
      ];
}
