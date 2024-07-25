// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorExportToPdfToolbarButton<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorToolbarButton<B, R> {
  const FastCalculatorExportToPdfToolbarButton({
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
    calculatorBloc.addEvent(FastCalculatorBlocEvent.exportToPdf(context));
  }

  @override
  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightFilePdf);
    }

    return const FaIcon(FontAwesomeIcons.filePdf);
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (canEnableInteractions != null) return canEnableInteractions!(state);

    return state.isInitialized && state.isValid && !state.isBusy;
  }
}
