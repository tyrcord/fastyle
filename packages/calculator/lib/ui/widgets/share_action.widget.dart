import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:flutter/material.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorShareAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  const FastCalculatorShareAction({
    super.key,
    required super.calculatorBloc,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: (previous, next) => previous.isValid != next.isValid,
      builder: (_, FastCalculatorBlocState state) {
        return FastIconButton(
          isEnabled: shouldEnableInteractions(state),
          icon: icon ?? const Icon(Icons.share),
          shouldTrottleTime: true,
          onTap: () => calculatorBloc.addEvent(
            FastCalculatorBlocEvent.custom<R>('share'),
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
