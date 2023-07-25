import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastNativeAdLargeLayout extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? buttonText;
  final FastAdSize adSize;
  final String? titleText;
  final Widget? icon;

  const FastNativeAdLargeLayout({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FastNativeAdIcon(adSize: adSize, icon: icon),
        kFastVerticalSizedBox8,
        FastAdDetails(
          descriptionText: descriptionText,
          titleText: titleText,
          adSize: adSize,
        ),
        FastAdButton(text: buttonText, onTap: onButtonTap),
      ],
    );
  }
}
