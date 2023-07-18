import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FastFinanceInvestDisclaimerPage extends StatelessWidget {
  const FastFinanceInvestDisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSettingsDisclaimerPage(
      children: [
        FastParagraph(
          text: FinanceLocaleKeys.finance_disclaimer_invest_warning.tr(),
        ),
      ],
    );
  }
}
