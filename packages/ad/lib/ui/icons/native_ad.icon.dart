import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdIcon extends StatelessWidget {
  final Widget? icon;
  final FastAdSize adSize;

  const FastNativeAdIcon({
    super.key,
    this.icon,
    this.adSize = FastAdSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = kFastNativeAdIconSize[adSize] ?? 0;

    return SizedBox(
      height: iconSize,
      width: iconSize,
      child: Center(
        child: icon,
      ),
    );
  }
}
