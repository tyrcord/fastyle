import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

enum FastIconButtonSpec {
  small,
  medium,
  large;

  BoxConstraints get constraints {
    switch (this) {
      case FastIconButtonSpec.small:
        return const BoxConstraints(minWidth: 32, minHeight: 32);
      case FastIconButtonSpec.medium:
        return const BoxConstraints(minWidth: 40, minHeight: 40);
      case FastIconButtonSpec.large:
        return const BoxConstraints(minWidth: 48, minHeight: 48);
    }
  }

  double get iconSize {
    switch (this) {
      case FastIconButtonSpec.small:
        return kFastIconSizeXxs;
      case FastIconButtonSpec.medium:
        return kFastIconSizeSmall;
      case FastIconButtonSpec.large:
        return kFastIconSizeLarge;
    }
  }
}

enum FastButtonSpec {
  small,
  medium,
  large;

  BoxConstraints get constraints {
    switch (this) {
      case FastButtonSpec.small:
        return const BoxConstraints(minWidth: 48, minHeight: 32);
      case FastButtonSpec.medium:
        return const BoxConstraints(minWidth: 60, minHeight: 40);
      case FastButtonSpec.large:
        return const BoxConstraints(minWidth: 76, minHeight: 48);
    }
  }

  double get fontSize {
    switch (this) {
      case FastButtonSpec.small:
        return kFastFontSize12;
      case FastButtonSpec.medium:
        return kFastFontSize16;
      case FastButtonSpec.large:
        return kFastFontSize20;
    }
  }
}
