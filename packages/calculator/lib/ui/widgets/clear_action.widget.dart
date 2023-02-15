import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class FastCalculatorClearAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  final Widget? icon;
  final B calculatorBloc;

  bool get _isReady => calculatorBloc.currentState.isInitialized;

  const FastCalculatorClearAction({
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
            previous.isDirty != next.isDirty;
      },
      builder: (_, FastCalculatorBlocState state) {
        return FastIconButton(
          iconAlignment: Alignment.centerRight,
          isEnabled: _isReady && state.isDirty,
          icon: icon ?? const Icon(Icons.delete),
          shouldTrottleTime: true,
          iconColor: primaryColor,
          onTap: () => calculatorBloc.addEvent(
            FastCalculatorBlocEvent.clear<R>(),
          ),
        );
      },
    );
  }
}
