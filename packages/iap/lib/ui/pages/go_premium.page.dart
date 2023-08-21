// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapGoPremiumPage extends StatelessWidget {
  final VoidCallback? onRestorePremium;
  final VoidCallback? onBuyPremium;
  final String? restorePremiumText;
  final String? premiumProductId;
  final List<FastItem>? items;
  final bool shouldSortItems;
  final String? titleText;
  final bool showAppBar;
  final Widget? icon;
  final String? notesText;

  const FastIapGoPremiumPage({
    super.key,
    this.premiumProductId,
    this.shouldSortItems = false,
    this.showAppBar = true,
    this.restorePremiumText,
    this.onRestorePremium,
    this.onBuyPremium,
    this.notesText,
    this.titleText,
    this.items,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: _getTitleText(),
      showAppBar: showAppBar,
      isViewScrollable: true,
      footerBuilder: buildFooter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTreasureIcon(context),
          ThemeHelper.spacing.getVerticalSpacing(context),
          buildDescription(context),
          buildFeaturesList(),
          buildBackgroundDecoration(context),
          FastSecondaryBody(
            text: notesText ??
                PurchasesLocaleKeys.purchases_message_one_time_payment.tr(),
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget buildTreasureIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    final palette = ThemeHelper.getPaletteColors(context).purple;

    if (useProIcons) {
      return FastPageHeaderRoundedDuotoneIconLayout(
        icon: const FaIcon(FastFontAwesomeIcons.lightTreasureChest),
        palette: palette,
      );
    }

    return FastPageHeaderRoundedDuotoneIconLayout(
      icon: const FaIcon(FontAwesomeIcons.gem),
      palette: palette,
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
    final padding = ThemeHelper.spacing.getVerticalPadding(context);

    return Container(
      padding: padding,
      alignment: Alignment.centerRight,
      child: buildStarIcon(context),
    );
  }

  Widget buildStarIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    final palettes = ThemeHelper.getPaletteColors(context);
    late final IconData iconData;

    if (useProIcons) {
      iconData = FastFontAwesomeIcons.solidStars;
    } else {
      iconData = FontAwesomeIcons.solidStar;
    }

    return FaIcon(iconData, color: palettes.orange.lighter);
  }

  Widget buildFeaturesList() {
    if (items != null && items!.isNotEmpty) {
      return FastListView(
        listItemBuilder: buildFeatureListItem,
        sortItems: shouldSortItems,
        items: items!,
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
            buildFeatureListItemIcon(context, item.descriptor!.leading!),
          Expanded(child: FastBody(text: item.labelText)),
        ],
      ),
    );
  }

  //TODO: add color to descriptor
  Widget buildFeatureListItemIcon(BuildContext context, Widget icon) {
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
        FastIapRestorePremiumButtton(onTap: onRestorePremium),
        FastIapPurchasePremiumButtton(onTap: onBuyPremium),
      ],
    );
  }

  String _getTitleText() {
    return titleText ?? PurchasesLocaleKeys.purchases_label_go_premium.tr();
  }
}
