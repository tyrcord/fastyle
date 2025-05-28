// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

final kFastTabBarTheme = TabBarThemeData(
  indicatorSize: TabBarIndicatorSize.label,
  labelStyle: kFastTextTheme.bodyLarge,
  unselectedLabelStyle: kFastTextTheme.bodyLarge!.copyWith(
    fontWeight: kFastFontWeightLight,
  ),
);
