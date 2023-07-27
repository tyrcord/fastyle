// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
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
    final height = kFastNativeAdContainerHeights[adSize] ?? 0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: child,
      ),
    );
  }
}
