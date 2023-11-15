import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_finance_forex/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

String getLabelTextForInstrumentType(String type) {
  switch (type) {
    case 'indices':
      return FinanceLocaleKeys.finance_label_indices.tr();
    case 'commodities':
      return FinanceForexLocaleKeys.forex_label_commodities.tr();
    case 'cryptos':
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
