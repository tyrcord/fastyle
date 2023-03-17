import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:flutter/material.dart';

/// A [FastCalculatorAction] that refreshes the calculator results.
class FastCalculatorRefreshAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  const FastCalculatorRefreshAction({
    super.key,
    required super.calculatorBloc,
    super.disabledColor,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: (previous, next) => previous.isValid != next.isValid,
      builder: (_, FastCalculatorBlocState state) {
        return FastAnimatedRotationIconButton(
          isEnabled: shouldEnableInteractions(state),
          iconAlignment: Alignment.centerRight,
          disabledColor: disabledColor,
          shouldTrottleTime: true,
          iconColor: primaryColor,
          rotate: state.isBusy,
          icon: icon,
          onTap: () => calculatorBloc.addEvent(
            FastCalculatorBlocEvent.compute<R>(),
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
