// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAd extends StatelessWidget {
  final FastAdSize adSize;
  final FastResponseAd ad;

  const FastNativeAd({
    super.key,
    required this.ad,
    this.adSize = FastAdSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    double? ranking;

    if (ad.ranking != null) {
      ranking = ad.ranking!.value * ad.ranking!.factor;
    }

    return GestureDetector(
      onTap: _openLink,
      child: FastNativeAdLayout(
        merchantLogoUrl: ad.merchant?.logo,
        descriptionText: ad.description,
        onButtonTap: _openLink,
        buttonText: ad.button,
        titleText: ad.title,
        icon: buildIcon(),
        ranking: ranking,
        adSize: adSize,
      ),
    );
  }

  Widget buildIcon() {
    String? imageUrl;

    if (adSize == FastAdSize.small) {
      imageUrl = ad.image.small;
    } else if (adSize == FastAdSize.medium) {
      imageUrl = ad.image.medium;
    } else if (adSize == FastAdSize.large) {
      imageUrl = ad.image.large;
    }

    if (imageUrl != null) {
      return FastShadowLayout(
        borderRadius: 4,
        child: Center(
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _openLink() {
    FastMessenger.launchUrl(
      ad.url,
      mode: LaunchMode.externalApplication,
    );
  }
}
