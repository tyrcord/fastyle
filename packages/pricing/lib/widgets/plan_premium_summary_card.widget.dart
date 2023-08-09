// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_pricing/fastyle_pricing.dart';

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
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightRocketLaunch);
    }

    return const FaIcon(FontAwesomeIcons.rocket);
  }

  @override
  String getTitleText() {
    return PurchasesLocaleKeys.purchases_label_premium.tr();
  }

  @override
  FastPaletteScheme getDefaultPalette(BuildContext context) {
    return ThemeHelper.getPaletteColors(context).green;
  }
}
