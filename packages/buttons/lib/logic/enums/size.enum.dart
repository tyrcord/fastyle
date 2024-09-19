import 'package:fastyle_buttons/logic/enums/spec.dart';

enum FastButtonSize {
  small,
  medium,
  large;

  FastIconButtonSpec get iconSpec {
    switch (this) {
      case small:
        return FastIconButtonSpec.small;
      case medium:
        return FastIconButtonSpec.medium;
      case large:
        return FastIconButtonSpec.large;
    }
  }

  FastButtonSpec get spec {
    switch (this) {
      case small:
        return FastButtonSpec.small;
      case medium:
        return FastButtonSpec.medium;
      case large:
        return FastButtonSpec.large;
    }
  }
}
