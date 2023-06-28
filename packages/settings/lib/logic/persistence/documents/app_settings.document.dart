import 'package:fastyle_settings/logic/logic.dart';
import 'package:tstore/tstore.dart';

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

  /// Creates an instance of [FastAppSettingsDocument].
  const FastAppSettingsDocument({
    this.languageCode,
    this.countryCode,
    this.theme,
  });

  /// Creates an instance of [FastAppSettingsDocument] from a JSON map.
  factory FastAppSettingsDocument.fromJson(Map<String, dynamic> json) {
    return FastAppSettingsDocument(
      languageCode: json[FastAppPreferences.languageCode] as String?,
      countryCode: json[FastAppPreferences.countryCode] as String?,
      theme: json[FastAppPreferences.theme] as String?,
    );
  }

  @override

  /// Converts the [FastAppSettingsDocument] object to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        FastAppPreferences.languageCode: languageCode,
        FastAppPreferences.countryCode: countryCode,
        FastAppPreferences.theme: theme,
      };

  @override

  /// Creates a new [FastAppSettingsDocument] object with updated property
  /// values.
  ///
  /// If any of the optional properties ([languageCode], [countryCode], [theme])
  /// are not provided, the current values are retained.
  FastAppSettingsDocument copyWith({
    String? languageCode,
    String? countryCode,
    String? theme,
  }) =>
      FastAppSettingsDocument(
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode ?? this.countryCode,
        theme: theme ?? this.theme,
      );

  @override

  /// Merges another [FastAppSettingsDocument] object into the current instance.
  ///
  /// Creates a new instance with properties taken from the [model] object,
  /// except for the ones that are `null`.
  FastAppSettingsDocument merge(covariant FastAppSettingsDocument model) {
    return copyWith(
      languageCode: model.languageCode,
      countryCode: model.countryCode,
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
  List<Object?> get props => [languageCode, countryCode, theme];
}
