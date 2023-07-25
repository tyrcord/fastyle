import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastNativeAdSmallLayout extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? buttonText;
  final FastAdSize adSize;
  final String? titleText;
  final Widget? icon;

  const FastNativeAdSmallLayout({
    super.key,
    this.adSize = FastAdSize.medium,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FastNativeAdIcon(adSize: adSize, icon: icon),
        kFastHorizontalSizedBox16,
        Expanded(
          child: FastAdDetails(
            titleText: titleText,
            adSize: adSize,
          ),
        ),
        FastAdButton(text: buttonText, onTap: onButtonTap),
      ],
    );
  }
}
