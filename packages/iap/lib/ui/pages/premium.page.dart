// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

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
  });

  @override
  State<FastIapPremiumPage> createState() => _FastIapPremiumPageState();
}

class _FastIapPremiumPageState extends State<FastIapPremiumPage>
    with FastPremiumPlanMixin {
  late StreamSubscription<FastPlanBlocState> errorSubscription;
  late final FastPlanBloc planBloc;
  final _storeBloc = FastStoreBloc();

  @override
  void initState() {
    super.initState();
    planBloc = FastPlanBloc(getFeaturesForPlan: getFeaturesForPlan);
    errorSubscription =
        planBloc.onData.where((state) => state.error != null).listen((state) {
      if (context.mounted && mounted) {
        handleError(context, planBloc, state.error);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    planBloc.close();
    errorSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: planBloc,
      child: BlocBuilderWidget(
        buildWhen: (_, next) {
          return next.hasPurchasedProduct(widget.premiumProductId);
        },
        bloc: _storeBloc,
        builder: (context, state) {
          if (state.hasPurchasedProduct(widget.premiumProductId)) {
            return FastIapThankPremiumPage(
              restorePremiumText: widget.restorePremiumText,
              onRestorePremium: widget.onRestorePremium,
              premiumProductId: widget.premiumProductId,
              shouldSortItems: widget.shouldSortItems,
              showAppBar: widget.showAppBar,
              titleText: widget.titleText,
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
            items: widget.items,
          );
        },
      ),
    );
  }
}
