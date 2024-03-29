// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

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
      buildWhen: (previous, next) {
        return previous.isBusy != next.isBusy ||
            previous.isValid != next.isValid;
      },
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
    return state.isInitialized && state.isValid && !state.isBusy;
  }
}
