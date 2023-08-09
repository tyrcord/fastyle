// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapThankPremiumPage extends StatelessWidget {
  final VoidCallback? onRestorePremium;
  final String? restorePremiumText;
  final String premiumProductId;
  final List<FastItem>? items;
  final bool shouldSortItems;
  final String? titleText;
  final bool showAppBar;
  final Widget? icon;

  const FastIapThankPremiumPage({
    super.key,
    required this.premiumProductId,
    this.shouldSortItems = false,
    this.showAppBar = true,
    this.restorePremiumText,
    this.onRestorePremium,
    this.titleText,
    this.items,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // FIXME: FastSectionPage layout should be a stack, content is
    // displayed behind the footer.
    return FastSectionPage(
      titleText: _getTitleText(),
      showAppBar: showAppBar,
      isViewScrollable: false,
      footerBuilder: buildFooter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildRocketIcon(context),
          ThemeHelper.spacing.getVerticalSpacing(context),
          buildDescription(context),
          buildBackgroundDecoration(context),
        ],
      ),
    );
  }

  Widget buildRocketIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    final palette = ThemeHelper.getPaletteColors(context).green;

    if (useProIcons) {
      return FastPageHeaderRoundedDuotoneIconLayout(
        icon: const FaIcon(FastFontAwesomeIcons.lightRocketLaunch),
        palette: palette,
      );
    }

    return FastPageHeaderRoundedDuotoneIconLayout(
      icon: const FaIcon(FontAwesomeIcons.rocket),
      palette: palette,
    );
  }

  Widget buildDescription(BuildContext context) {
    final padding = ThemeHelper.spacing.getVerticalPadding(context);

    return Padding(
      padding: padding,
      child: FastBody(
        text: PurchasesLocaleKeys.purchases_message_enjoy_premium_version.tr(),
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

  Widget buildFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FastIapRestorePremiumButtton(
          premiumProductId: premiumProductId,
          onTap: onRestorePremium,
        ),
      ],
    );
  }

  String _getTitleText() {
    return titleText ?? PurchasesLocaleKeys.purchases_label_premium.tr();
  }
}
