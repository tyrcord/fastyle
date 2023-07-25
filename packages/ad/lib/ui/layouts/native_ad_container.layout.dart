import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdContainerLayout extends StatelessWidget {
  final FastAdSize adSize;
  final Widget child;

  const FastNativeAdContainerLayout({
    super.key,
    required this.adSize,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final height = _getAdHeight(adSize);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: child,
      ),
    );
  }

  double _getAdHeight(FastAdSize size) {
    if (size == FastAdSize.large) {
      return 360;
    } else if (size == FastAdSize.medium) {
      return 144;
    }

    return 72;
  }
}
