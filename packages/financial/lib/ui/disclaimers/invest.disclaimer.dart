// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';

class FastFinanceInvestDisclaimer extends StatelessWidget {
  final double? fontSize;
  final bool shortVersion;

  const FastFinanceInvestDisclaimer({
    super.key,
    this.fontSize,
    this.shortVersion = true,
  });

  @override
  Widget build(BuildContext context) {
    return FastAppSettingsLanguageBuilder(
      builder: (context, state) {
        return FastParagraph(
          child: FastSecondaryBody(
            text: _getDisclaimerText(context),
            fontSize: fontSize ?? kFastFontSize10,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  String _getDisclaimerText(BuildContext context) {
    if (shortVersion) {
      return FinanceLocaleKeys.finance_disclaimer_intervening_markets.tr();
    }

    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;

    return FinanceLocaleKeys.finance_disclaimer_trading.tr(namedArgs: {
      'company': appInfo.appAuthor,
    }).tr();
  }
}
