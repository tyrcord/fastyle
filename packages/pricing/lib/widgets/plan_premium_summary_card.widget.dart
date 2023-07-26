// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_pricing/fastyle_pricing.dart';

class FastFreePlanSummaryCard extends FastRoundedPlanSummaryCard {
  const FastFreePlanSummaryCard({
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
    return const FaIcon(FontAwesomeIcons.bicycle);
  }

  @override
  String getTitleText() {
    return PurchasesLocaleKeys.purchases_label_free_version.tr();
  }
}