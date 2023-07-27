// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdIcon extends StatelessWidget {
  final Widget? icon;
  final FastAdSize adSize;
  final AlignmentGeometry alignment;

  const FastNativeAdIcon({
    super.key,
    this.icon,
    this.adSize = FastAdSize.medium,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = kFastNativeAdAssetSizes[adSize] ?? 0;

    return SizedBox(
      height: iconSize,
      width: iconSize,
      child: Align(
        alignment: alignment,
        child: icon,
      ),
    );
  }
}
