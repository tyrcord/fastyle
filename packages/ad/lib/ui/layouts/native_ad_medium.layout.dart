// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastMediumNativeAdLayout extends StatelessWidget {
  final FastAdSize adSize = FastAdSize.medium;
  final Widget? detailsPlaceholder;
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? buttonText;
  final String? titleText;
  final double? rating;
  final Widget? icon;

  const FastMediumNativeAdLayout({
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
    final iconSize = kFastNativeAdAssetSizes[adSize] ?? 0;

    return Row(
      children: [
        FastNativeAdIcon(
          alignment: Alignment.topCenter,
          adSize: adSize,
          icon: icon,
        ),
        kFastHorizontalSizedBox16,
        Expanded(
          child: SizedBox(
            height: iconSize,
            child: Column(
              children: [
                Expanded(child: buildContent()),
                if (buttonText != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FastRaisedButton(
                      text: buttonText,
                      onTap: onButtonTap,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    if (detailsPlaceholder != null) {
      return detailsPlaceholder!;
    }

    return FastAdDetails(
      maxLines: buttonText != null ? 2 : 5,
      descriptionText: descriptionText,
      titleText: titleText,
      adSize: adSize,
      rating: rating,
    );
  }
}
