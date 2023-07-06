import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

/// Represents the state of the `FastUserSettingsBloc`.
class FastUserSettingsBlocState extends BlocState {
  /// The primary currency code.
  final String primaryCurrencyCode;

  /// The secondary currency code.
  final String? secondaryCurrencyCode;

  /// Indicates whether the user's entry should be saved or not.
  final bool saveEntry;

  /// Creates a new instance of [FastUserSettingsBlocState].
  ///
  /// The [isInitializing] and [isInitialized] properties are inherited from
  /// the [BlocState] class.
  FastUserSettingsBlocState({
    super.isInitializing,
    super.isInitialized,
    this.secondaryCurrencyCode,
    String? primaryCurrencyCode,
    bool? saveEntry,
  })  : primaryCurrencyCode =
            primaryCurrencyCode ?? kFastUserSettingPrimaryCurrencyCode,
        saveEntry = saveEntry ?? kFastUserSettingSaveEntry;

  @override
  FastUserSettingsBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    String? primaryCurrencyCode,
    String? secondaryCurrencyCode,
    bool? saveEntry,
  }) =>
      FastUserSettingsBlocState(
        isInitializing: isInitializing ?? this.isInitializing,
        isInitialized: isInitialized ?? this.isInitialized,
        primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
        secondaryCurrencyCode:
            secondaryCurrencyCode ?? this.secondaryCurrencyCode,
        saveEntry: saveEntry ?? this.saveEntry,
      );

  @override
  FastUserSettingsBlocState clone() => copyWith();

  @override
  FastUserSettingsBlocState merge(covariant FastUserSettingsBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      primaryCurrencyCode: model.primaryCurrencyCode,
      secondaryCurrencyCode: model.secondaryCurrencyCode,
      saveEntry: model.saveEntry,
    );
  }

  @override
  List<Object?> get props => [
        isInitializing,
        isInitialized,
        primaryCurrencyCode,
        secondaryCurrencyCode,
        saveEntry,
      ];
}
