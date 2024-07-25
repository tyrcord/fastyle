// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that performs an open computation.
class FastCalculatorOpenComputationToolbarButton<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorToolbarButton<B, R> {
  const FastCalculatorOpenComputationToolbarButton({
    super.key,
    required super.calculatorBloc,
    super.canEnableInteractions,
    super.disabledColor,
    super.semanticLabel,
    super.labelText,
    super.iconColor,
    super.tooltip,
    super.onTap,
    super.icon,
  });

  @override
  void handleTap(BuildContext context) {
    onTap?.call();
  }

  @override
  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightFolderOpen);
    }

    return const FaIcon(FontAwesomeIcons.folderOpen);
  }
}
