import 'package:fastyle_core/fastyle_core.dart';
import 'package:tstore/tstore.dart';

/// Represents a user settings document with user-specific preferences.
class FastUserSettingsDocument extends TDocument {
  /// The user's preferred currency.
  final String primaryCurrencyCode;

  /// The user's secondary currency.
  final String? secondaryCurrencyCode;

  /// Whether to save user entries.
  final bool saveEntry;

  /// Creates a new instance of [FastUserSettingsDocument].
  const FastUserSettingsDocument({
    this.secondaryCurrencyCode,
    String? primaryCurrencyCode,
    bool? saveEntry,
  })  : primaryCurrencyCode =
            primaryCurrencyCode ?? kFastUserSettingPrimaryCurrencyCode,
        saveEntry = saveEntry ?? kFastUserSettingSaveEntry;

  /// Creates a new instance of [FastUserSettingsDocument] from a JSON [Map].
  factory FastUserSettingsDocument.fromJson(Map<String, dynamic> json) {
    return FastUserSettingsDocument(
      primaryCurrencyCode:
          json[FastUserSettings.primaryCurrencyCode] as String? ??
              kFastUserSettingPrimaryCurrencyCode,
      secondaryCurrencyCode:
          json[FastUserSettings.secondaryCurrencyCode] as String?,
      saveEntry: json[FastUserSettings.saveEntry] as bool? ??
          kFastUserSettingSaveEntry,
    );
  }

  /// Converts this [FastUserSettingsDocument] instance to a JSON [Map].
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        FastUserSettings.primaryCurrencyCode: primaryCurrencyCode,
        FastUserSettings.secondaryCurrencyCode: secondaryCurrencyCode,
        FastUserSettings.saveEntry: saveEntry,
      };

  /// Creates a new instance of [FastUserSettingsDocument] with the specified
  /// properties. If any property is not provided, it will be copied from the
  /// current instance.
  @override
  FastUserSettingsDocument copyWith({
    String? primaryCurrencyCode,
    String? secondaryCurrencyCode,
    bool? saveEntry,
  }) =>
      FastUserSettingsDocument(
        primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
        secondaryCurrencyCode:
            secondaryCurrencyCode ?? this.secondaryCurrencyCode,
        saveEntry: saveEntry ?? this.saveEntry,
      );

  /// Merges this [FastUserSettingsDocument] instance with another instance
  /// of [FastUserSettingsDocument], returning a new instance with merged
  /// properties.
  @override
  FastUserSettingsDocument merge(covariant FastUserSettingsDocument model) {
    return copyWith(
      primaryCurrencyCode: model.primaryCurrencyCode,
      secondaryCurrencyCode: model.secondaryCurrencyCode,
      saveEntry: model.saveEntry,
    );
  }

  /// Creates a new instance of [FastUserSettingsDocument] with the same
  /// property values as the current instance.
  @override
  FastUserSettingsDocument clone() => copyWith();

  /// Returns a list of the properties used for comparison, typically for
  /// equality checks.
  @override
  List<Object?> get props => [
        primaryCurrencyCode,
        secondaryCurrencyCode,
        saveEntry,
      ];
}
