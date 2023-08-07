// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';

class FastFinanceInvestDisclaimer extends StatelessWidget {
  const FastFinanceInvestDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return FastParagraph(
      child: FastSecondaryBody(
        text: FinanceLocaleKeys.finance_disclaimer_intervening_markets.tr(),
        textAlign: TextAlign.center,
      ),
    );
  }
}
