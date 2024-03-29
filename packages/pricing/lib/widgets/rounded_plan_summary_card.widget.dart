// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_pricing/widgets/widgets.dart';

abstract class FastRoundedPlanSummaryCard extends FastPlanSummaryCard {
  final FastPaletteScheme? palette;
  final Color? backgroundColor;
  final Color? iconColor;

  const FastRoundedPlanSummaryCard({
    super.key,
    super.titleColor,
    super.icon,
    super.footer,
    this.backgroundColor,
    this.iconColor,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return FastPlanSummaryCard(
      titleText: getTitleText(),
      iconBuilder: buildIcon,
      titleColor: titleColor,
      footer: footer,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    return FastRoundedDuotoneIcon(
      backgroundColor: backgroundColor,
      palette: getPalette(context),
      size: kFastImageSizeXxl,
      icon: getIcon(context),
      iconColor: iconColor,
    );
  }

  Widget getIcon(BuildContext context) {
    throw UnimplementedError();
  }

  String getTitleText();

  FastPaletteScheme getPalette(BuildContext context) {
    return palette ?? getDefaultPalette(context);
  }

  FastPaletteScheme getDefaultPalette(BuildContext context) {
    return ThemeHelper.getPaletteColors(context).blueGray;
  }
}
