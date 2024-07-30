// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

/// Represents a button that provides functionality for purchasing
/// the in-app premium product.
class FastIapPurchasePremiumButtton extends StatelessWidget {
  /// Callback triggered when the button is tapped.
  final VoidCallback? onTap;

  /// Product ID for the premium product.
  final String? premiumProductId;

  /// Label text to be displayed on the button.
  final String? labelText;

  /// Bloc that manages application plans.
  final FastPlanBloc? planBloc;

  /// Creates a new instance of [FastIapPurchasePremiumButtton].
  const FastIapPurchasePremiumButtton({
    super.key,
    this.premiumProductId,
    this.labelText,
    this.onTap,
    this.planBloc,
  });

  @override
  Widget build(BuildContext context) {
    return FastStorePlanBuilder(
      onlyWhenProductsChanges: true,
      builder: (_, storeState) {
        final products = storeState.products;
        final product = getProductDetails(products, _getPremiumProductId());

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

  /// Builds the purchase button if the user hasn't purchased the plan,
  /// otherwise returns an empty widget.
  Widget buildButton(
    BuildContext context,
    FastPlanBlocState state,
    ProductDetails product,
  ) {
    if (!state.hasPurchasedPlan) {
      return _buildPurchaseButton(context, state, product);
    }

    return const SizedBox.shrink();
  }

  /// Creates a button to initiate the purchase process.
  Widget _buildPurchaseButton(
    BuildContext context,
    FastPlanBlocState state,
    ProductDetails product,
  ) {
    return FastPendingRaisedButton(
      isEnabled: state.isInitialized && !state.isRestoringPlan,
      isPending: state.isPlanPurchasePending,
      labelText: _getLabelText(product),
      onTap: () {
        final bloc = planBloc ?? BlocProvider.of<FastPlanBloc>(context);
        bloc.addEvent(FastPlanBlocEvent.purchasePlan(_getPremiumProductId()));
        onTap?.call();
      },
    );
  }

  /// Returns the label text for the button, displaying the product price.
  /// Uses a default label if [labelText] is not provided.
  String _getLabelText(ProductDetails product) {
    return labelText ??
        PurchasesLocaleKeys.purchases_label_premium_price.tr(
          namedArgs: {'price': product.price},
        );
  }

  /// Returns the product ID for the premium product. Throws an assertion error
  /// if the product ID is not provided and cannot be fetched.
  String _getPremiumProductId() {
    final id = premiumProductId ?? getPremiumProductId();
    assert(id != null, 'The premium product id must not be null');

    return id!;
  }
}
