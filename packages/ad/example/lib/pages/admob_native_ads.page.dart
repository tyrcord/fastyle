import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class AdmobNativeAdsPage extends StatefulWidget {
  const AdmobNativeAdsPage({super.key});

  @override
  State<AdmobNativeAdsPage> createState() => _AdmobNativeAdsPageState();
}

class _AdmobNativeAdsPageState extends State<AdmobNativeAdsPage> {
  @override
  Widget build(BuildContext context) {
    return const FastSectionPage(
      titleText: 'Admob native Ads',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastTitle(text: 'Small native Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.small,
            loading: true,
          ),
          kFastSizedBox16,
          FastTitle(text: 'Medium native Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.medium,
            loading: true,
          ),
          kFastSizedBox16,
          FastTitle(text: 'Large native Ad'),
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
