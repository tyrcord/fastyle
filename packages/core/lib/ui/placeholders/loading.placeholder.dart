import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';

class FastLoadingBoxPlaceholder extends StatelessWidget {
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? baseColor;
  final double? height;
  final double? width;
  final Widget? child;

  const FastLoadingBoxPlaceholder({
    super.key,
    this.backgroundColor,
    this.highlightColor,
    this.baseColor,
    this.height,
    this.width,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    //FIXME: update default colors when migrating fastyle_dart to melos
    return FastShimmer(
      highlightColor: highlightColor,
      baseColor: baseColor,
      child: FastBoxPlaceholder(
        color: backgroundColor,
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
