// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';

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
