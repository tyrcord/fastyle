// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';

class FastFinanceInvestDisclaimer extends StatelessWidget {
  final double? fontSize;

  const FastFinanceInvestDisclaimer({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return FastAppSettingsLanguageBuilder(
      builder: (context, state) {
        return FastParagraph(
          child: FastSecondaryBody(
            text: FinanceLocaleKeys.finance_disclaimer_intervening_markets.tr(),
            fontSize: fontSize ?? kFastFontSize10,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
