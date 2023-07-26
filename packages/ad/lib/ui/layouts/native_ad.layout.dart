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
  final double? rating;

  const FastNativeAdLayout({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.icon,
    this.rating,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FastNativeAdContainerLayout(
      adSize: adSize,
      child: Stack(
        children: [
          Positioned.fill(
            child: loading
                ? buildLoadingIndicator(context)
                : buildAdContent(context),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: FastAdBadge(),
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
      rating: rating,
      icon: icon,
    );
  }

  Widget buildMediumAdContent() {
    return FastMediumNativeAdLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      rating: rating,
      icon: icon,
    );
  }

  Widget buildLargeAdContent() {
    return FastLargeNativeAdLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      rating: rating,
      icon: icon,
    );
  }

  Widget buildLoadingIndicator(BuildContext context) {
    return FastLoadingNativeAd(adSize: adSize);
  }
}
