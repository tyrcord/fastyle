import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class FastCalculatorShareAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  final B calculatorBloc;
  final Widget? icon;

  bool get _isReady => calculatorBloc.currentState.isInitialized;

  bool get _shouldPreventInteractions {
    final currentState = calculatorBloc.currentState;

    return !currentState.isValid || currentState.isBusy;
  }

  const FastCalculatorShareAction({
    Key? key,
    required this.calculatorBloc,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        return FastIconButton(
          isEnabled: _isReady && !_shouldPreventInteractions,
          icon: icon ?? const Icon(Icons.share),
          shouldTrottleTime: true,
          onTap: () => calculatorBloc.addEvent(
            FastCalculatorBlocEvent.custom<R>('share'),
          ),
        );
      },
    );
  }
}
