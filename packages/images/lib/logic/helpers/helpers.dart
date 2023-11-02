import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';

Widget? buildFlagIconForCountry(
  String country, {
  Widget Function(String)? flagIconBuilder,
  bool hasShadow = true,
  double? height,
  double? width,
}) {
  final iconKey = toCamelCase(country);
  final hasIcon = kFastImageFlagMap.containsKey(iconKey);

  if (!hasIcon) return null;

  late Widget flagIcon;

  if (flagIconBuilder != null) {
    flagIcon = flagIconBuilder(country);
  } else {
    flagIcon = FastImageAsset(
      path: kFastImageFlagMap[iconKey]!,
      height: height,
      width: width,
    );
  }

  if (hasShadow) return FastShadowLayout(child: flagIcon);

  return flagIcon;
}
