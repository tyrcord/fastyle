// Flutter imports:
import 'dart:async';

import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapPremiumPage extends StatefulWidget {
  final VoidCallback? onRestorePremium;
  final VoidCallback? onBuyPremium;
  final String? restorePremiumText;
  final String premiumProductId;
  final List<FastItem>? items;
  final bool shouldSortItems;
  final String? titleText;
  final bool showAppBar;
  final double iconSize;
  final Widget? icon;

  const FastIapPremiumPage({
    super.key,
    required this.premiumProductId,
    this.shouldSortItems = false,
    this.showAppBar = true,
    this.restorePremiumText,
    this.onRestorePremium,
    this.onBuyPremium,
    this.titleText,
    this.items,
    this.icon,
    double? iconSize,
  }) : iconSize = iconSize ?? 160;

  @override
  State<FastIapPremiumPage> createState() => _FastIapPremiumPageState();
}

class _FastIapPremiumPageState extends State<FastIapPremiumPage> {
  late StreamSubscription<FastPlanBlocState> errorSubscription;
  late final FastPlanBloc planBloc;

  @override
  void initState() {
    super.initState();
    planBloc = FastPlanBloc(getFeatureForPlan: handlePlanPurchased);
    errorSubscription = planBloc.onData
        .where((state) => state.error != null)
        .listen((state) => handleError(state.error));
  }

  @override
  void dispose() {
    super.dispose();
    planBloc.close();
    errorSubscription.cancel();
  }

  FastAppFeatures handlePlanPurchased(String planId) {
    return FastAppFeatures.premium;
  }

  void handleError(dynamic error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAnimatedFastAlertDialog(
        titleText: CoreLocaleKeys.core_label_error.tr(),
        validText: CoreLocaleKeys.core_label_ok.tr(),
        messageText: error.toString(),
        barrierDismissible: false,
        context: context,
        onValid: () {
          planBloc.addEvent(const FastPlanBlocEvent.resetError());
          Navigator.pop(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: planBloc,
      child: BlocBuilderWidget(
        buildWhen: (_, next) => next.isFeatureEnabled(FastAppFeatures.premium),
        bloc: BlocProvider.of<FastAppFeaturesBloc>(context),
        builder: (context, state) {
          if (state.isFeatureEnabled(FastAppFeatures.premium)) {
            return FastIapThankPremiumPage(
              restorePremiumText: widget.restorePremiumText,
              onRestorePremium: widget.onRestorePremium,
              premiumProductId: widget.premiumProductId,
              shouldSortItems: widget.shouldSortItems,
              showAppBar: widget.showAppBar,
              titleText: widget.titleText,
              iconSize: widget.iconSize,
              items: widget.items,
            );
          }

          return FastIapGoPremiumPage(
            premiumProductId: widget.premiumProductId,
            restorePremiumText: widget.restorePremiumText,
            onRestorePremium: widget.onRestorePremium,
            shouldSortItems: widget.shouldSortItems,
            onBuyPremium: widget.onBuyPremium,
            showAppBar: widget.showAppBar,
            titleText: widget.titleText,
            iconSize: widget.iconSize,
            items: widget.items,
          );
        },
      ),
    );
  }
}
