import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class FastCalculatorRefreshAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  final B calculatorBloc;
  final Widget? icon;

  bool get _isReady => calculatorBloc.currentState.isInitialized;

  bool get _shouldPreventInteractions {
    final currentState = calculatorBloc.currentState;

    return !currentState.isValid || currentState.isBusy;
  }

  const FastCalculatorRefreshAction({
    Key? key,
    required this.calculatorBloc,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: (
        FastCalculatorBlocState previous,
        FastCalculatorBlocState next,
      ) {
        return previous.isInitialized != next.isInitialized ||
            previous.isBusy != next.isBusy ||
            previous.isValid != next.isValid;
      },
      builder: (_, FastCalculatorBlocState state) {
        return FastAnimatedRotationIconButton(
          iconAlignment: Alignment.centerRight,
          isEnabled: _isReady && !_shouldPreventInteractions,
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
}
