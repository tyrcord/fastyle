// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

abstract class FastButton2 extends StatefulWidget {
  final Duration trottleTimeDuration;
  final FastButtonEmphasis emphasis;
  final EdgeInsetsGeometry? padding;
  final bool shouldTrottleTime;
  final Color? highlightColor;
  final Color? disabledColor;
  final VoidCallback? onTap;
  final Color? hoverColor;
  final Color? focusColor;
  final bool isEnabled;

  const FastButton2({
    super.key,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.shouldTrottleTime = false,
    this.isEnabled = true,
    this.highlightColor,
    this.disabledColor,
    this.hoverColor,
    this.focusColor,
    this.padding,
    this.onTap,
  });
}
