import 'package:fastyle_financial/fastyle_financial.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

/// Gets the locale key for a given financial frequency.
String getLocaleKeyForFinancialFrequency(FastFinancialFrequency frequency) {
  switch (frequency) {
    case FastFinancialFrequency.annually:
      return CoreLocaleKeys.core_label_annually;
    case FastFinancialFrequency.semiAnnually:
      return CoreLocaleKeys.core_label_semi_annually;
    case FastFinancialFrequency.quarterly:
      return CoreLocaleKeys.core_label_quarterly;
    default:
      return CoreLocaleKeys.core_label_monthly;
  }
}

/// Converts a string representation of a frequency to its corresponding enum value.
FastFinancialFrequency parseFinancialFrequencyFromString(String key) {
  try {
    return FastFinancialFrequency.values.firstWhere(
      (value) => value.name == key,
      orElse: () => FastFinancialFrequency.annually,
    );
  } catch (e) {
    return FastFinancialFrequency.annually;
  }
}
