import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdLayout extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final FastAdSize adSize;
  final String? titleText;
  final String? buttonText;
  final Widget? icon;

  const FastNativeAdLayout({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final divider = adSize > FastAdSize.small
        ? kFastVerticalSizedBox8
        : kFastVerticalSizedBox4;

    return FastNativeAdContainerLayout(
      adSize: adSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FastAdBadge(),
          divider,
          Expanded(child: buildAdContent(context)),
        ],
      ),
    );
  }

  Widget buildAdContent(BuildContext context) {
    if (adSize == FastAdSize.small) {
      return buildSmallAdContent();
    } else if (adSize == FastAdSize.medium) {
      return buildMediumAdContent();
    }

    return buildLargeAdContent();
  }

  Widget buildSmallAdContent() {
    return FastNativeAdSmallLayout(
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      adSize: adSize,
      icon: icon,
    );
  }

  Widget buildMediumAdContent() {
    return FastNativeAdMediumLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      adSize: adSize,
      icon: icon,
    );
  }

  Widget buildLargeAdContent() {
    return FastNativeAdLargeLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      adSize: adSize,
      icon: icon,
    );
  }
}
