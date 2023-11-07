import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_finance_forex/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:matex_dart/matex_dart.dart' show MatexPairMetadata;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_units/lingua_units.dart';

String getLabelTextForInstrumentType(String type) {
  switch (type) {
    case 'indices':
      return FinanceLocaleKeys.finance_label_indices.tr();
    case 'commodities':
      return FinanceForexLocaleKeys.forex_label_commodities.tr();
    case 'cryptocurrencies':
      return FinanceForexLocaleKeys.forex_label_cryptos.tr();
    case 'majors':
      return CoreLocaleKeys.core_label_majors.tr();
    case 'minors':
      return CoreLocaleKeys.core_label_minors.tr();
    case 'exotics':
      return CoreLocaleKeys.core_label_exotics.tr();
    default:
      // TODO: Ideally, log this unexpected key for debugging purposes.
      return '';
  }
}

/// Localizes the lot size based on the provided metadata and lot size.
///
/// This function takes a `MatexPairMetadata` object and a lot size,
/// and returns a localized string representation of the lot size,
/// using the appropriate unit of measurement if available.
///
/// - Parameters:
///   - metadata: Metadata containing the lot size information.
///   - lotSize: The numerical size of the lot to be localized.
/// - Returns: A string representation of the localized lot size, or
///   null if no localization is possible.
String? localizeLotSize({
  required MatexPairMetadata metadata,
  required int lotSize,
}) {
  String? text;

  if (metadata.lots != null) {
    final unitKey = metadata.lots!.unit.key;

    text = localizeUnitSize(
      localeCode: FastAppSettingsBloc.instance.currentState.localeCode,
      unitKey: unitKey,
      value: lotSize,
    );
  }

  return text;
}
