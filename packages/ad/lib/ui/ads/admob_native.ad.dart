import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

import 'package:fastyle_ad/fastyle_ad.dart';

// TODO: support more native ad heights
class FastAdmobAdNative extends StatefulWidget {
  final FastAdSize adSize;
  final NativeAd? adView;

  const FastAdmobAdNative({
    super.key,
    required this.adView,
    this.adSize = FastAdSize.medium,
  }) : assert(
          adSize == FastAdSize.medium,
          'Only support native ad with a height of 100px',
        );

  @override
  FastAdmobAdNativeState createState() => FastAdmobAdNativeState();
}

class FastAdmobAdNativeState extends State<FastAdmobAdNative> {
  late final NativeAd _adView;

  @override
  void initState() {
    super.initState();

    _adView = widget.adView!;
    _adView.load();
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.adView == null) {
      _adView.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastNativeAdContainerLayout(
      adSize: widget.adSize,
      child: AdWidget(ad: _adView),
    );
  }
}
