// Package imports:
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_financial/fastyle_financial.dart';

/// Gets the locale key for a given financial frequency.
String getLocaleKeyForFinancialFrequency(FastFinancialFrequency frequency) {
  switch (frequency) {
    case FastFinancialFrequency.annually:
      return CoreLocaleKeys.core_label_annually;
    case FastFinancialFrequency.semiAnnually:
      return CoreLocaleKeys.core_label_semi_annually;
    case FastFinancialFrequency.quarterly:
      return CoreLocaleKeys.core_label_quarterly;
    case FastFinancialFrequency.monthly:
      return CoreLocaleKeys.core_label_monthly;
    case FastFinancialFrequency.weekly:
      return CoreLocaleKeys.core_label_weekly;
    default:
      return CoreLocaleKeys.core_label_daily;
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
