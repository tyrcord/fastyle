// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

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

    final palettes = ThemeHelper.getPaletteColors(context);

    return FastRoundedDuotoneIcon(
      icon: getIcon(context),
      palette: palette ?? palettes.blueGray,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      size: kFastImageSizeXxl,
    );
  }

  Widget getIcon(BuildContext context) {
    throw UnimplementedError();
  }

  String getTitleText();
}
