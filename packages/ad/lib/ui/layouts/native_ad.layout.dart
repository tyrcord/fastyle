// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdLayout extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? merchantLogoUrl;
  final FastAdSize adSize;
  final String? titleText;
  final String? buttonText;
  final Widget? icon;
  final bool loading;
  final double? ranking;
  final bool showAdBadge;

  const FastNativeAdLayout({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.icon,
    this.ranking,
    this.merchantLogoUrl,
    this.loading = false,
    this.showAdBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final content =
        loading ? buildLoadingIndicator(context) : buildAdContent(context);

    if (showAdBadge) {
      return FastNativeAdContainerLayout(
        adSize: adSize,
        child: Stack(
          children: [
            Positioned.fill(child: content),
            const Align(
              alignment: Alignment.topLeft,
              child: FastAdBadge(),
            ),
          ],
        ),
      );
    }

    return FastNativeAdContainerLayout(adSize: adSize, child: content);
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
      rating: ranking,
      icon: icon,
    );
  }

  Widget buildMediumAdContent() {
    return FastMediumNativeAdLayout(
      descriptionText: descriptionText,
      merchantLogoUrl: merchantLogoUrl,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      rating: ranking,
      icon: icon,
    );
  }

  Widget buildLargeAdContent() {
    return FastLargeNativeAdLayout(
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      rating: ranking,
      icon: icon,
    );
  }

  Widget buildLoadingIndicator(BuildContext context) {
    return FastLoadingNativeAd(adSize: adSize);
  }
}
