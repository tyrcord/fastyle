// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class FastBackButton extends FastPopButton {
  const FastBackButton({
    super.key,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    super.shouldTrottleTime = true,
    super.isEnabled = true,
    super.highlightColor,
    super.iconAlignment,
    super.disabledColor,
    super.semanticLabel,
    super.constraints,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    super.iconColor,
    super.flexible,
    super.iconSize,
    super.tooltip,
    super.padding,
    super.onTap,
    super.icon,
  });

  @override
  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightChevronLeft);
    }

    return const FaIcon(FontAwesomeIcons.chevronLeft);
  }
}
