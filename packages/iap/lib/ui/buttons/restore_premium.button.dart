// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

/// Represents a button that provides functionality for restoring
/// in-app premium purchases.
class FastIapRestorePremiumButton extends StatelessWidget {
  /// Callback triggered when the button is tapped.
  final VoidCallback? onTap;

  /// Label text to be displayed on the button.
  final String? labelText;

  /// Product ID for the premium product.
  final String? premiumProductId;

  /// Emphasis style for the button.
  final FastButtonEmphasis emphasis;

  /// Creates a new instance of [FastIapRestorePremiumButton].
  ///
  /// [emphasis] defaults to [FastButtonEmphasis.low] if not provided.
  const FastIapRestorePremiumButton({
    super.key,
    this.premiumProductId,
    this.labelText,
    this.onTap,
    this.emphasis = FastButtonEmphasis.low,
  });

  /// Handles the tap event for the button.
  ///
  /// Sends a `restorePlan` event to [FastPlanBloc] and invokes [onTap]
  /// callback if provided.
  void handleOnTap(BuildContext context) {
    final bloc = BlocProvider.of<FastPlanBloc>(context);
    bloc.addEvent(FastPlanBlocEvent.restorePlan(_getPremiumProductId()));
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FastStorePlanBuilder(
      onlyWhenProductsChanges: true,
      builder: (_, state) {
        final products = state.products;
        final product = getProductDetails(products, _getPremiumProductId());

        if (product != null) {
          return FastIapPlanBuilder(builder: buildButton);
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the restore purchase button based on the emphasis style.
  Widget buildButton(BuildContext context, FastPlanBlocState state) {
    if (emphasis == FastButtonEmphasis.high) {
      return buildHighEmphasisButton(context, state);
    }

    return buildLowEmphasisButton(context, state);
  }

  /// Builds the button with high emphasis styling.
  Widget buildHighEmphasisButton(
    BuildContext context,
    FastPlanBlocState state,
  ) {
    return FastPendingRaisedButton(
      isEnabled: state.isInitialized && !state.isPlanPurchasePending,
      onTap: () => handleOnTap(context),
      isPending: state.isRestoringPlan,
      labelText: _getLabelText(),
    );
  }

  /// Builds the button with low emphasis styling.
  Widget buildLowEmphasisButton(
    BuildContext context,
    FastPlanBlocState state,
  ) {
    return FastPendingOutlinedButton(
      isEnabled: state.isInitialized && !state.isPlanPurchasePending,
      onTap: () => handleOnTap(context),
      isPending: state.isRestoringPlan,
      labelText: _getLabelText(),
    );
  }

  /// Returns the label text for the button. Uses a default label if
  /// [labelText] is not provided.
  String _getLabelText() {
    return labelText ??
        PurchasesLocaleKeys.purchases_label_restore_purchases.tr();
  }

  /// Returns the product ID for the premium product. Throws an assertion error
  /// if the product ID is not provided and cannot be fetched.
  String _getPremiumProductId() {
    final id = premiumProductId ?? getPremiumProductId();
    assert(id != null, 'The premium product id must not be null');

    return id!;
  }
}
