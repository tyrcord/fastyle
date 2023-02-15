import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:flutter/material.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorClearAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  const FastCalculatorClearAction({
    super.key,
    required super.calculatorBloc,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: (previous, next) => previous.isDirty != next.isDirty,
      builder: (_, FastCalculatorBlocState state) {
        return FastIconButton(
          isEnabled: shouldEnableInteractions(state),
          icon: icon ?? const Icon(Icons.delete),
          iconAlignment: Alignment.centerRight,
          iconColor: primaryColor,
          shouldTrottleTime: true,
          onTap: () => calculatorBloc.addEvent(
            FastCalculatorBlocEvent.clear<R>(),
          ),
        );
      },
    );
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (state.isInitialized) {
      return state.isDirty;
    }

    return false;
  }
}
