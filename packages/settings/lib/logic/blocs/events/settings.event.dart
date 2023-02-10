import 'package:tbloc_dart/tbloc_dart.dart';

/// The settings bloc event type.
/// This type is used to define the type of the settings bloc event.
enum FastSettingsBlocEventType {
  init,
  initialized,
  languageCodeChanged,
  countryCodeChanged,
  themeChanged,
}

/// The settings bloc event payload.
/// This payload is used to pass data to the settings bloc.
/// It can be used to pass the language code or the theme.
class FastSettingsBlocEventPayload {
  /// The language code.
  final String? languageCode;

  /// The country code.
  final String? countryCode;

  /// The theme.
  final String? theme;

  const FastSettingsBlocEventPayload({
    this.languageCode,
    this.countryCode,
    this.theme,
  });
}

/// The settings bloc event.
/// This event is used to dispatch events to the settings bloc.
/// It can be used to initialize the bloc, change the language code
/// or the theme.
class FastSettingsBlocEvent
    extends BlocEvent<FastSettingsBlocEventType, FastSettingsBlocEventPayload> {
  FastSettingsBlocEvent.languageCodeChanged(String languageCode)
      : super(
          type: FastSettingsBlocEventType.languageCodeChanged,
          payload: FastSettingsBlocEventPayload(languageCode: languageCode),
        );

  FastSettingsBlocEvent.themeChanged(String theme)
      : super(
          type: FastSettingsBlocEventType.themeChanged,
          payload: FastSettingsBlocEventPayload(theme: theme),
        );

  FastSettingsBlocEvent.countryCodeChanged(String countryCode)
      : super(
          type: FastSettingsBlocEventType.countryCodeChanged,
          payload: FastSettingsBlocEventPayload(countryCode: countryCode),
        );

  const FastSettingsBlocEvent.init()
      : super(type: FastSettingsBlocEventType.init);

  FastSettingsBlocEvent.initialized({
    String? languageCode,
    String? theme,
  }) : super(
          type: FastSettingsBlocEventType.initialized,
          payload: FastSettingsBlocEventPayload(
            languageCode: languageCode,
            theme: theme,
          ),
        );
}
