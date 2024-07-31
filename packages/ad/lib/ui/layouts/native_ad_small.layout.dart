// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastSmallNativeAdLayout extends StatelessWidget {
  final FastAdSize adSize = FastAdSize.small;
  final Widget? detailsPlaceholder;
  final VoidCallback? onButtonTap;
  final String? buttonText;
  final String? titleText;
  final Widget? icon;
  final double? rating;

  const FastSmallNativeAdLayout({
    super.key,
    this.detailsPlaceholder,
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FastNativeAdIcon(adSize: adSize, icon: icon),
        kFastHorizontalSizedBox16,
        Expanded(
          child: SizedBox(
            height: iconSize,
            child: buildContent(),
          ),
        ),
        if (detailsPlaceholder == null && buttonText != null)
          FastRaisedButton2(labelText: buttonText, onTap: onButtonTap),
      ],
    );
  }

  Widget buildContent() {
    if (detailsPlaceholder != null) {
      return detailsPlaceholder!;
    }

    return FastAdDetails(
      titleText: titleText,
      adSize: adSize,
      rating: rating,
    );
  }
}
