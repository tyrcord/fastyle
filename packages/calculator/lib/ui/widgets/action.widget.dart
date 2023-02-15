import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/material.dart';

/// A calculator action widget.
/// Note: This widget is not meant to be used directly.
abstract class FastCalculatorAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  /// The calculator bloc to use.
  final B calculatorBloc;

  /// The icon to use.
  final Widget? icon;

  const FastCalculatorAction({
    super.key,
    required this.calculatorBloc,
    this.icon,
  });

  /// Whether the action should be enabled or not.
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    return state.isInitialized;
  }
}
