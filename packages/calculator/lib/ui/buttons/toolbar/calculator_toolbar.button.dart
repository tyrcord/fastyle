// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that clears the calculator state.
abstract class FastCalculatorToolbarButton<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  final bool Function(FastCalculatorBlocState state)? canEnableInteractions;

  final String? labelText;

  const FastCalculatorToolbarButton({
    super.key,
    required super.calculatorBloc,
    this.canEnableInteractions,
    super.disabledColor,
    super.semanticLabel,
    super.iconColor,
    super.tooltip,
    super.onTap,
    super.icon,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      buildWhen: buildWhen,
      bloc: calculatorBloc,
      builder: buildButton,
    );
  }

  Widget buildButton(BuildContext context, FastCalculatorBlocState state) {
    return FastToolBarButton(
      isEnabled: shouldEnableInteractions(state),
      onTap: () => handleTap(context),
      disabledColor: disabledColor,
      semanticLabel: semanticLabel,
      icon: buildIcon(context),
      shouldTrottleTime: true,
      iconColor: iconColor,
      labelText: labelText,
      tooltip: tooltip,
    );
  }

  bool buildWhen(
    FastCalculatorBlocState previous,
    FastCalculatorBlocState next,
  ) {
    return previous.isValid != next.isValid;
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (canEnableInteractions != null) return canEnableInteractions!(state);

    return state.isInitialized;
  }

  void handleTap(BuildContext context);

  Widget buildIcon(BuildContext context);
}
