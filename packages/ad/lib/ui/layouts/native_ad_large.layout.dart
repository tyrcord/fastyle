import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastNativeAdLargeLayout extends StatelessWidget {
  final FastAdSize adSize = FastAdSize.large;
  final Widget? detailsPlaceholder;
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? buttonText;
  final String? titleText;
  final Widget? icon;

  const FastNativeAdLargeLayout({
    super.key,
    this.detailsPlaceholder,
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
        Expanded(child: buildContent()),
        FastAdButton(text: buttonText, onTap: onButtonTap),
      ],
    );
  }

  Widget buildContent() {
    if (detailsPlaceholder != null) {
      return detailsPlaceholder!;
    }

    return FastAdDetails(
      descriptionText: descriptionText,
      titleText: titleText,
      adSize: adSize,
    );
  }
}
