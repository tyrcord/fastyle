import 'package:tbloc/tbloc.dart';

/// Enum representing different types of events that can be dispatched to the
/// [FastUserSettingsBloc].
enum FastUserSettingsBlocEventType {
  /// Event indicating the initialization of the [FastUserSettingsBloc].
  init,

  /// Event indicating that the [FastUserSettingsBloc] has been initialized.
  initialized,

  /// Event indicating a change in the primary currency code.
  primaryCurrencyCodeChanged,

  /// Event indicating a change in the secondary currency code.
  secondaryCurrencyCodeChanged,

  /// Event indicating a change in the save entry option.
  saveEntryChanged,
}

/// Payload class for [FastUserSettingsBlocEvent] containing optional properties
/// related to the event.
class FastUserSettingsBlocEventPayload {
  /// The primary currency code.
  final String? primaryCurrencyCode;

  /// The secondary currency code.
  final String? secondaryCurrencyCode;

  /// The save entry option.
  final bool? saveEntry;

  const FastUserSettingsBlocEventPayload({
    this.primaryCurrencyCode,
    this.secondaryCurrencyCode,
    this.saveEntry,
  });
}

/// Event class representing an event dispatched to the [FastUserSettingsBloc].
class FastUserSettingsBlocEvent extends BlocEvent<FastUserSettingsBlocEventType,
    FastUserSettingsBlocEventPayload> {
  /// Constructor for the [primaryCurrencyCodeChanged] event.
  FastUserSettingsBlocEvent.primaryCurrencyCodeChanged(
    String primaryCurrencyCode,
  ) : super(
          type: FastUserSettingsBlocEventType.primaryCurrencyCodeChanged,
          payload: FastUserSettingsBlocEventPayload(
            primaryCurrencyCode: primaryCurrencyCode,
          ),
        );

  /// Constructor for the [secondaryCurrencyCodeChanged] event.
  FastUserSettingsBlocEvent.secondaryCurrencyCodeChanged(
    String secondaryCurrencyCode,
  ) : super(
          type: FastUserSettingsBlocEventType.secondaryCurrencyCodeChanged,
          payload: FastUserSettingsBlocEventPayload(
            secondaryCurrencyCode: secondaryCurrencyCode,
          ),
        );

  /// Constructor for the [saveEntryChanged] event.
  FastUserSettingsBlocEvent.saveEntryChanged(bool saveEntry)
      : super(
          type: FastUserSettingsBlocEventType.saveEntryChanged,
          payload: FastUserSettingsBlocEventPayload(saveEntry: saveEntry),
        );

  /// Constructor for the [init] event.
  const FastUserSettingsBlocEvent.init()
      : super(type: FastUserSettingsBlocEventType.init);

  /// Constructor for the [initialized] event.
  FastUserSettingsBlocEvent.initialized({
    String? primaryCurrencyCode,
    String? secondaryCurrencyCode,
    bool? saveEntry,
  }) : super(
          type: FastUserSettingsBlocEventType.initialized,
          payload: FastUserSettingsBlocEventPayload(
            primaryCurrencyCode: primaryCurrencyCode,
            secondaryCurrencyCode: secondaryCurrencyCode,
            saveEntry: saveEntry,
          ),
        );
}
