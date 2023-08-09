// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapRestorePremiumButtton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? labelText;
  final String premiumProductId;
  final FastButtonEmphasis emphasis;

  const FastIapRestorePremiumButtton({
    super.key,
    required this.premiumProductId,
    this.labelText,
    this.onTap,
    this.emphasis = FastButtonEmphasis.low,
  });

  void handleOnTap(BuildContext context) {
    final bloc = BlocProvider.of<FastPlanBloc>(context);
    bloc.addEvent(FastPlanBlocEvent.restorePlan(premiumProductId));
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FastStorePlanBuilder(
      onlyWhenProductsChanges: true,
      builder: (_, state) {
        final products = state.products;
        final product = getProductDetails(products, premiumProductId);

        if (product != null) {
          return FastIapPlanBuilder(builder: buildButton);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget buildButton(BuildContext context, FastPlanBlocState state) {
    if (emphasis == FastButtonEmphasis.high) {
      return FastPendingRaisedButton(
        isEnabled: state.isInitialized && !state.isPlanPurcharsePending,
        onTap: () => handleOnTap(context),
        isPending: state.isRestoringPlan,
        text: _getLabelText(),
      );
    }

    return FastPendingOutlineButton(
      isEnabled: state.isInitialized && !state.isPlanPurcharsePending,
      onTap: () => handleOnTap(context),
      isPending: state.isRestoringPlan,
      text: _getLabelText(),
    );
  }

  String _getLabelText() {
    return labelText ??
        PurchasesLocaleKeys.purchases_label_restore_purchases.tr();
  }
}
