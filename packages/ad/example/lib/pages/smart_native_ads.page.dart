// Flutter imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

class SmartNativeAdsPage extends StatefulWidget {
  const SmartNativeAdsPage({super.key});

  @override
  State<SmartNativeAdsPage> createState() => _SmartNativeAdsPageState();
}

class _SmartNativeAdsPageState extends State<SmartNativeAdsPage> {
  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      floatingActionButton: FastRaisedButton2(
        labelText: 'Show',
        onTap: () => GoRouter.of(context).go('/smart-native/cover'),
      ),
      titleText: 'Smart Native Ads',
      isViewScrollable: true,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastTitle(text: 'Medium native Ad'),
          kFastSizedBox16,
          FastSmartNativeAd(
            debugLabel: 'Admob Medium Native Ad',
            showRemoveAdLink: true,
          ),
          kFastSizedBox16,
          FastTitle(text: 'Native Ad with a ID'),
          kFastSizedBox16,
          FastSmartNativeAd(
            debugLabel: 'Native Ad with a Id',
            adId: 'fx_qal',
          ),
          kFastSizedBox16,
        ],
      ),
    );
  }
}
