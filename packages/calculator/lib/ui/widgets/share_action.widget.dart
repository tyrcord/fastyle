// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorShareAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  const FastCalculatorShareAction({
    super.key,
    required super.calculatorBloc,
    super.disabledColor,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: (previous, next) => previous.isValid != next.isValid,
      builder: (BuildContext context, FastCalculatorBlocState state) {
        return FastIconButton(
          isEnabled: shouldEnableInteractions(state),
          icon: icon ?? const Icon(Icons.share),
          disabledColor: disabledColor,
          shouldTrottleTime: true,
          onTap: () => calculatorBloc.addEvent(
            FastCalculatorBlocEvent.custom<R>('share', value: context),
          ),
        );
      },
    );
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (state.isInitialized) {
      return state.isValid && !state.isBusy;
    }

    return false;
  }
}
