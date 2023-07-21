// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_pricing/fastyle_pricing.dart';

class FastPremiumSettingsHeader extends StatelessWidget {
  final VoidCallback onGoPremium;

  const FastPremiumSettingsHeader({
    Key? key,
    required this.onGoPremium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final featuresBloc = BlocProvider.of<FastAppFeaturesBloc>(context);

    return BlocBuilderWidget(
      bloc: featuresBloc,
      builder: (BuildContext context, FastAppFeaturesBlocState state) {
        final isPremium = state.isFeatureEnabled(FastAppFeatures.premium);

        if (isPremium) {
          return FastPremiumPlanSummaryCard(
            footer: _buildFooter(
              PurchasesLocaleKeys.purchases_label_restore_purchases.tr(),
            ),
          );
        }

        return FastFreePlanSummaryCard(
          footer: _buildFooter(
            PurchasesLocaleKeys.purchases_label_go_premium.tr(),
          ),
        );
      },
    );
  }

  Widget _buildFooter(String linkText) {
    return FastLink(
      textAlign: TextAlign.center,
      onTap: onGoPremium,
      text: linkText,
    );
  }
}
