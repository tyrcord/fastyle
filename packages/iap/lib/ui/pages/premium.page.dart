// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
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

  const FastIapPremiumPage({
    super.key,
    required this.premiumProductId,
    this.shouldSortItems = false,
    this.showAppBar = false,
    this.restorePremiumText,
    this.onRestorePremium,
    this.onBuyPremium,
    this.titleText,
    this.items,
  });

  @override
  State<FastIapPremiumPage> createState() => _FastIapPremiumPageState();
}

class _FastIapPremiumPageState extends State<FastIapPremiumPage> {
  late final FastPlanBloc planBloc;

  @override
  void initState() {
    super.initState();

    planBloc = FastPlanBloc(onPlanPurchased: handlePlanPurchased);
  }

  @override
  void dispose() {
    super.dispose();
    planBloc.close();
  }

  FastAppFeatures handlePlanPurchased(String planId) {
    // planBloc.handlePlanPurchased(planId);

    return FastAppFeatures.premium;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: planBloc,
      child: FastSectionPage(
        titleText: _getTitleText(),
        showAppBar: widget.showAppBar,
        isViewScrollable: false,
        // FIXME: FastSectionPage layout should be a stack, content is
        // displayed behind the footer.
        footerBuilder: buildFooter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDescription(context),
            buildFeaturesList(),
            buildBackgroundDecoration(context),
          ],
        ),
      ),
    );
  }

  Widget buildDescription(BuildContext context) {
    final padding = ThemeHelper.spacing.getVerticalPadding(context);

    return Padding(
      padding: padding,
      child: FastBody(
        text: PurchasesLocaleKeys.purchases_message_go_premium_description.tr(),
      ),
    );
  }

  Widget buildBackgroundDecoration(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);
    final padding = ThemeHelper.spacing.getVerticalPadding(context);

    return Container(
      padding: padding,
      alignment: Alignment.centerRight,
      child: Icon(FontAwesomeIcons.solidStar, color: palette.orange.lighter),
    );
  }

  Widget buildFeaturesList() {
    if (widget.items != null && widget.items!.isNotEmpty) {
      return FastListView(
        listItemBuilder: buildFeatureListItem,
        sortItems: widget.shouldSortItems,
        items: widget.items!,
      );
    }

    return const SizedBox.shrink();
  }

  Widget buildFeatureListItem(BuildContext context, FastItem item, int index) {
    return Padding(
      padding: kFastVerticalEdgeInsets12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item.descriptor?.leading != null)
            buildIcon(item.descriptor!.leading!),
          Expanded(child: FastBody(text: item.labelText)),
        ],
      ),
    );
  }

  //TODO: add color to descriptor
  Widget buildIcon(Widget icon) {
    if (icon is FaIcon) {
      icon = FaIcon(
        icon.icon,
        color: ThemeHelper.colors.getPrimaryColor(context),
        size: kFastIconSizeSmall,
      );
    } else if (icon is Icon) {
      icon = Icon(
        icon.icon,
        color: ThemeHelper.colors.getPrimaryColor(context),
        size: kFastIconSizeSmall,
      );
    }

    return SizedBox(width: 40.0, child: icon);
  }

  Widget buildFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FastOutlineButton(
          text: _getRestorePremiumText(),
          // isPending: state.isRestoringPurchases,
          onTap: () {
            widget.onRestorePremium?.call();
          },
        ),
        FastIapPurchasePremiumButtton(
          premiumProductId: widget.premiumProductId,
          onTap: widget.onBuyPremium,
        ),
      ],
    );
  }

  String _getTitleText() {
    return widget.titleText ??
        PurchasesLocaleKeys.purchases_label_go_premium.tr();
  }

  String _getRestorePremiumText() {
    return widget.restorePremiumText ??
        PurchasesLocaleKeys.purchases_label_restore_purchases.tr();
  }
}
