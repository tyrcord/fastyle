import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class FastPlanSummaryCard extends StatelessWidget {
  final double maxIconContainerHeight;
  final double minIconContainerHeight;
  final WidgetBuilder? iconBuilder;
  final String? titleText;
  final Color? titleColor;
  final Widget? footer;
  final Widget? icon;

  const FastPlanSummaryCard({
    Key? key,
    this.maxIconContainerHeight = 128,
    this.minIconContainerHeight = 0,
    this.iconBuilder,
    this.titleText,
    this.titleColor,
    this.icon,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastShadowLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (titleText != null)
            FastPadding8(
              child: FastTitle(
                text: titleText!,
                textColor: titleColor,
                textAlign: TextAlign.center,
                fontWeight: kFastFontWeightSemiBold,
              ),
            ),
          Container(
            constraints: BoxConstraints(
              minHeight: minIconContainerHeight,
              maxHeight: maxIconContainerHeight,
            ),
            child: iconBuilder != null ? Builder(builder: iconBuilder!) : icon,
          ),
          kFastSizedBox8,
          if (footer != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FastDivider(color: ThemeHelper.colors.getShadowColor(context)),
                FastPadding8(child: footer!),
              ],
            ),
        ],
      ),
    );
  }
}
