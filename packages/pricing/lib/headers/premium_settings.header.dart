// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_pricing/fastyle_pricing.dart';

class FastPremiumSettingsHeader extends StatelessWidget {
  final _storeBloc = FastStoreBloc();
  final VoidCallback onGoPremium;
  final String? premiumProductId;

  FastPremiumSettingsHeader({
    super.key,
    this.premiumProductId,
    required this.onGoPremium,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: _storeBloc,
      builder: (context, state) {
        final isPremium = state.hasPurchasedProduct(_getPremiumProductId());

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

  String _getPremiumProductId() {
    String? id = premiumProductId;
    id ??= getPremiumProductId();

    assert(id != null, 'The premium product id must not be null');

    return id!;
  }
}
