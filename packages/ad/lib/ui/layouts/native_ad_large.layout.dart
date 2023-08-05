// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastLargeNativeAdLayout extends StatelessWidget {
  final FastAdSize adSize = FastAdSize.large;
  final Widget? detailsPlaceholder;
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? buttonText;
  final String? titleText;
  final double? rating;
  final Widget? icon;

  const FastLargeNativeAdLayout({
    super.key,
    this.detailsPlaceholder,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.rating,
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
        if (buttonText != null)
        FastRaisedButton(text: buttonText, onTap: onButtonTap),
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
      rating: rating,
    );
  }
}
