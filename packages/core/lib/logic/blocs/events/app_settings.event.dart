import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

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

  /// Constructor for the [primaryCurrencyCodeChanged] event.
  FastAppSettingsBlocEvent.primaryCurrencyCodeChanged(
    String primaryCurrencyCode,
  ) : super(
          type: FastAppSettingsBlocEventType.primaryCurrencyCodeChanged,
          payload: FastAppSettingsBlocEventPayload(
            primaryCurrencyCode: primaryCurrencyCode,
          ),
        );

  /// Constructor for the [secondaryCurrencyCodeChanged] event.
  FastAppSettingsBlocEvent.secondaryCurrencyCodeChanged(
    String secondaryCurrencyCode,
  ) : super(
          type: FastAppSettingsBlocEventType.secondaryCurrencyCodeChanged,
          payload: FastAppSettingsBlocEventPayload(
            secondaryCurrencyCode: secondaryCurrencyCode,
          ),
        );

  /// Constructor for the [saveEntryChanged] event.
  FastAppSettingsBlocEvent.saveEntryChanged(bool saveEntry)
      : super(
          type: FastAppSettingsBlocEventType.saveEntryChanged,
          payload: FastAppSettingsBlocEventPayload(saveEntry: saveEntry),
        );

  const FastAppSettingsBlocEvent.init()
      : super(type: FastAppSettingsBlocEventType.init);

  const FastAppSettingsBlocEvent.initialized(
    FastAppSettingsBlocEventPayload payload,
  ) : super(type: FastAppSettingsBlocEventType.initialized, payload: payload);
}
