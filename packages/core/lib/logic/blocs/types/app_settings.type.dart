/// The settings bloc event type.
/// This type is used to define the type of the settings bloc event.
enum FastAppSettingsBlocEventType {
  init,
  initialized,
  languageCodeChanged,
  countryCodeChanged,
  themeChanged,

  /// Event indicating a change in the primary currency code.
  primaryCurrencyCodeChanged,

  /// Event indicating a change in the secondary currency code.
  secondaryCurrencyCodeChanged,

  /// Event indicating a change in the save entry option.
  saveEntryChanged,
}
