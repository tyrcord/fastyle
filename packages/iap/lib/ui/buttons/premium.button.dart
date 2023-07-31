import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:flutter/widgets.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:tbloc/tbloc.dart';

class FastIapPurchasePremiumButtton extends StatelessWidget {
  final VoidCallback? onTap;
  final String premiumProductId;

  const FastIapPurchasePremiumButtton({
    super.key,
    required this.premiumProductId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FastStorePlanBuilder(builder: (_, storeState) {
      final products = storeState.products;
      final product = getProductDetails(products, premiumProductId);

      if (product != null) {
        return FastIapPlanBuilder(builder: (context, state) {
          if (!state.hasPurchasedPlan && state.isInitialized) {
            return FastPendingRaisedButton(
              text: PurchasesLocaleKeys.purchases_label_premium_price.tr(
                namedArgs: {'price': product.price},
              ),
              isPending: state.isPlanPurcharsePending,
              onTap: () {
                final bloc = BlocProvider.of<FastPlanBloc>(context);

                bloc.addEvent(FastPlanBlocEvent.purchasePlan(premiumProductId));

                onTap?.call();
              },
            );
          }

          return const SizedBox.shrink();
        });
      }

      return const SizedBox.shrink();
    });
  }
}
