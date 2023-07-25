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
  final bool loading;

  const FastNativeAdLayout({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.icon,
    this.loading = false,
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
          Expanded(
            child: loading
                ? buildLoadingIndicator(context)
                : buildAdContent(context),
          ),
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
    return FastSmallNativeAdLayout(
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      icon: icon,
    );
  }

  Widget buildMediumAdContent() {
    return FastMediumNativeAdLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      icon: icon,
    );
  }

  Widget buildLargeAdContent() {
    return FastLargeNativeAdLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      icon: icon,
    );
  }

  Widget buildLoadingIndicator(BuildContext context) {
    return FastLoadingNativeAd(adSize: adSize);
  }
}
