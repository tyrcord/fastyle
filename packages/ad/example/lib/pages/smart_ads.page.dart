// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';

class SmartAdsPage extends StatefulWidget {
  const SmartAdsPage({super.key});

  @override
  State<SmartAdsPage> createState() => SmartAdsPageState();
}

class SmartAdsPageState extends State<SmartAdsPage> {
  @override
  Widget build(BuildContext context) {
    return const FastSectionPage(
      titleText: 'Smart Ads',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastTitle(text: 'Medium smart Ad'),
          kFastSizedBox16,
          FastSmartNativeAd(
            debugLabel: 'Smart Medium Native Ad',
          ),
        ],
      ),
    );
  }
}
