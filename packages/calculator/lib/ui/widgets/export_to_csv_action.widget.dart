// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorExportToCsvAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  final bool Function(FastCalculatorBlocState state)? canEnableInteractions;

  static const iconSize = kFastIconSizeSmall;

  final Color? color;

  const FastCalculatorExportToCsvAction({
    super.key,
    required super.calculatorBloc,
    this.canEnableInteractions,
    super.disabledColor,
    super.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      buildWhen: _buildWhen,
      bloc: calculatorBloc,
      builder: _buildButton,
    );
  }

  Widget _buildButton(BuildContext context, FastCalculatorBlocState state) {
    return FastIconButton(
      isEnabled: shouldEnableInteractions(state),
      onTap: () => handleTap(context),
      disabledColor: disabledColor,
      icon: buildIcon(context),
      shouldTrottleTime: true,
      iconColor: color,
    );
  }

  bool _buildWhen(
    FastCalculatorBlocState previous,
    FastCalculatorBlocState next,
  ) {
    return previous.isValid != next.isValid;
  }

  void handleTap(BuildContext context) {
    calculatorBloc.addEvent(FastCalculatorBlocEvent.exportToCsv(context));
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightFileCsv, size: iconSize);
    }

    return const FaIcon(FontAwesomeIcons.fileCsv, size: iconSize);
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (canEnableInteractions != null) return canEnableInteractions!(state);

    return state.isInitialized && state.isValid && !state.isBusy;
  }
}
