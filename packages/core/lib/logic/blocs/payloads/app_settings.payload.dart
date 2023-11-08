/// The settings bloc event payload.
/// This payload is used to pass data to the settings bloc.
/// It can be used to pass the language code or the theme.
class FastAppSettingsBlocEventPayload {
  /// The language code.
  final String? languageCode;

  /// The country code.
  final String? countryCode;

  /// The theme.
  final String? theme;

  /// The primary currency code.
  final String? primaryCurrencyCode;

  /// The secondary currency code.
  final String? secondaryCurrencyCode;

  /// The save entry option.
  final bool? saveEntry;

  /// Whether to always use 24 hour format.
  final bool? alwaysUse24HourFormat;

  const FastAppSettingsBlocEventPayload({
    this.primaryCurrencyCode,
    this.secondaryCurrencyCode,
    this.alwaysUse24HourFormat,
    this.languageCode,
    this.countryCode,
    this.saveEntry,
    this.theme,
  });
}
