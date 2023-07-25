import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastNativeAdMediumLayout extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? buttonText;
  final FastAdSize adSize;
  final String? titleText;
  final Widget? icon;

  const FastNativeAdMediumLayout({
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FastNativeAdIcon(adSize: adSize, icon: icon),
        kFastHorizontalSizedBox16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FastAdDetails(
                descriptionText: descriptionText,
                titleText: titleText,
                adSize: adSize,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FastAdButton(text: buttonText, onTap: onButtonTap),
              )
            ],
          ),
        ),
      ],
    );
  }
}
