import 'package:fastyle_pricing/fastyle_pricing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

class FastPremiumPlanSummaryCard extends FastRoundedPlanSummaryCard {
  const FastPremiumPlanSummaryCard({
    super.key,
    super.titleColor,
    super.footer,
    super.backgroundColor,
    super.iconColor,
    super.palette,
    super.icon,
  });

  @override
  Widget getIcon(BuildContext context) {
    return const FaIcon(FontAwesomeIcons.rocket);
  }

  @override
  String getTitleText() {
    return PurchasesLocaleKeys.purchases_label_premium.tr();
  }
}
