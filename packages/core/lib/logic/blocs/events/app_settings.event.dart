import 'package:tbloc/tbloc.dart';

/// The settings bloc event type.
/// This type is used to define the type of the settings bloc event.
enum FastAppSettingsBlocEventType {
  init,
  initialized,
  languageCodeChanged,
  countryCodeChanged,
  themeChanged,
}

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

  const FastAppSettingsBlocEventPayload({
    this.languageCode,
    this.countryCode,
    this.theme,
  });
}

/// The settings bloc event.
/// This event is used to dispatch events to the settings bloc.
/// It can be used to initialize the bloc, change the language code
/// or the theme.
class FastAppSettingsBlocEvent extends BlocEvent<FastAppSettingsBlocEventType,
    FastAppSettingsBlocEventPayload> {
  FastAppSettingsBlocEvent.languageCodeChanged(String languageCode)
      : super(
          type: FastAppSettingsBlocEventType.languageCodeChanged,
          payload: FastAppSettingsBlocEventPayload(languageCode: languageCode),
        );

  FastAppSettingsBlocEvent.themeChanged(String theme)
      : super(
          type: FastAppSettingsBlocEventType.themeChanged,
          payload: FastAppSettingsBlocEventPayload(theme: theme),
        );

  FastAppSettingsBlocEvent.countryCodeChanged(String countryCode)
      : super(
          type: FastAppSettingsBlocEventType.countryCodeChanged,
          payload: FastAppSettingsBlocEventPayload(countryCode: countryCode),
        );

  const FastAppSettingsBlocEvent.init()
      : super(type: FastAppSettingsBlocEventType.init);

  FastAppSettingsBlocEvent.initialized({
    String? languageCode,
    String? theme,
  }) : super(
          type: FastAppSettingsBlocEventType.initialized,
          payload: FastAppSettingsBlocEventPayload(
            languageCode: languageCode,
            theme: theme,
          ),
        );
}
