// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';

class LoadingAdsPage extends StatefulWidget {
  const LoadingAdsPage({super.key});

  @override
  State<LoadingAdsPage> createState() => _LoadingAdsPageState();
}

class _LoadingAdsPageState extends State<LoadingAdsPage> {
  @override
  Widget build(BuildContext context) {
    return const FastSectionPage(
      titleText: 'Loading Ads',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastTitle(text: 'Small Loading Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.small,
            loading: true,
          ),
          kFastSizedBox16,
          FastTitle(text: 'Medium Loading Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.medium,
            loading: true,
          ),
          kFastSizedBox16,
          FastTitle(text: 'Large Loading Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.large,
            loading: true,
          ),
          kFastSizedBox16,
        ],
      ),
    );
  }
}
