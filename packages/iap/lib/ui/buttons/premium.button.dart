// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapPurchasePremiumButtton extends StatelessWidget {
  final VoidCallback? onTap;
  final String premiumProductId;
  final String? labelText;

  const FastIapPurchasePremiumButtton({
    super.key,
    required this.premiumProductId,
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FastStorePlanBuilder(
      onlyWhenProductsChanges: true,
      builder: (_, storeState) {
        final products = storeState.products;
        final product = getProductDetails(products, premiumProductId);

        if (product != null) {
          return FastIapPlanBuilder(
            builder: (context, state) {
              return buildButton(context, state, product);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget buildButton(
    BuildContext context,
    FastPlanBlocState state,
    ProductDetails product,
  ) {
    if (!state.hasPurchasedPlan) {
      return FastPendingRaisedButton(
        isEnabled: state.isInitialized && !state.isRestoringPlan,
        isPending: state.isPlanPurcharsePending,
        text: _getLabelText(product),
        onTap: () {
          final bloc = BlocProvider.of<FastPlanBloc>(context);
          bloc.addEvent(FastPlanBlocEvent.purchasePlan(premiumProductId));
          onTap?.call();
        },
      );
    }

    return const SizedBox.shrink();
  }

  String _getLabelText(ProductDetails product) {
    return labelText ??
        PurchasesLocaleKeys.purchases_label_premium_price.tr(
          namedArgs: {'price': product.price},
        );
  }
}
