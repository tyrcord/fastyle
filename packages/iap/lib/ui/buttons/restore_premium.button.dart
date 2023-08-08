// Flutter imports:
import 'package:fastyle_core/ui/ui.dart';
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

  const FastIapRestorePremiumButtton({
    super.key,
    required this.premiumProductId,
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FastStorePlanBuilder(
      onlyWhenProductsChanges: true,
      builder: (_, state) {
        final products = state.products;
        final product = getProductDetails(products, premiumProductId);

        if (state.hasError) {
          handleError(context, state.error);
        }

        if (product != null) {
          return FastIapPlanBuilder(builder: buildButton);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget buildButton(BuildContext context, FastPlanBlocState state) {
    if (state.hasError) {
      handleError(context, state.error);
    }

    return FastPendingOutlineButton(
      isEnabled: state.isInitialized,
      text: _getRestorePremiumText(),
      isPending: state.isRestoringPlan,
      onTap: () {
        final bloc = BlocProvider.of<FastPlanBloc>(context);
        bloc.addEvent(FastPlanBlocEvent.restorePlan(premiumProductId));
        onTap?.call();
      },
    );
  }

  void handleError(BuildContext context, dynamic error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAnimatedFastAlertDialog(
        context: context,
        titleText: 'Error',
        messageText: error.toString(),
        validText: 'OK',
      );
    });
  }

  String _getRestorePremiumText() {
    return labelText ??
        PurchasesLocaleKeys.purchases_label_restore_purchases.tr();
  }
}
