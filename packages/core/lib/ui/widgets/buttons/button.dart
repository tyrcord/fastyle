// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

abstract class FastButton extends StatefulWidget {
  final Duration trottleTimeDuration;
  final FastButtonEmphasis emphasis;
  final EdgeInsetsGeometry? padding;
  final bool shouldTrottleTime;
  final Color? highlightColor;
  final Color? disabledColor;
  final Color? overlayColor;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool isEnabled;
  final bool upperCase;
  final String? text;
  final Widget? child;

  const FastButton({
    super.key,
    this.trottleTimeDuration = kFastTrottleTimeDuration,
    this.emphasis = FastButtonEmphasis.low,
    this.shouldTrottleTime = false,
    this.upperCase = false,
    this.isEnabled = true,
    this.highlightColor,
    this.disabledColor,
    this.overlayColor,
    this.textColor,
    this.padding,
    this.child,
    this.onTap,
    this.text,
  });
}
