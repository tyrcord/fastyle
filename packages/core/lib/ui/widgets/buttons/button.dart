// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

abstract class FastButton extends StatefulWidget {
  final Duration trottleTimeDuration;
  final FastButtonEmphasis emphasis;
  final EdgeInsetsGeometry? padding;
  final bool shouldTrottleTime;
  final Color? highlightColor;
  final Color? hoverColor;
  final Color? disabledColor;
  final Color? focusColor;
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
    this.hoverColor,
    this.focusColor,
    this.disabledColor,
    this.textColor,
    this.padding,
    this.child,
    this.onTap,
    this.text,
  });
}
