import 'package:tstore_dart/tstore_dart.dart';

/// The settings document.
class FastSettingsDocument extends TDocument {
  /// The language code of the application.
  /// Format: ios3166
  /// For example: en, fr, de, ...
  final String? languageCode;

  /// The country code of the application.
  /// Format: ios3166
  /// For example: US, FR, DE, ...
  final String? countryCode;

  /// The theme of the application.
  final String? theme;

  const FastSettingsDocument({
    this.languageCode,
    this.countryCode,
    this.theme,
  });

  factory FastSettingsDocument.fromJson(Map<String, dynamic> json) {
    return FastSettingsDocument(
      languageCode: json['languageCode'] as String?,
      countryCode: json['countryCode'] as String?,
      theme: json['theme'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'languageCode': languageCode,
        'countryCode': countryCode,
        'theme': theme,
      };

  @override
  FastSettingsDocument copyWith({
    String? languageCode,
    String? countryCode,
    String? theme,
  }) =>
      FastSettingsDocument(
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode ?? this.countryCode,
        theme: theme ?? this.theme,
      );

  @override
  FastSettingsDocument merge(covariant FastSettingsDocument model) {
    return copyWith(
      languageCode: model.languageCode,
      countryCode: model.countryCode,
      theme: model.theme,
    );
  }

  @override
  FastSettingsDocument clone() {
    return FastSettingsDocument(
      languageCode: languageCode,
      countryCode: countryCode,
      theme: theme,
    );
  }

  @override
  List<Object?> get props => [languageCode, countryCode, theme];
}
