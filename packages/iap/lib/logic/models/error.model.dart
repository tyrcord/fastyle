import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

class FastIapError {
  static const int noPurchasesFound = 0;

  final int code;

  const FastIapError(this.code);

  @override
  String toString() {
    switch (code) {
      case noPurchasesFound:
        return PurchasesLocaleKeys.purchases_error_no_purchases_to_restore.tr();
      default:
        return CoreLocaleKeys.core_error_error_occurred.tr();
    }
  }
}
