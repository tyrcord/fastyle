// Flutter imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
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
        descriptionText: ad.description,
        buttonText: ad.button,
        titleText: ad.title,
        icon: buildIcon(),
        ranking: ranking,
        adSize: adSize,
        onButtonTap: _openLink,
      ),
    );
  }

  Widget buildIcon() {
    return FastShadowLayout(
      borderRadius: 4,
      child: Center(
        child: Image.network(ad.image.medium, fit: BoxFit.contain),
      ),
    );
  }

  void _openLink() {
    FastMessenger.launchUrl(
      ad.url,
      mode: LaunchMode.externalApplication,
    );
  }
}
