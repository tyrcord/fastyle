// Flutter imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:flutter/material.dart';

// Package imports:
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
    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: _buildWhen,
      builder: (_, FastCalculatorBlocState state) {
        return FastAnimatedRotationIconButton2(
          isEnabled: shouldEnableInteractions(state),
          emphasis: FastButtonEmphasis.high,
          disabledColor: disabledColor,
          shouldTrottleTime: true,
          rotate: state.isBusy,
          onTap: _handleTap,
          icon: icon,
        );
      },
    );
  }

  bool _buildWhen(
    FastCalculatorBlocState previous,
    FastCalculatorBlocState next,
  ) {
    return previous.isBusy != next.isBusy || previous.isValid != next.isValid;
  }

  void _handleTap() {
    calculatorBloc.addEvent(FastCalculatorBlocEvent.compute<R>());
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    return state.isInitialized && state.isValid && !state.isBusy;
  }
}
